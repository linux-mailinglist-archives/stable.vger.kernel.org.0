Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B4E4F39C7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378687AbiDELiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353984AbiDEKKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E950C559F;
        Tue,  5 Apr 2022 02:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0473E6157A;
        Tue,  5 Apr 2022 09:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD409C385A2;
        Tue,  5 Apr 2022 09:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152575;
        bh=YeYSZntpBcocBRVcXz2Qnd0y/y9flZx5YBRbVnZZp8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3ou6AyzFPrWA7pkGgOuMl+SPSL7CfbihIasu/9kgFb+zkAeHbnU1BMQzl1LtIsHl
         hisk2rMmqR8ikFi22fgBzlNWXWYf4Fwf+G7/3Pv6gG+JkVLCuedFr6HKM5IDr2JgEc
         3QNQSTgsGwnUKzcmVleonE/JXN90Xi7FRANfiS/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 788/913] scsi: qla2xxx: Implement ref count for SRB
Date:   Tue,  5 Apr 2022 09:30:50 +0200
Message-Id: <20220405070403.455150928@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

commit 31e6cdbe0eae37badceb5e0d4f06cf051432fd77 upstream.

The timeout handler and the done function are racing. When
qla2x00_async_iocb_timeout() starts to run it can be preempted by the
normal response path (via the firmware?). qla24xx_async_gpsc_sp_done()
releases the SRB unconditionally. When scheduling back to
qla2x00_async_iocb_timeout() qla24xx_async_abort_cmd() will access an freed
sp->qpair pointer:

  qla2xxx [0000:83:00.0]-2871:0: Async-gpsc timeout - hdl=63d portid=234500 50:06:0e:80:08:77:b6:21.
  qla2xxx [0000:83:00.0]-2853:0: Async done-gpsc res 0, WWPN 50:06:0e:80:08:77:b6:21
  qla2xxx [0000:83:00.0]-2854:0: Async-gpsc OUT WWPN 20:45:00:27:f8:75:33:00 speeds=2c00 speed=0400.
  qla2xxx [0000:83:00.0]-28d8:0: qla24xx_handle_gpsc_event 50:06:0e:80:08:77:b6:21 DS 7 LS 6 rc 0 login 1|1 rscn 1|0 lid 5
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
  IP: qla24xx_async_abort_cmd+0x1b/0x1c0 [qla2xxx]

Obvious solution to this is to introduce a reference counter. One reference
is taken for the normal code path (the 'good' case) and one for the timeout
path. As we always race between the normal good case and the timeout/abort
handler we need to serialize it. Also we cannot assume any order between
the handlers. Since this is slow path we can use proper synchronization via
locks.

When we are able to cancel a timer (del_timer returns 1) we know there
can't be any error handling in progress because the timeout handler hasn't
expired yet, thus we can safely decrement the refcounter by one.

If we are not able to cancel the timer, we know an abort handler is
running. We have to make sure we call sp->done() in the abort handlers
before calling kref_put().

Link: https://lore.kernel.org/r/20220110050218.3958-3-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Co-developed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c    |    6 +-
 drivers/scsi/qla2xxx/qla_def.h    |    5 ++
 drivers/scsi/qla2xxx/qla_edif.c   |    3 -
 drivers/scsi/qla2xxx/qla_gbl.h    |    1 
 drivers/scsi/qla2xxx/qla_gs.c     |   85 +++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_init.c   |   70 +++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_inline.h |    2 
 drivers/scsi/qla2xxx/qla_iocb.c   |   41 ++++++++++++++----
 drivers/scsi/qla2xxx/qla_mbx.c    |    4 +
 drivers/scsi/qla2xxx/qla_mid.c    |    4 +
 drivers/scsi/qla2xxx/qla_mr.c     |    4 +
 drivers/scsi/qla2xxx/qla_os.c     |   14 ++++--
 drivers/scsi/qla2xxx/qla_target.c |    4 -
 13 files changed, 173 insertions(+), 70 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -29,7 +29,8 @@ void qla2x00_bsg_job_done(srb_t *sp, int
 	    "%s: sp hdl %x, result=%x bsg ptr %p\n",
 	    __func__, sp->handle, res, bsg_job);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
