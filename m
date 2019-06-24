Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D673F50889
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfFXKSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbfFXKQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:14 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7769D20645;
        Mon, 24 Jun 2019 10:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371374;
        bh=dCYuUHsFqV7uKyvtqq6FlM4P/lhE4gHZNSKblgjLo6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMhDN5zzabyzv860nUqicoAPkO7ofjvIn0jqlWHZHvLh71yBBXfK0CObmD+QISFfT
         2PTWb2dcW8FcLDP28ixdgxhFlAdUoshs7RusjsMWTbOL1iqpw0tIZHOzgcyFWVnlOC
         B+Hu+arcuRlGrAZa8wfrSk5zkOq7uFW/rREEad2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 080/121] udmabuf: actually unmap the scatterlist
Date:   Mon, 24 Jun 2019 17:56:52 +0800
Message-Id: <20190624092324.958730722@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 283f1e383e91d96fe652fad549537ae15cf31d60 ]

unmap_udmabuf fails to actually unmap the scatterlist, leaving dangling
mappings around.

Fixes: fbb0de795078 ("Add udmabuf misc device")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: http://patchwork.freedesktop.org/patch/msgid/20190604202331.17482-1-l.stach@pengutronix.de
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index cd57747286f2..9635897458a0 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -77,6 +77,7 @@ static void unmap_udmabuf(struct dma_buf_attachment *at,
 			  struct sg_table *sg,
 			  enum dma_data_direction direction)
 {
+	dma_unmap_sg(at->dev, sg->sgl, sg->nents, direction);
 	sg_free_table(sg);
 	kfree(sg);
 }
-- 
2.20.1



