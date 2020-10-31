Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE032A162E
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgJaLmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgJaLmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5D020739;
        Sat, 31 Oct 2020 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144562;
        bh=ziZaFmWCwafFO1YFugQ5nDo23sdJhf759kGyLiEUJ10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQKaA/AYUIbZBgBMvesrQU9CNqMIE6SsdvEk88XL343QajrlrFmdwNxy03Qp4Pp0Y
         WGTFus18cb0GZrHi1cVZy0YWVZlpCM/x4A2OUrAtzI0vGbQBK4MlX28nJ/aCtiDAsT
         7JGBhayAp6k0naduMbA187Cs9BkDg0wIZx2+JWXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Christoph Hellwig <hch@lst.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 66/70] ata: sata_rcar: Fix DMA boundary mask
Date:   Sat, 31 Oct 2020 12:36:38 +0100
Message-Id: <20201031113502.644832267@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit df9c590986fdb6db9d5636d6cd93bc919c01b451 upstream.

Before commit 9495b7e92f716ab2 ("driver core: platform: Initialize
dma_parms for platform devices"), the R-Car SATA device didn't have DMA
parameters.  Hence the DMA boundary mask supplied by its driver was
silently ignored, as __scsi_init_queue() doesn't check the return value
of dma_set_seg_boundary(), and the default value of 0xffffffff was used.

Now the device has gained DMA parameters, the driver-supplied value is
used, and the following warning is printed on Salvator-XS:

    DMA-API: sata_rcar ee300000.sata: mapping sg segment across boundary [start=0x00000000ffffe000] [end=0x00000000ffffefff] [boundary=0x000000001ffffffe]
    WARNING: CPU: 5 PID: 38 at kernel/dma/debug.c:1233 debug_dma_map_sg+0x298/0x300

(the range of start/end values depend on whether IOMMU support is
 enabled or not)

The issue here is that SATA_RCAR_DMA_BOUNDARY doesn't have bit 0 set, so
any typical end value, which is odd, will trigger the check.

Fix this by increasing the DMA boundary value by 1.

This also fixes the following WRITE DMA EXT timeout issue:

    # dd if=/dev/urandom of=/mnt/de1/file1-1024M bs=1M count=1024
    ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
    ata1.00: failed command: WRITE DMA EXT
    ata1.00: cmd 35/00:00:00:e6:0c/00:0a:00:00:00/e0 tag 0 dma 1310720 out
    res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
    ata1.00: status: { DRDY }

as seen by Shimoda-san since commit 429120f3df2dba2b ("block: fix
splitting segments on boundary masks").

Fixes: 8bfbeed58665dbbf ("sata_rcar: correct 'sata_rcar_sht'")
Fixes: 9495b7e92f716ab2 ("driver core: platform: Initialize dma_parms for platform devices")
Fixes: 429120f3df2dba2b ("block: fix splitting segments on boundary masks")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_rcar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -120,7 +120,7 @@
 /* Descriptor table word 0 bit (when DTA32M = 1) */
 #define SATA_RCAR_DTEND			BIT(0)
 
-#define SATA_RCAR_DMA_BOUNDARY		0x1FFFFFFEUL
+#define SATA_RCAR_DMA_BOUNDARY		0x1FFFFFFFUL
 
 /* Gen2 Physical Layer Control Registers */
 #define RCAR_GEN2_PHY_CTL1_REG		0x1704