@@ -3010,6 +3011,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_
 
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return 0;
 }
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -726,6 +726,11 @@ typedef struct srb {
 	 * code.
 	 */
 	void (*put_fn)(struct kref *kref);
+
+	/*
+	 * Report completion for asynchronous commands.
+	 */
+	void (*async_done)(struct srb *sp, int res);
 } srb_t;
 
 #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2161,7 +2161,8 @@ edif_doorbell_show(struct device *dev, s
 
 static void qla_noop_sp_done(srb_t *sp, int res)
 {
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 /*
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -333,6 +333,7 @@ extern int qla24xx_get_one_block_sg(uint
 extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
 extern int qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,
 	struct qla_work_evt *e);
+void qla2x00_sp_release(struct kref *kref);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -529,7 +529,6 @@ static void qla2x00_async_sns_sp_done(sr
 		if (!e)
 			goto err2;
 
-		del_timer(&sp->u.iocb_cmd.timer);
 		e->u.iosb.sp = sp;
 		qla2x00_post_work(vha, e);
 		return;
@@ -556,8 +555,8 @@ err2:
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 		}
 
-		sp->free(sp);
-
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return;
 	}
 
@@ -592,6 +591,7 @@ static int qla_async_rftid(scsi_qla_host
 	if (!vha->flags.online)
 		goto done;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -652,7 +652,8 @@ static int qla_async_rftid(scsi_qla_host
 	}
 	return rval;
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -687,6 +688,7 @@ static int qla_async_rffid(scsi_qla_host
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -747,7 +749,8 @@ static int qla_async_rffid(scsi_qla_host
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -777,6 +780,7 @@ static int qla_async_rnnid(scsi_qla_host
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -836,7 +840,8 @@ static int qla_async_rnnid(scsi_qla_host
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -882,6 +887,7 @@ static int qla_async_rsnn_nn(scsi_qla_ho
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -947,7 +953,8 @@ static int qla_async_rsnn_nn(scsi_qla_ho
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -2886,7 +2893,8 @@ static void qla24xx_async_gpsc_sp_done(s
 	qla24xx_handle_gpsc_event(vha, &ea);
 
 done:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -2898,6 +2906,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -2937,7 +2946,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -2986,7 +2996,8 @@ void qla24xx_sp_unmap(scsi_qla_host_t *v
 		break;
 	}
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
@@ -3125,13 +3136,15 @@ static void qla2x00_async_gpnid_sp_done(
 	if (res) {
 		if (res == QLA_FUNCTION_TIMEOUT) {
 			qla24xx_post_gpnid_work(sp->vha, &ea.id);
-			sp->free(sp);
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 			return;
 		}
 	} else if (sp->gen1) {
 		/* There was another RSCN for this Nport ID */
 		qla24xx_post_gpnid_work(sp->vha, &ea.id);
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return;
 	}
 
@@ -3152,7 +3165,8 @@ static void qla2x00_async_gpnid_sp_done(
 				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return;
 	}
 
@@ -3172,6 +3186,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t
 	if (!vha->flags.online)
 		goto done;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -3188,7 +3203,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t
 		if (tsp->u.iocb_cmd.u.ctarg.id.b24 == id->b24) {
 			tsp->gen1++;
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-			sp->free(sp);
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 			goto done;
 		}
 	}
@@ -3258,8 +3274,8 @@ done_free_sp:
 			sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
