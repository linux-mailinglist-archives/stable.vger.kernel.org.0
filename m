Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D2EED50
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389837AbfKDWF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389266AbfKDWF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:26 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9598C218BA;
        Mon,  4 Nov 2019 22:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905126;
        bh=uA6XdKv2+2SDhsP+E379mscL9KCCmxo7feDnHtH9r3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MkFi2jO69Nu5wPgHisfE4gfHCrXVutyLdiEwUWRiglec9tIuCJCCvljwu1/XfXZE
         emtCDECvwfCcyzLXX4/f6CqnfI/DFcM2b+jy/jAv5bgQ/5s/Chp+Ovl33W12F0H/CM
         qaf1huj7D7w/r+zudtCFuFW6+DHDzJBPS7tH3030=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 036/163] misc: fastrpc: prevent memory leak in fastrpc_dma_buf_attach
Date:   Mon,  4 Nov 2019 22:43:46 +0100
Message-Id: <20191104212142.834864609@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



