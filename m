Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3AA38A6B3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhETK3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236803AbhETK2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F9B61C2C;
        Thu, 20 May 2021 09:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504257;
        bh=mhxo0Y4O+//2DH4/zYXUM/1/ZzLnbPkrIy1xHvogl6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXPPvioI97R7Ield3/t2736lFXS7ARnwMtZHubijREfG5p/RJpl7ybpELiOK5JCDk
         aNs0oFFNm8K5ZH+6q1HUNU+3+Su1oQsBpN5P7otAbGdNS5eci431PqHlLTmAKyZ4th
         3gVS4yK6ZUwdsxwV3QE3z7BM9/eb62n6jWGOxPJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 162/323] mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init
Date:   Thu, 20 May 2021 11:20:54 +0200
Message-Id: <20210520092125.659517689@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 076de75de1e53160e9b099f75872c1f9adf41a0b ]

If the callee gpmi_alloc_dma_buffer() failed to alloc memory for
this->raw_buffer, gpmi_free_dma_buffer() will be called to free
this->auxiliary_virt. But this->auxiliary_virt is still a non-NULL
and valid ptr.

Then gpmi_alloc_dma_buffer() returns err and gpmi_free_dma_buffer()
is called again to free this->auxiliary_virt in err_out. This causes
a double free.

As gpmi_free_dma_buffer() has already called in gpmi_alloc_dma_buffer's
error path, so it should return err directly instead of releasing the dma
buffer again.

Fixes: 4d02423e9afe6 ("mtd: nand: gpmi: Fix gpmi_nand_init() error path")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210403060905.5251-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index c7d0d2eed6c2..5a694bdc4f75 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -2022,7 +2022,7 @@ static int gpmi_nand_init(struct gpmi_nand_data *this)
 	this->bch_geometry.auxiliary_size = 128;
 	ret = gpmi_alloc_dma_buffer(this);
 	if (ret)
-		goto err_out;
+		return ret;
 
 	ret = nand_scan_ident(mtd, GPMI_IS_MX6(this) ? 2 : 1, NULL);
 	if (ret)
-- 
2.30.2