-
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -3314,7 +3330,8 @@ void qla24xx_async_gffid_sp_done(srb_t *
 	ea.rc = res;
 
 	qla24xx_handle_gffid_event(vha, &ea);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 /* Get FC4 Feature with Nport ID. */
@@ -3327,6 +3344,7 @@ int qla24xx_async_gffid(scsi_qla_host_t
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		return rval;
@@ -3365,7 +3383,8 @@ int qla24xx_async_gffid(scsi_qla_host_t
 
 	return rval;
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
@@ -3752,7 +3771,6 @@ static void qla2x00_async_gpnft_gnnft_sp
 	    "Async done-%s res %x FC4Type %x\n",
 	    sp->name, res, sp->gen2);
 
-	del_timer(&sp->u.iocb_cmd.timer);
 	sp->rc = res;
 	if (res) {
 		unsigned long flags;
@@ -3920,8 +3938,8 @@ done_free_sp:
 		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
-
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
@@ -3973,9 +3991,12 @@ int qla24xx_async_gpnft(scsi_qla_host_t
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 		    "%s: Performing FCP Scan\n", __func__);
 
-		if (sp)
-			sp->free(sp); /* should not happen */
+		if (sp) {
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		}
 
+		/* ref: INIT */
 		sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 		if (!sp) {
 			spin_lock_irqsave(&vha->work_lock, flags);
@@ -4020,6 +4041,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t
 			    sp->u.iocb_cmd.u.ctarg.req,
 			    sp->u.iocb_cmd.u.ctarg.req_dma);
 			sp->u.iocb_cmd.u.ctarg.req = NULL;
+			/* ref: INIT */
 			qla2x00_rel_sp(sp);
 			return rval;
 		}
@@ -4082,7 +4104,8 @@ done_free_sp:
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
@@ -4146,7 +4169,8 @@ static void qla2x00_async_gnnid_sp_done(
 
 	qla24xx_handle_gnnid_event(vha, &ea);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -4159,6 +4183,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t
 		return rval;
 
 	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
@@ -4199,7 +4224,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
@@ -4273,7 +4299,8 @@ static void qla2x00_async_gfpnid_sp_done
 
 	qla24xx_handle_gfpnid_event(vha, &ea);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -4285,6 +4312,7 @@ int qla24xx_async_gfpnid(scsi_qla_host_t
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
@@ -4325,7 +4353,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -51,6 +51,9 @@ qla2x00_sp_timeout(struct timer_list *t)
 	WARN_ON(irqs_disabled());
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
+
+	/* ref: TMR */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 void qla2x00_sp_free(srb_t *sp)
@@ -125,8 +128,13 @@ static void qla24xx_abort_iocb_timeout(v
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp)
+	if (sp->cmd_sp) {
+		/*
+		 * This done function should take care of
+		 * original command ref: INIT
+		 */
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+	}
 
 	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
@@ -140,11 +148,11 @@ static void qla24xx_abort_sp_done(srb_t
 	if (orig_sp)
 		qla_wait_nvme_release_cmd_kref(orig_sp);
 
-	del_timer(&sp->u.iocb_cmd.timer);
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&abt->u.abt.comp);
 	else
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
@@ -154,6 +162,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_s
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 
+	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
 				  GFP_ATOMIC);
 	if (!sp)
@@ -181,7 +190,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_s
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return rval;
 	}
 
@@ -189,7 +199,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_s
 		wait_for_completion(&abt_iocb->u.abt.comp);
 		rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
 			QLA_SUCCESS : QLA_ERR_FROM_FW;
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	}
 
 	return rval;
@@ -287,7 +298,8 @@ static void qla2x00_async_login_sp_done(
 		qla24xx_handle_plogi_done_event(vha, &ea);
 	}
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -306,6 +318,7 @@ qla2x00_async_login(struct scsi_qla_host
 		return rval;
 	}
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -355,7 +368,8 @@ qla2x00_async_login(struct scsi_qla_host
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
@@ -367,7 +381,8 @@ static void qla2x00_async_logout_sp_done
 	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	sp->fcport->login_gen++;
 	qlt_logo_completion_handler(sp->fcport, sp->u.iocb_cmd.u.logio.data[0]);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -377,6 +392,7 @@ qla2x00_async_logout(struct scsi_qla_hos
 	int rval = QLA_FUNCTION_FAILED;
 
 	fcport->flags |= FCF_ASYNC_SENT;
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -398,7 +414,8 @@ qla2x00_async_logout(struct scsi_qla_hos
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	return rval;
@@ -424,7 +441,8 @@ static void qla2x00_async_prlo_sp_done(s
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
 		qla2x00_post_async_prlo_done_work(sp->fcport->vha, sp->fcport,
 		    lio->u.logio.data);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -434,6 +452,7 @@ qla2x00_async_prlo(struct scsi_qla_host
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -455,7 +474,8 @@ qla2x00_async_prlo(struct scsi_qla_host
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
@@ -540,8 +560,8 @@ static void qla2x00_async_adisc_sp_done(
 	ea.sp = sp;
 
 	qla24xx_handle_adisc_event(vha, &ea);
-
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -556,6 +576,7 @@ qla2x00_async_adisc(struct scsi_qla_host
 		return rval;
 
 	fcport->flags |= FCF_ASYNC_SENT;
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -583,7 +604,8 @@ qla2x00_async_adisc(struct scsi_qla_host
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	qla2x00_post_async_adisc_work(vha, fcport, data);
@@ -1064,7 +1086,8 @@ static void qla24xx_async_gnl_sp_done(sr
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -1094,6 +1117,7 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	vha->gnl.sent = 1;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1126,7 +1150,8 @@ int qla24xx_async_gnl(struct scsi_qla_ho
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
 	return rval;
@@ -1172,7 +1197,7 @@ done:
 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 		sp->u.iocb_cmd.u.mbx.in_dma);
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -1217,7 +1242,7 @@ static void qla2x00_async_prli_sp_done(s
 		qla24xx_handle_prli_done_event(vha, &ea);
 	}
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -1275,7 +1300,8 @@ qla24xx_async_prli(struct scsi_qla_host
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
@@ -1360,7 +1386,7 @@ done_free_sp:
 	if (pd)
 		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
@@ -1926,6 +1952,7 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1969,7 +1996,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport,
 	}
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -184,6 +184,8 @@ static void qla2xxx_init_sp(srb_t *sp, s
 	sp->vha = vha;
 	sp->qpair = qpair;
 	sp->cmd_type = TYPE_SRB;
+	/* ref : INIT - normal flow */
+	kref_init(&sp->cmd_kref);
 	INIT_LIST_HEAD(&sp->elem);
 }
 
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2561,6 +2561,14 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mg
 }
 
 void
+qla2x00_sp_release(struct kref *kref)
+{
+	struct srb *sp = container_of(kref, struct srb, cmd_kref);
+
+	sp->free(sp);
+}
+
+void
 qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
 		     void (*done)(struct srb *sp, int res))
 {
@@ -2655,7 +2663,9 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	       return -ENOMEM;
 	}
 
-	/* Alloc SRB structure */
+	/* Alloc SRB structure
+	 * ref: INIT
+	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
 		kfree(fcport);
@@ -2687,7 +2697,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 			    GFP_KERNEL);
 
 	if (!elsio->u.els_logo.els_logo_pyld) {
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2710,7 +2721,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2721,7 +2733,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 
 	wait_for_completion(&elsio->u.els_logo.comp);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return rval;
 }
 
@@ -2854,7 +2867,6 @@ static void qla2x00_els_dcmd2_sp_done(sr
 	    sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
-	del_timer(&sp->u.iocb_cmd.timer);
 
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
@@ -2964,7 +2976,8 @@ static void qla2x00_els_dcmd2_sp_done(sr
 			struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
 			qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
-			sp->free(sp);
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 			return;
 		}
 		e->u.iosb.sp = sp;
@@ -2982,7 +2995,9 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 	int rval = QLA_SUCCESS;
 	void	*ptr, *resp_ptr;
 
-	/* Alloc SRB structure */
+	/* Alloc SRB structure
+	 * ref: INIT
+	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
 		ql_log(ql_log_info, vha, 0x70e6,
@@ -3072,7 +3087,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *
 out:
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -3883,8 +3899,15 @@ qla2x00_start_sp(srb_t *sp)
 		break;
 	}
 
-	if (sp->start_timer)
+	if (sp->start_timer) {
+		/* ref: TMR timer ref
+		 * this code should be just before start_iocbs function
+		 * This will make sure that caller function don't to do
+		 * kref_put even on failure
+		 */
+		kref_get(&sp->cmd_kref);
 		add_timer(&sp->u.iocb_cmd.timer);
+	}
 
 	wmb();
 	qla2x00_start_iocbs(vha, qp->req);
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6479,6 +6479,7 @@ int qla24xx_send_mb_cmd(struct scsi_qla_
 	if (!vha->hw->flags.fw_started)
 		goto done;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -6524,7 +6525,8 @@ int qla24xx_send_mb_cmd(struct scsi_qla_
 	}
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -965,6 +965,7 @@ int qla24xx_control_vp(scsi_qla_host_t *
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
 		return rval;
@@ -1007,6 +1008,7 @@ int qla24xx_control_vp(scsi_qla_host_t *
 		break;
 	}
 done:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return rval;
 }
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1787,6 +1787,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc
 	struct register_host_info *preg_hsi;
 	struct new_utsname *p_sysid = NULL;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1973,7 +1974,8 @@ done_unmap_req:
 		dma_free_coherent(&ha->pdev->dev, fdisc->u.fxiocb.req_len,
 		    fdisc->u.fxiocb.req_addr, fdisc->u.fxiocb.req_dma_handle);
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -728,7 +728,8 @@ void qla2x00_sp_compl(srb_t *sp, int res
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
-	sp->free(sp);
+	/* kref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
 	cmd->scsi_done(cmd);
@@ -819,7 +820,8 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, i
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
 	cmd->scsi_done(cmd);
@@ -919,6 +921,7 @@ qla2xxx_queuecommand(struct Scsi_Host *h
 		goto qc24_target_busy;
 
 	sp = scsi_cmd_priv(cmd);
+	/* ref: INIT */
 	qla2xxx_init_sp(sp, vha, vha->hw->base_qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
@@ -938,7 +941,8 @@ qla2xxx_queuecommand(struct Scsi_Host *h
 	return 0;
 
 qc24_host_busy_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -1008,6 +1012,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *
 		goto qc24_target_busy;
 
 	sp = scsi_cmd_priv(cmd);
+	/* ref: INIT */
 	qla2xxx_init_sp(sp, vha, qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
@@ -1026,7 +1031,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *
 	return 0;
 
 qc24_host_busy_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -620,7 +620,7 @@ static void qla2x00_async_nack_sp_done(s
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
@@ -672,7 +672,7 @@ int qla24xx_async_notify_ack(scsi_qla_ho
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;


