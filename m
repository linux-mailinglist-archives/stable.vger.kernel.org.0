Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C73F60FE5E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiJ0REu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbiJ0REm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F517E0B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109E6B825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D832C433C1;
        Thu, 27 Oct 2022 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890277;
        bh=bQ9rkRll7Msz84sMpNNPDVGTvFwwf5mZz3qudqVNpqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTcrMtoNWoIgDFLrTk6VDbJPbviZJBlw3ZDlg+GVZ8j/P9+ru4pnBxwa2inFq3OOO
         8Pi8V2I7PS42BGhUj1lHe2XltHGDzmd3ppbl9iYmIwgzyg3D0vhstSRdtlo49ZwKNq
         sZcd58kL0ZqL5mkYnCCxcJxubK5+inL4/v8k2KwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.10 10/79] ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS
Date:   Thu, 27 Oct 2022 18:55:20 +0200
Message-Id: <20221027165054.673195173@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 1e41e693f458eef2d5728207dbd327cd3b16580a upstream.

UBSAN complains about array-index-out-of-bounds:
[ 1.980703] kernel: UBSAN: array-index-out-of-bounds in /build/linux-9H675w/linux-5.15.0/drivers/ata/libahci.c:968:41
[ 1.980709] kernel: index 15 is out of range for type 'ahci_em_priv [8]'
[ 1.980713] kernel: CPU: 0 PID: 209 Comm: scsi_eh_8 Not tainted 5.15.0-25-generic #25-Ubuntu
[ 1.980716] kernel: Hardware name: System manufacturer System Product Name/P5Q3, BIOS 1102 06/11/2010
[ 1.980718] kernel: Call Trace:
[ 1.980721] kernel: <TASK>
[ 1.980723] kernel: show_stack+0x52/0x58
[ 1.980729] kernel: dump_stack_lvl+0x4a/0x5f
[ 1.980734] kernel: dump_stack+0x10/0x12
[ 1.980736] kernel: ubsan_epilogue+0x9/0x45
[ 1.980739] kernel: __ubsan_handle_out_of_bounds.cold+0x44/0x49
[ 1.980742] kernel: ahci_qc_issue+0x166/0x170 [libahci]
[ 1.980748] kernel: ata_qc_issue+0x135/0x240
[ 1.980752] kernel: ata_exec_internal_sg+0x2c4/0x580
[ 1.980754] kernel: ? vprintk_default+0x1d/0x20
[ 1.980759] kernel: ata_exec_internal+0x67/0xa0
[ 1.980762] kernel: sata_pmp_read+0x8d/0xc0
[ 1.980765] kernel: sata_pmp_read_gscr+0x3c/0x90
[ 1.980768] kernel: sata_pmp_attach+0x8b/0x310
[ 1.980771] kernel: ata_eh_revalidate_and_attach+0x28c/0x4b0
[ 1.980775] kernel: ata_eh_recover+0x6b6/0xb30
[ 1.980778] kernel: ? ahci_do_hardreset+0x180/0x180 [libahci]
[ 1.980783] kernel: ? ahci_stop_engine+0xb0/0xb0 [libahci]
[ 1.980787] kernel: ? ahci_do_softreset+0x290/0x290 [libahci]
[ 1.980792] kernel: ? trace_event_raw_event_ata_eh_link_autopsy_qc+0xe0/0xe0
[ 1.980795] kernel: sata_pmp_eh_recover.isra.0+0x214/0x560
[ 1.980799] kernel: sata_pmp_error_handler+0x23/0x40
[ 1.980802] kernel: ahci_error_handler+0x43/0x80 [libahci]
[ 1.980806] kernel: ata_scsi_port_error_handler+0x2b1/0x600
[ 1.980810] kernel: ata_scsi_error+0x9c/0xd0
[ 1.980813] kernel: scsi_error_handler+0xa1/0x180
[ 1.980817] kernel: ? scsi_unjam_host+0x1c0/0x1c0
[ 1.980820] kernel: kthread+0x12a/0x150
[ 1.980823] kernel: ? set_kthread_struct+0x50/0x50
[ 1.980826] kernel: ret_from_fork+0x22/0x30
[ 1.980831] kernel: </TASK>

This happens because sata_pmp_init_links() initialize link->pmp up to
SATA_PMP_MAX_PORTS while em_priv is declared as 8 elements array.

I can't find the maximum Enclosure Management ports specified in AHCI
spec v1.3.1, but "12.2.1 LED message type" states that "Port Multiplier
Information" can utilize 4 bits, which implies it can support up to 16
ports. Hence, use SATA_PMP_MAX_PORTS as EM_MAX_SLOTS to resolve the
issue.

BugLink: https://bugs.launchpad.net/bugs/1970074
Cc: stable@vger.kernel.org
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -254,7 +254,7 @@ enum {
 	PCS_7				= 0x94, /* 7+ port PCS (Denverton) */
 
 	/* em constants */
-	EM_MAX_SLOTS			= 8,
+	EM_MAX_SLOTS			= SATA_PMP_MAX_PORTS,
 	EM_MAX_RETRY			= 5,
 
 	/* em_ctl bits */


