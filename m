Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6724FD0DF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiDLG4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351069AbiDLGwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:52:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AE52A720;
        Mon, 11 Apr 2022 23:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F681CE1C07;
        Tue, 12 Apr 2022 06:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502CDC385A1;
        Tue, 12 Apr 2022 06:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745593;
        bh=J+TnkjUnUJTPTjWdY0vnCLiIu4RAOPI2eSIf3Ml9EyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqexdADpWR2sUn3OAx1EmpsPaCjXT9fcWqsGAQ+BYwhweefG8ttOy1sBYSf9eB06s
         J2dfOGjqqtOnlG0CeK1xPz0bmYrnw6aLEjqtKNwriiCsVbZgjivXdQEDACUzBN5jXa
         4EQT+VuI6bCQsi3oFLS5RCKUHsjL/QNUUT+DFPPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        stable@kernel.org
Subject: [PATCH 5.10 149/171] ata: sata_dwc_460ex: Fix crash due to OOB write
Date:   Tue, 12 Apr 2022 08:30:40 +0200
Message-Id: <20220412062932.203881094@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 7aa8104a554713b685db729e66511b93d989dd6a upstream.

the driver uses libata's "tag" values from in various arrays.
Since the mentioned patch bumped the ATA_TAG_INTERNAL to 32,
the value of the SATA_DWC_QCMD_MAX needs to account for that.

Otherwise ATA_TAG_INTERNAL usage cause similar crashes like
this as reported by Tice Rex on the OpenWrt Forum and
reproduced (with symbols) here:

| BUG: Kernel NULL pointer dereference at 0x00000000
| Faulting instruction address: 0xc03ed4b8
| Oops: Kernel access of bad area, sig: 11 [#1]
| BE PAGE_SIZE=4K PowerPC 44x Platform
| CPU: 0 PID: 362 Comm: scsi_eh_1 Not tainted 5.4.163 #0
| NIP:  c03ed4b8 LR: c03d27e8 CTR: c03ed36c
| REGS: cfa59950 TRAP: 0300   Not tainted  (5.4.163)
| MSR:  00021000 <CE,ME>  CR: 42000222  XER: 00000000
| DEAR: 00000000 ESR: 00000000
| GPR00: c03d27e8 cfa59a08 cfa55fe0 00000000 0fa46bc0 [...]
| [..]
| NIP [c03ed4b8] sata_dwc_qc_issue+0x14c/0x254
| LR [c03d27e8] ata_qc_issue+0x1c8/0x2dc
| Call Trace:
| [cfa59a08] [c003f4e0] __cancel_work_timer+0x124/0x194 (unreliable)
| [cfa59a78] [c03d27e8] ata_qc_issue+0x1c8/0x2dc
| [cfa59a98] [c03d2b3c] ata_exec_internal_sg+0x240/0x524
| [cfa59b08] [c03d2e98] ata_exec_internal+0x78/0xe0
| [cfa59b58] [c03d30fc] ata_read_log_page.part.38+0x1dc/0x204
| [cfa59bc8] [c03d324c] ata_identify_page_supported+0x68/0x130
| [...]

This is because sata_dwc_dma_xfer_complete() NULLs the
dma_pending's next neighbour "chan" (a *dma_chan struct) in
this '32' case right here (line ~735):
> hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;

Then the next time, a dma gets issued; dma_dwc_xfer_setup() passes
the NULL'd hsdevp->chan to the dmaengine_slave_config() which then
causes the crash.

With this patch, SATA_DWC_QCMD_MAX is now set to ATA_MAX_QUEUE + 1.
This avoids the OOB. But please note, there was a worthwhile discussion
on what ATA_TAG_INTERNAL and ATA_MAX_QUEUE is. And why there should not
be a "fake" 33 command-long queue size.

Ideally, the dw driver should account for the ATA_TAG_INTERNAL.
In Damien Le Moal's words: "... having looked at the driver, it
is a bigger change than just faking a 33rd "tag" that is in fact
not a command tag at all."

Fixes: 28361c403683c ("libata: add extra internal command")
Cc: stable@kernel.org # 4.18+
BugLink: https://github.com/openwrt/openwrt/issues/9505
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_dwc_460ex.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -145,7 +145,11 @@ struct sata_dwc_device {
 #endif
 };
 
-#define SATA_DWC_QCMD_MAX	32
+/*
+ * Allow one extra special slot for commands and DMA management
+ * to account for libata internal commands.
+ */
+#define SATA_DWC_QCMD_MAX	(ATA_MAX_QUEUE + 1)
 
 struct sata_dwc_device_port {
 	struct sata_dwc_device	*hsdev;


