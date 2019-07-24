Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266D773D23
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404131AbfGXTy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404054AbfGXTy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABB620665;
        Wed, 24 Jul 2019 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998065;
        bh=3mjautxLJBa6mI381phLP4c1TprNGGkNasfZJ96yAaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxHLpxX1e7kIjd8FXIDyeg2OhdKdU5aO24tCbtNIB6pYve72dz2YSla1H1Kt9C21m
         Sgw3aMliCsoriasmeVBpHvDAlYPrJqkW7pXhLYecvUp5BfScV8HDStMKyODolMG7uv
         qR+Rm4+SmOSEPxVRKzn4YR/3yl+cryiS2GWaa4h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 234/371] scsi: zfcp: fix request object use-after-free in send path causing seqno errors
Date:   Wed, 24 Jul 2019 21:19:46 +0200
Message-Id: <20190724191742.141843131@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Block <bblock@linux.ibm.com>

commit b76becde2b84137faa29bbc9a3b20953b5980e48 upstream.

With a recent change to our send path for FSF commands we introduced a
possible use-after-free of request-objects, that might further lead to
zfcp crafting bad requests, which the FCP channel correctly complains
about with an error (FSF_PROT_SEQ_NUMB_ERROR). This error is then handled
by an adapter-wide recovery.

