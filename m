Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614A54F39C0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378657AbiDELiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353990AbiDEKKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:10:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10933C55B4;
        Tue,  5 Apr 2022 02:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75377CE1C9C;
        Tue,  5 Apr 2022 09:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86206C385A2;
        Tue,  5 Apr 2022 09:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152583;
        bh=jik5O51dlzmyMQiJJ1AKYzRdpKHgYtECSWSAGjm/Xyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM1Ot7yNHo0RyBrev4MfiM0qeOTXIMgy5jmXhEnApxAGfYQqSXKTc3vkRAY060BeV
         zxG8kvUinKSGLT0snkvqYJO6XCZaGCp95sXI0fjGpZfyxYTtT2RgSuP0hApZP2QcvT
         jUYkDHlyNW1jLifGXM4kznZB70HncLg8m4JRzcDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 791/913] scsi: qla2xxx: Fix scheduling while atomic
Date:   Tue,  5 Apr 2022 09:30:53 +0200
Message-Id: <20220405070403.544056727@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit afd438ff874ca40b74321b3fa19bd61adfd7ca0c upstream.

The driver makes a call into midlayer (fc_remote_port_delete) which can put
the thread to sleep. The thread that originates the call is in interrupt
context. The combination of the two trigger a crash. Schedule the call in
non-interrupt context where it is more safe.

kernel: BUG: scheduling while atomic: swapper/7/0/0x00010000
kernel: Call Trace:
kernel:  <IRQ>
kernel:  dump_stack+0x66/0x81
kernel:  __schedule_bug.cold.90+0x5/0x1d
kernel:  __schedule+0x7af/0x960
kernel:  schedule+0x28/0x80
kernel:  schedule_timeout+0x26d/0x3b0
kernel:  wait_for_completion+0xb4/0x140
kernel:  ? wake_up_q+0x70/0x70
kernel:  __wait_rcu_gp+0x12c/0x160
kernel:  ? sdev_evt_alloc+0xc0/0x180 [scsi_mod]
kernel:  synchronize_sched+0x6c/0x80
kernel:  ? call_rcu_bh+0x20/0x20
kernel:  ? __bpf_trace_rcu_invoke_callback+0x10/0x10
kernel:  sdev_evt_alloc+0xfd/0x180 [scsi_mod]
kernel:  starget_for_each_device+0x85/0xb0 [scsi_mod]
kernel:  ? scsi_init_io+0x360/0x3d0 [scsi_mod]
kernel:  scsi_init_io+0x388/0x3d0 [scsi_mod]
kernel:  device_for_each_child+0x54/0x90
kernel:  fc_remote_port_delete+0x70/0xe0 [scsi_transport_fc]
kernel:  qla2x00_schedule_rport_del+0x62/0xf0 [qla2xxx]
kernel:  qla2x00_mark_device_lost+0x9c/0xd0 [qla2xxx]
kernel:  qla24xx_handle_plogi_done_event+0x55f/0x570 [qla2xxx]
kernel:  qla2x00_async_login_sp_done+0xd2/0x100 [qla2xxx]
kernel:  qla24xx_logio_entry+0x13a/0x3c0 [qla2xxx]
kernel:  qla24xx_process_response_queue+0x306/0x400 [qla2xxx]
kernel:  qla24xx_msix_rsp_q+0x3f/0xb0 [qla2xxx]
kernel:  __handle_irq_event_percpu+0x40/0x180
kernel:  handle_irq_event_percpu+0x30/0x80
kernel:  handle_irq_event+0x36/0x60

Link: https://lore.kernel.org/r/20220110050218.3958-7-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2212,12 +2212,7 @@ qla24xx_handle_plogi_done_event(struct s
 		ql_dbg(ql_dbg_disc, vha, 0x20eb, "%s %d %8phC cmd error %x\n",
 		    __func__, __LINE__, ea->fcport->port_name, ea->data[1]);
 
-		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_FAILED);
-		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		else
-			qla2x00_mark_device_lost(vha, ea->fcport, 1);
+		qlt_schedule_sess_for_deletion(ea->fcport);
 		break;
 	case MBS_LOOP_ID_USED:
 		/* data[1] = IO PARAM 1 = nport ID  */


