Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3146B38A926
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhETK62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237704AbhETK4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CA116141C;
        Thu, 20 May 2021 10:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504912;
        bh=JmDvZXWy+Jc27NKZWL+WoDK+hpW72GjNPlnBBdJAO+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Le9IXu3W9myjEOdBJzUpRaEkIOhzvwjqBwAmuai7Ekd0PyaQQEYJUmr5+zUCOrPRy
         LZUXwZBfo8zC3pOGr/Shx8k3bRa8jSWJ5D02alMmbOgsovkh8rhE75dJoZ1OArK+6x
         UUyHghouJQ/b05JDN/f16WnQzwhJ5Ym0rmx6dJEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 110/240] mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init
Date:   Thu, 20 May 2021 11:21:42 +0200
Message-Id: <20210520092112.376419100@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index f4a99e91c250..c43bd945d93a 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -2020,7 +2020,7 @@ static int gpmi_nand_init(struct gpmi_nand_data *this)
 	this->bch_geometry.auxiliary_size = 128;
 	ret = gpmi_alloc_dma_buffer(this);
 	if (ret)
-		goto err_out;
+		return ret;
 
 	ret = nand_scan_ident(mtd, GPMI_IS_MX6(this) ? 2 : 1, NULL);
 	if (ret)
-- 
2.30.2



