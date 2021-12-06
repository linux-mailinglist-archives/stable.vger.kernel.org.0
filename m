Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DA3469AED
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348709AbhLFPLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346670AbhLFPIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:08:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4FEC08E85B;
        Mon,  6 Dec 2021 07:03:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A8616132A;
        Mon,  6 Dec 2021 15:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64143C341C5;
        Mon,  6 Dec 2021 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803033;
        bh=/Wb6m5v5fmBpipAr4UQHcfMhU2vYSv9T7Gi+eLxGnho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKJwkoRNV+CEilATpFLXlcLWyHFNvYzzC2o7MjZSKuZkelPucyv9k0BCbav1c5de+
         vWqjXSVaZYir+hQdhDqXqpNHoynuaPVgv/XN5cHLLfH7g5xnzfGFka312r+Xns9Onz
         gaO7DO98hXo1HtzKZg8GRLlrKhYaUBypynDMWYxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.9 51/62] sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl
Date:   Mon,  6 Dec 2021 15:56:34 +0100
Message-Id: <20211206145550.971313385@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit 6f48394cf1f3e8486591ad98c11cdadb8f1ef2ad upstream.

Trying to remove the fsl-sata module in the PPC64 GNU/Linux
leads to the following warning:
 ------------[ cut here ]------------
 remove_proc_entry: removing non-empty directory 'irq/69',
   leaking at least 'fsl-sata[ff0221000.sata]'
 WARNING: CPU: 3 PID: 1048 at fs/proc/generic.c:722
   .remove_proc_entry+0x20c/0x220
 IRQMASK: 0
 NIP [c00000000033826c] .remove_proc_entry+0x20c/0x220
 LR [c000000000338268] .remove_proc_entry+0x208/0x220
 Call Trace:
  .remove_proc_entry+0x208/0x220 (unreliable)
  .unregister_irq_proc+0x104/0x140
  .free_desc+0x44/0xb0
  .irq_free_descs+0x9c/0xf0
  .irq_dispose_mapping+0x64/0xa0
  .sata_fsl_remove+0x58/0xa0 [sata_fsl]
  .platform_drv_remove+0x40/0x90
  .device_release_driver_internal+0x160/0x2c0
  .driver_detach+0x64/0xd0
  .bus_remove_driver+0x70/0xf0
  .driver_unregister+0x38/0x80
  .platform_driver_unregister+0x14/0x30
  .fsl_sata_driver_exit+0x18/0xa20 [sata_fsl]
 ---[ end trace 0ea876d4076908f5 ]---

The driver creates the mapping by calling irq_of_parse_and_map(),
so it also has to dispose the mapping. But the easy way out is to
simply use platform_get_irq() instead of irq_of_parse_map(). Also
we should adapt return value checking and propagate error values.

In this case the mapping is not managed by the device but by
the of core, so the device has not to dispose the mapping.

Fixes: faf0b2e5afe7 ("drivers/ata: add support to Freescale 3.0Gbps SATA Controller")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_fsl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1502,9 +1502,9 @@ static int sata_fsl_probe(struct platfor
 	host_priv->ssr_base = ssr_base;
 	host_priv->csr_base = csr_base;
 
-	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	if (!irq) {
-		dev_err(&ofdev->dev, "invalid irq from platform\n");
+	irq = platform_get_irq(ofdev, 0);
+	if (irq < 0) {
+		retval = irq;
 		goto error_exit_with_cleanup;
 	}
 	host_priv->irq = irq;
@@ -1581,8 +1581,6 @@ static int sata_fsl_remove(struct platfo
 
 	ata_host_detach(host);
 
-	irq_dispose_mapping(host_priv->irq);
-
 	return 0;
 }
 


