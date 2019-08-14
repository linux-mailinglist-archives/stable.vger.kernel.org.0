Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D9F8DA6E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfHNRMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbfHNRMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:12:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 660DE2084D;
        Wed, 14 Aug 2019 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802766;
        bh=bvXAwH0S25j0YdHglPqNUbLqwyWi3BxhSqRlgEfvOZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HT6BLhFvCvK+Yd6+nIHXXyjSaMN3gePfli1pM3UsihXdO5mNFo2AkBL+Y2LiFZtnn
         NIoWe6gfHt0RXrOFKLHTzniGZQ6sFDEhu9M0Db7IHPFIEaRS40LZRoKfSUcGMl5aNt
         qyQfgafykgkAuR2koJexuth7aNWYtikmYMCR1afM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 08/69] mmc: cavium: Add the missing dma unmap when the dma has finished.
Date:   Wed, 14 Aug 2019 19:01:06 +0200
Message-Id: <20190814165745.897353033@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit b803974a86039913d5280add083d730b2b9ed8ec upstream.

This fixes the below calltrace when the CONFIG_DMA_API_DEBUG is enabled.
  DMA-API: thunderx_mmc 0000:01:01.4: cpu touching an active dma mapped cacheline [cln=0x000000002fdf9800]
  WARNING: CPU: 21 PID: 1 at kernel/dma/debug.c:596 debug_dma_assert_idle+0x1f8/0x270
  Modules linked in:
  CPU: 21 PID: 1 Comm: init Not tainted 5.3.0-rc1-next-20190725-yocto-standard+ #64
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  pstate: 80400009 (Nzcv daif +PAN -UAO)
  pc : debug_dma_assert_idle+0x1f8/0x270
  lr : debug_dma_assert_idle+0x1f8/0x270
  sp : ffff0000113cfc10
  x29: ffff0000113cfc10 x28: 0000ffff8c880000
  x27: ffff800bc72a0000 x26: ffff000010ff8000
  x25: ffff000010ff8940 x24: ffff000010ff8968
  x23: 0000000000000000 x22: ffff000010e83700
  x21: ffff000010ea2000 x20: ffff000010e835c8
  x19: ffff800bc2c73300 x18: ffffffffffffffff
  x17: 0000000000000000 x16: 0000000000000000
  x15: ffff000010e835c8 x14: 6d20616d64206576
  x13: 69746361206e6120 x12: 676e696863756f74
  x11: 20757063203a342e x10: 31303a31303a3030
  x9 : 303020636d6d5f78 x8 : 3230303030303030
  x7 : 00000000000002fd x6 : ffff000010fd57d0
  x5 : 0000000000000000 x4 : ffff0000106c5210
  x3 : 00000000ffffffff x2 : 0000800bee9c0000
  x1 : 57d5843f4aa62800 x0 : 0000000000000000
  Call trace:
   debug_dma_assert_idle+0x1f8/0x270
   wp_page_copy+0xb0/0x688
   do_wp_page+0xa8/0x5b8
   __handle_mm_fault+0x600/0xd00
   handle_mm_fault+0x118/0x1e8
   do_page_fault+0x200/0x500
   do_mem_abort+0x50/0xb0
   el0_da+0x20/0x24
  ---[ end trace a005534bd23e109f ]---
  DMA-API: Mapped at:
   debug_dma_map_sg+0x94/0x350
   cvm_mmc_request+0x3c4/0x988
   __mmc_start_request+0x9c/0x1f8
   mmc_start_request+0x7c/0xb0
   mmc_blk_mq_issue_rq+0x5c4/0x7b8

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Fixes: ba3869ff32e4 ("mmc: cavium: Add core MMC driver for Cavium SOCs")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/cavium.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/cavium.c
+++ b/drivers/mmc/host/cavium.c
@@ -374,6 +374,7 @@ static int finish_dma_single(struct cvm_
 {
 	data->bytes_xfered = data->blocks * data->blksz;
 	data->error = 0;
+	dma_unmap_sg(host->dev, data->sg, data->sg_len, get_dma_dir(data));
 	return 1;
 }
 


