Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BDC469B24
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349728AbhLFPNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:13:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42844 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356203AbhLFPLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:11:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2049CB810E7;
        Mon,  6 Dec 2021 15:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EC3C341C2;
        Mon,  6 Dec 2021 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803258;
        bh=DKTZsgL1vGm6uDJ9ysr+h3FsRIIB2g7Mp0D4TK299v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm8lLqe92gMXw08xnY3u1Wg4UQB6So3dDVGJnOuki+rdiX8iYmW9/0IJFBzPOClrR
         tmQ9p6YTCAGuB4CMlBk2sghy29SuMdA457JAGnL2ZedisK0uNXv83BALvfxAODxp9Y
         SJRKi8a272G1fN+iRh8sjAj+TgKGC+a7Ce4Ip/t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.14 085/106] sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl
Date:   Mon,  6 Dec 2021 15:56:33 +0100
Message-Id: <20211206145558.453615062@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 6c8ad7e8cf29eb55836e7a0215f967746ab2b504 upstream.

When the `rmmod sata_fsl.ko` command is executed in the PPC64 GNU/Linux,
a bug is reported:
 ==================================================================
 BUG: Unable to handle kernel data access on read at 0x80000800805b502c
 Oops: Kernel access of bad area, sig: 11 [#1]
 NIP [c0000000000388a4] .ioread32+0x4/0x20
 LR [80000000000c6034] .sata_fsl_port_stop+0x44/0xe0 [sata_fsl]
 Call Trace:
  .free_irq+0x1c/0x4e0 (unreliable)
  .ata_host_stop+0x74/0xd0 [libata]
  .release_nodes+0x330/0x3f0
  .device_release_driver_internal+0x178/0x2c0
  .driver_detach+0x64/0xd0
  .bus_remove_driver+0x70/0xf0
  .driver_unregister+0x38/0x80
  .platform_driver_unregister+0x14/0x30
  .fsl_sata_driver_exit+0x18/0xa20 [sata_fsl]
  .__se_sys_delete_module+0x1ec/0x2d0
  .system_call_exception+0xfc/0x1f0
  system_call_common+0xf8/0x200
 ==================================================================

The triggering of the BUG is shown in the following stack:

driver_detach
  device_release_driver_internal
    __device_release_driver
      drv->remove(dev) --> platform_drv_remove/platform_remove
        drv->remove(dev) --> sata_fsl_remove
          iounmap(host_priv->hcr_base);			<---- unmap
          kfree(host_priv);                             <---- free
      devres_release_all
        release_nodes
          dr->node.release(dev, dr->data) --> ata_host_stop
            ap->ops->port_stop(ap) --> sata_fsl_port_stop
                ioread32(hcr_base + HCONTROL)           <---- UAF
            host->ops->host_stop(host)

The iounmap(host_priv->hcr_base) and kfree(host_priv) functions should
not be executed in drv->remove. These functions should be executed in
host_stop after port_stop. Therefore, we move these functions to the
new function sata_fsl_host_stop and bind the new function to host_stop.

Fixes: faf0b2e5afe7 ("drivers/ata: add support to Freescale 3.0Gbps SATA Controller")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_fsl.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1406,6 +1406,14 @@ static int sata_fsl_init_controller(stru
 	return 0;
 }
 
+static void sata_fsl_host_stop(struct ata_host *host)
+{
+        struct sata_fsl_host_priv *host_priv = host->private_data;
+
+        iounmap(host_priv->hcr_base);
+        kfree(host_priv);
+}
+
 /*
  * scsi mid-layer and libata interface structures
  */
@@ -1438,6 +1446,8 @@ static struct ata_port_operations sata_f
 	.port_start = sata_fsl_port_start,
 	.port_stop = sata_fsl_port_stop,
 
+	.host_stop      = sata_fsl_host_stop,
+
 	.pmp_attach = sata_fsl_pmp_attach,
 	.pmp_detach = sata_fsl_pmp_detach,
 };
@@ -1570,8 +1580,6 @@ static int sata_fsl_remove(struct platfo
 	ata_host_detach(host);
 
 	irq_dispose_mapping(host_priv->irq);
-	iounmap(host_priv->hcr_base);
-	kfree(host_priv);
 
 	return 0;
 }