The following sequence illustrates the possible use-after-free:

    Send Path:

        int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
        {
                struct zfcp_fsf_req *req;
                ...
                spin_lock_irq(&qdio->req_q_lock);
        //                     ^^^^^^^^^^^^^^^^
        //                     protects QDIO queue during sending
                ...
                req = zfcp_fsf_req_create(qdio,
                                          FSF_QTCB_OPEN_PORT_WITH_DID,
                                          SBAL_SFLAGS0_TYPE_READ,
                                          qdio->adapter->pool.erp_req);
        //            ^^^^^^^^^^^^^^^^^^^
        //            allocation of the request-object
                ...
                retval = zfcp_fsf_req_send(req);
                ...
                spin_unlock_irq(&qdio->req_q_lock);
                return retval;
        }

        static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
        {
                struct zfcp_adapter *adapter = req->adapter;
                struct zfcp_qdio *qdio = adapter->qdio;
                ...
                zfcp_reqlist_add(adapter->req_list, req);
        //      ^^^^^^^^^^^^^^^^
        //      add request to our driver-internal hash-table for tracking
        //      (protected by separate lock req_list->lock)
                ...
                if (zfcp_qdio_send(qdio, &req->qdio_req)) {
        //          ^^^^^^^^^^^^^^
        //          hand-off the request to FCP channel;
        //          the request can complete at any point now
                        ...
                }

                /* Don't increase for unsolicited status */
                if (!zfcp_fsf_req_is_status_read_buffer(req))
        //           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        //           possible use-after-free
                        adapter->fsf_req_seq_no++;
        //                       ^^^^^^^^^^^^^^^^
        //                       because of the use-after-free we might
        //                       miss this accounting, and as follow-up
        //                       this results in the FCP channel error
        //                       FSF_PROT_SEQ_NUMB_ERROR
                adapter->req_no++;

                return 0;
        }

        static inline bool
        zfcp_fsf_req_is_status_read_buffer(struct zfcp_fsf_req *req)
        {
                return req->qtcb == NULL;
        //             ^^^^^^^^^
        //             possible use-after-free
        }

    Response Path:

        void zfcp_fsf_reqid_check(struct zfcp_qdio *qdio, int sbal_idx)
        {
                ...
                struct zfcp_fsf_req *fsf_req;
                ...
                for (idx = 0; idx < QDIO_MAX_ELEMENTS_PER_BUFFER; idx++) {
                        ...
                        fsf_req = zfcp_reqlist_find_rm(adapter->req_list,
                                                       req_id);
        //                        ^^^^^^^^^^^^^^^^^^^^
        //                        remove request from our driver-internal
        //                        hash-table (lock req_list->lock)
                        ...
                        zfcp_fsf_req_complete(fsf_req);
                }
        }

        static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
        {
                ...
                if (likely(req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
                        zfcp_fsf_req_free(req);
        //              ^^^^^^^^^^^^^^^^^
        //              free memory for request-object
                else
                        complete(&req->completion);
        //              ^^^^^^^^
        //              completion notification for code-paths that wait
        //              synchronous for the completion of the request; in
        //              those the memory is freed separately
        }

The result of the use-after-free only affects the send path, and can not
lead to any data corruption. In case we miss the sequence-number
accounting, because the memory was already re-purposed, the next FSF
command will fail with said FCP channel error, and we will recover the
whole adapter. This causes no additional errors, but it slows down
traffic.  There is a slight chance of the same thing happen again
recursively after the adapter recovery, but so far this has not been seen.

This was seen under z/VM, where the send path might run on a virtual CPU
that gets scheduled away by z/VM, while the return path might still run,
and so create the necessary timing. Running with KASAN can also slow down
the kernel sufficiently to run into this user-after-free, and then see the
report by KASAN.

To fix this, simply pull the test for the sequence-number accounting in
front of the hand-off to the FCP channel (this information doesn't change
during hand-off), but leave the sequence-number accounting itself where it
is.

To make future regressions of the same kind less likely, add comments to
all closely related code-paths.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Fixes: f9eca0227600 ("scsi: zfcp: drop duplicate fsf_command from zfcp_fsf_req which is also in QTCB header")
Cc: <stable@vger.kernel.org> #5.0+
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_fsf.c |   45 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/blktrace_api.h>
+#include <linux/types.h>
 #include <linux/slab.h>
 #include <scsi/fc/fc_els.h>
 #include "zfcp_ext.h"
@@ -741,6 +742,7 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 {
+	const bool is_srb = zfcp_fsf_req_is_status_read_buffer(req);
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
 	int req_id = req->req_id;
@@ -757,8 +759,20 @@ static int zfcp_fsf_req_send(struct zfcp
 		return -EIO;
 	}
 
+	/*
+	 * NOTE: DO NOT TOUCH ASYNC req PAST THIS POINT.
+	 *	 ONLY TOUCH SYNC req AGAIN ON req->completion.
+	 *
+	 * The request might complete and be freed concurrently at any point
+	 * now. This is not protected by the QDIO-lock (req_q_lock). So any
+	 * uncontrolled access after this might result in an use-after-free bug.
+	 * Only if the request doesn't have ZFCP_STATUS_FSFREQ_CLEANUP set, and
+	 * when it is completed via req->completion, is it safe to use req
+	 * again.
+	 */
+
 	/* Don't increase for unsolicited status */
-	if (!zfcp_fsf_req_is_status_read_buffer(req))
+	if (!is_srb)
 		adapter->fsf_req_seq_no++;
 	adapter->req_no++;
 
@@ -805,6 +819,7 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
 		goto failed_req_send;
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
@@ -914,8 +929,10 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	req->qtcb->bottom.support.req_handle = (u64) old_req_id;
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_SCSI_ER_TIMEOUT);
-	if (!zfcp_fsf_req_send(req))
+	if (!zfcp_fsf_req_send(req)) {
+		/* NOTE: DO NOT TOUCH req, UNTIL IT COMPLETES! */
 		goto out;
+	}
 
 out_error_free:
 	zfcp_fsf_req_free(req);
@@ -1098,6 +1115,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
 		goto failed_send;
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
@@ -1198,6 +1216,7 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
 		goto failed_send;
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
@@ -1243,6 +1262,7 @@ int zfcp_fsf_exchange_config_data(struct
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -1279,8 +1299,10 @@ int zfcp_fsf_exchange_config_data_sync(s
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	spin_unlock_irq(&qdio->req_q_lock);
-	if (!retval)
+	if (!retval) {
+		/* NOTE: ONLY TOUCH SYNC req AGAIN ON req->completion. */
 		wait_for_completion(&req->completion);
+	}
 
 	zfcp_fsf_req_free(req);
 	return retval;
@@ -1330,6 +1352,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -1372,8 +1395,10 @@ int zfcp_fsf_exchange_port_data_sync(str
 	retval = zfcp_fsf_req_send(req);
 	spin_unlock_irq(&qdio->req_q_lock);
 
-	if (!retval)
+	if (!retval) {
+		/* NOTE: ONLY TOUCH SYNC req AGAIN ON req->completion. */
 		wait_for_completion(&req->completion);
+	}
 
 	zfcp_fsf_req_free(req);
 
@@ -1493,6 +1518,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 		erp_action->fsf_req_id = 0;
 		put_device(&port->dev);
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -1557,6 +1583,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -1626,6 +1653,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
 		zfcp_fsf_req_free(req);
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
@@ -1681,6 +1709,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
 		zfcp_fsf_req_free(req);
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
@@ -1776,6 +1805,7 @@ int zfcp_fsf_close_physical_port(struct
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -1899,6 +1929,7 @@ int zfcp_fsf_open_lun(struct zfcp_erp_ac
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -1987,6 +2018,7 @@ int zfcp_fsf_close_lun(struct zfcp_erp_a
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
@@ -2299,6 +2331,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *
 	retval = zfcp_fsf_req_send(req);
 	if (unlikely(retval))
 		goto failed_scsi_cmnd;
+	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
@@ -2373,8 +2406,10 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_m
 	zfcp_fc_fcp_tm(fcp_cmnd, sdev, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_SCSI_ER_TIMEOUT);
-	if (!zfcp_fsf_req_send(req))
+	if (!zfcp_fsf_req_send(req)) {
+		/* NOTE: DO NOT TOUCH req, UNTIL IT COMPLETES! */
 		goto out;
+	}
 
 	zfcp_fsf_req_free(req);
 	req = NULL;


