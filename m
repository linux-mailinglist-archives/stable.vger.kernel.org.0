Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89B4F2B03
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353925AbiDEKJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346007AbiDEJXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DCD35AB3;
        Tue,  5 Apr 2022 02:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484E0B81C6A;
        Tue,  5 Apr 2022 09:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64B4C385C1;
        Tue,  5 Apr 2022 09:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149965;
        bh=T3kgODDX5p1Yhno/gHslKFRgBU4Q7T8204hWf0ApzHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpVtiDpncM8WZX782Gy4Mnuo39uHyjiVMKJ0fl0RClCfcwr7DjBxgM5rWFnuZXbBD
         xAPEVpYLkPo9Hlod1a3VBBIZ49igcxIHb3GcoXwQKmpaROIcxlC8kiEj+Q06tw5IkY
         Z5oK/7h4QHvSBbvytcy/MtZMx+F+NMko8wEhCBjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0878/1017] scsi: qla2xxx: Fix warning message due to adisc being flushed
Date:   Tue,  5 Apr 2022 09:29:51 +0200
Message-Id: <20220405070420.296853940@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 64f24af75b79cba3b86b0760e27e0fa904db570f upstream.

Fix warning message due to adisc being flushed.  Linux kernel triggered a
warning message where a different error code type is not matching up with
the expected type. Add additional translation of one error code type to
another.

WARNING: CPU: 2 PID: 1131623 at drivers/scsi/qla2xxx/qla_init.c:498
qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
CPU: 2 PID: 1131623 Comm: drmgr Not tainted 5.13.0-rc1-autotest #1
..
GPR28: c000000aaa9c8890 c0080000079ab678 c00000140a104800 c00000002bd19000
NIP [c00800000790857c] qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
LR [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx]
Call Trace:
[c00000001cdc3620] [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx] (unreliable)
[c00000001cdc3710] [c0080000078f3080] __qla2x00_abort_all_cmds+0x1b8/0x580 [qla2xxx]
[c00000001cdc3840] [c0080000078f589c] qla2x00_abort_all_cmds+0x34/0xd0 [qla2xxx]
[c00000001cdc3880] [c0080000079153d8] qla2x00_abort_isp_cleanup+0x3f0/0x570 [qla2xxx]
[c00000001cdc3920] [c0080000078fb7e8] qla2x00_remove_one+0x3d0/0x480 [qla2xxx]
[c00000001cdc39b0] [c00000000071c274] pci_device_remove+0x64/0x120
[c00000001cdc39f0] [c0000000007fb818] device_release_driver_internal+0x168/0x2a0
[c00000001cdc3a30] [c00000000070e304] pci_stop_bus_device+0xb4/0x100
[c00000001cdc3a70] [c00000000070e4f0] pci_stop_and_remove_bus_device+0x20/0x40
[c00000001cdc3aa0] [c000000000073940] pci_hp_remove_devices+0x90/0x130
[c00000001cdc3b30] [c0080000070704d0] disable_slot+0x38/0x90 [rpaphp] [
c00000001cdc3b60] [c00000000073eb4c] power_write_file+0xcc/0x180
[c00000001cdc3be0] [c0000000007354bc] pci_slot_attr_store+0x3c/0x60
[c00000001cdc3c00] [c00000000055f820] sysfs_kf_write+0x60/0x80 [c00000001cdc3c20]
[c00000000055df10] kernfs_fop_write_iter+0x1a0/0x290
[c00000001cdc3c70] [c000000000447c4c] new_sync_write+0x14c/0x1d0
[c00000001cdc3d10] [c00000000044b134] vfs_write+0x224/0x330
[c00000001cdc3d60] [c00000000044b3f4] ksys_write+0x74/0x130
[c00000001cdc3db0] [c00000000002df70] system_call_exception+0x150/0x2d0
[c00000001cdc3e10] [c00000000000d45c] system_call_common+0xec/0x278

Link: https://lore.kernel.org/r/20220110050218.3958-5-njavali@marvell.com
Cc: stable@vger.kernel.org
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -295,6 +295,8 @@ static void qla2x00_async_login_sp_done(
 		ea.iop[0] = lio->u.logio.iop[0];
 		ea.iop[1] = lio->u.logio.iop[1];
 		ea.sp = sp;
+		if (res)
+			ea.data[0] = MBS_COMMAND_ERROR;
 		qla24xx_handle_plogi_done_event(vha, &ea);
 	}
 
@@ -557,6 +559,8 @@ static void qla2x00_async_adisc_sp_done(
 	ea.iop[1] = lio->u.logio.iop[1];
 	ea.fcport = sp->fcport;
 	ea.sp = sp;
+	if (res)
+		ea.data[0] = MBS_COMMAND_ERROR;
 
 	qla24xx_handle_adisc_event(vha, &ea);
 	/* ref: INIT */
@@ -1237,6 +1241,8 @@ static void qla2x00_async_prli_sp_done(s
 		ea.sp = sp;
 		if (res == QLA_OS_TIMER_EXPIRED)
 			ea.data[0] = QLA_OS_TIMER_EXPIRED;
+		else if (res)
+			ea.data[0] = MBS_COMMAND_ERROR;
 
 		qla24xx_handle_prli_done_event(vha, &ea);
 	}


