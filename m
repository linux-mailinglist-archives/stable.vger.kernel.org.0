Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598CC2A5651
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbgKCVZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387568AbgKCVCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:02:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B840420658;
        Tue,  3 Nov 2020 21:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437326;
        bh=Y94bS825I46t6kx1vs03CSmnAJfoD+XnMDcOJcT0abk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Z7NzFg6BhI7QF4Djsq0rDwpjhkKIWUNC0UVqXBoazYGtj/Ixq1azsnuf7KYuJnJH
         Yo8wlh1TzDthAOgPcqSe2pMYyu7Z0/bUUF6rOdD8+aFex4qKbefoNN2po+QX3HCvS3
         UqmSWGXQ9u657CubdefWCDSKC5/YAFkAfaFPHDkU=
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
Subject: [PATCH 4.19 028/191] ata: sata_rcar: Fix DMA boundary mask
Date:   Tue,  3 Nov 2020 21:35:20 +0100
Message-Id: <20201103203236.363359597@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -124,7 +124,7 @@
 /* Descriptor table word 0 bit (when DTA32M = 1) */
 #define SATA_RCAR_DTEND			BIT(0)
 
-#define SATA_RCAR_DMA_BOUNDARY		0x1FFFFFFEUL
+#define SATA_RCAR_DMA_BOUNDARY		0x1FFFFFFFUL
 
 /* Gen2 Physical Layer Control Registers */
 #define RCAR_GEN2_PHY_CTL1_REG		0x1704


