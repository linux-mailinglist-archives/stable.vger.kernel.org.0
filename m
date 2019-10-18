Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C106DD4BE
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406279AbfJRW0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbfJRWEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A32ED222CC;
        Fri, 18 Oct 2019 22:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436248;
        bh=uA6XdKv2+2SDhsP+E379mscL9KCCmxo7feDnHtH9r3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L28NQ9e/Hk/n7Sv5FOn4DSVbWVWtl80vejYdkQLoSlofmVLK1ugOhGewk8OmIQOPy
         QHUjMjcoK/QH0ZdjKaZDb7B/MWIjvgIz4Y9lKd/i4DFQndlurariAVTQM7Utmc/spQ
         aFwfi35Cr7NkOxAIOS+j5TzpVBGtNFJ6JSzHzm/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 32/89] misc: fastrpc: prevent memory leak in fastrpc_dma_buf_attach
Date:   Fri, 18 Oct 2019 18:02:27 -0400
Message-Id: <20191018220324.8165-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit fc739a058d99c9297ef6bfd923b809d85855b9a9 ]

In fastrpc_dma_buf_attach if dma_get_sgtable fails the allocated memory
for a should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20190925152742.16258-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 98603e235cf04..a76b6c6fd660f 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -499,6 +499,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 			      FASTRPC_PHYS(buffer->phys), buffer->size);
 	if (ret < 0) {
 		dev_err(buffer->dev, "failed to get scatterlist from DMA API\n");
+		kfree(a);
 		return -EINVAL;
 	}
 
-- 
2.20.1

