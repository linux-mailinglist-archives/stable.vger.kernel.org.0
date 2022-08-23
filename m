Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD8059D427
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242184AbiHWISi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243089AbiHWIQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF53221C;
        Tue, 23 Aug 2022 01:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44C23CE1B34;
        Tue, 23 Aug 2022 08:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586DFC433C1;
        Tue, 23 Aug 2022 08:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242281;
        bh=3kgCWr/9Yz/w42SG8TGD1zCe+nVKHUMGdTqNB2qWAzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axI3Vxbt/VxXJGrVbhE5ZMXnCsLN3/KjUowCV3sJjd3D30iyhgXgf3yX9fes8wudu
         FhvAOq+gz5lj1JgkPiBKmCJFfSXCz5sQVkFXd7iYDymi1AmwhkUeECCJsu7b8yUR2Y
         I/C12jvVD6zxI8ZDq+VNQjPRefcbejENpaNO4AgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 047/101] scsi: zfcp: Fix missing auto port scan and thus missing target ports
Date:   Tue, 23 Aug 2022 10:03:20 +0200
Message-Id: <20220823080036.337944190@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steffen Maier <maier@linux.ibm.com>

commit 4da8c5f76825269f28d6a89fa752934a4bcb6dfa upstream.

Case (1):
  The only waiter on wka_port->completion_wq is zfcp_fc_wka_port_get()
  trying to open a WKA port. As such it should only be woken up by WKA port
  *open* responses, not by WKA port close responses.

Case (2):
  A close WKA port response coming in just after having sent a new open WKA
  port request and before blocking for the open response with wait_event()
  in zfcp_fc_wka_port_get() erroneously renders the wait_event a NOP
  because the close handler overwrites wka_port->status. Hence the
  wait_event condition is erroneously true and it does not enter blocking
  state.

With non-negligible probability, the following time space sequence happens
depending on timing without this fix:

user process        ERP thread zfcp work queue tasklet system work queue
============        ========== =============== ======= =================
$ echo 1 > online
zfcp_ccw_set_online
zfcp_ccw_activate
zfcp_erp_adapter_reopen
msleep scan backoff zfcp_erp_strategy
|                   ...
|                   zfcp_erp_action_cleanup
|                   ...
|                   queue delayed scan_work
|                   queue ns_up_work
|                              ns_up_work:
|                              zfcp_fc_wka_port_get
|                               open wka request
|                                              open response
|                              GSPN FC-GS
|                              RSPN FC-GS [NPIV-only]
|                              zfcp_fc_wka_port_put
|                               (--wka->refcount==0)
|                               sched delayed wka->work
|
~~~Case (1)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
zfcp_erp_wait
flush scan_work
|                                                      wka->work:
|                                                      wka->status=CLOSING
|                                                      close wka request
|                              scan_work:
|                              zfcp_fc_wka_port_get
|                               (wka->status==CLOSING)
|                               wka->status=OPENING
|                               open wka request
|                               wait_event
|                               |              close response
|                               |              wka->status=OFFLINE
|                               |              wake_up /*WRONG*/
~~~Case (2)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|                                                      wka->work:
|                                                      wka->status=CLOSING
|                                                      close wka request
zfcp_erp_wait
flush scan_work
|                              scan_work:
|                              zfcp_fc_wka_port_get
|                               (wka->status==CLOSING)
|                               wka->status=OPENING
|                               open wka request
|                                              close response
|                                              wka->status=OFFLINE
|                                              wake_up /*WRONG&NOP*/
|                               wait_event /*NOP*/
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|                               (wka->status!=ONLINE)
|                               return -EIO
|                              return early
                                               open response
                                               wka->status=ONLINE
                                               wake_up /*NOP*/

So we erroneously end up with no automatic port scan. This is a big problem
when it happens during boot. The timing is influenced by v3.19 commit
18f87a67e6d6 ("zfcp: auto port scan resiliency").

Fix it by fully mutually excluding zfcp_fc_wka_port_get() and
zfcp_fc_wka_port_offline(). For that to work, we make the latter block
until we got the response for a close WKA port. In order not to penalize
the system workqueue, we move wka_port->work to our own adapter workqueue.
Note that before v2.6.30 commit 828bc1212a68 ("[SCSI] zfcp: Set WKA-port to
offline on adapter deactivation"), zfcp did block in
zfcp_fc_wka_port_offline() as well, but with a different condition.

While at it, make non-functional cleanups to improve code reading in
zfcp_fc_wka_port_get(). If we cannot send the WKA port open request, don't
rely on the subsequent wait_event condition to immediately let this case
pass without blocking. Also don't want to rely on the additional condition
handling the refcount to be skipped just to finally return with -EIO.

Link: https://lore.kernel.org/r/20220729162529.1620730-1-maier@linux.ibm.com
Fixes: 5ab944f97e09 ("[SCSI] zfcp: attach and release SAN nameserver port on demand")
Cc: <stable@vger.kernel.org> #v2.6.28+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_fc.c  |   29 ++++++++++++++++++++---------
 drivers/s390/scsi/zfcp_fc.h  |    6 ++++--
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 3 files changed, 26 insertions(+), 13 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -144,27 +144,33 @@ void zfcp_fc_enqueue_event(struct zfcp_a
 
 static int zfcp_fc_wka_port_get(struct zfcp_fc_wka_port *wka_port)
 {
+	int ret = -EIO;
+
 	if (mutex_lock_interruptible(&wka_port->mutex))
 		return -ERESTARTSYS;
 
 	if (wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE ||
 	    wka_port->status == ZFCP_FC_WKA_PORT_CLOSING) {
 		wka_port->status = ZFCP_FC_WKA_PORT_OPENING;
-		if (zfcp_fsf_open_wka_port(wka_port))
+		if (zfcp_fsf_open_wka_port(wka_port)) {
+			/* could not even send request, nothing to wait for */
 			wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
+			goto out;
+		}
 	}
 
-	mutex_unlock(&wka_port->mutex);
-
-	wait_event(wka_port->completion_wq,
+	wait_event(wka_port->opened,
 		   wka_port->status == ZFCP_FC_WKA_PORT_ONLINE ||
 		   wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE);
 
 	if (wka_port->status == ZFCP_FC_WKA_PORT_ONLINE) {
 		atomic_inc(&wka_port->refcount);
-		return 0;
+		ret = 0;
+		goto out;
 	}
-	return -EIO;
+out:
+	mutex_unlock(&wka_port->mutex);
+	return ret;
 }
 
 static void zfcp_fc_wka_port_offline(struct work_struct *work)
@@ -180,9 +186,12 @@ static void zfcp_fc_wka_port_offline(str
 
 	wka_port->status = ZFCP_FC_WKA_PORT_CLOSING;
 	if (zfcp_fsf_close_wka_port(wka_port)) {
+		/* could not even send request, nothing to wait for */
 		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
-		wake_up(&wka_port->completion_wq);
+		goto out;
 	}
+	wait_event(wka_port->closed,
+		   wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE);
 out:
 	mutex_unlock(&wka_port->mutex);
 }
@@ -192,13 +201,15 @@ static void zfcp_fc_wka_port_put(struct
 	if (atomic_dec_return(&wka_port->refcount) != 0)
 		return;
 	/* wait 10 milliseconds, other reqs might pop in */
-	schedule_delayed_work(&wka_port->work, HZ / 100);
+	queue_delayed_work(wka_port->adapter->work_queue, &wka_port->work,
+			   msecs_to_jiffies(10));
 }
 
 static void zfcp_fc_wka_port_init(struct zfcp_fc_wka_port *wka_port, u32 d_id,
 				  struct zfcp_adapter *adapter)
 {
-	init_waitqueue_head(&wka_port->completion_wq);
+	init_waitqueue_head(&wka_port->opened);
+	init_waitqueue_head(&wka_port->closed);
 
 	wka_port->adapter = adapter;
 	wka_port->d_id = d_id;
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -169,7 +169,8 @@ enum zfcp_fc_wka_status {
 /**
  * struct zfcp_fc_wka_port - representation of well-known-address (WKA) FC port
  * @adapter: Pointer to adapter structure this WKA port belongs to
- * @completion_wq: Wait for completion of open/close command
+ * @opened: Wait for completion of open command
+ * @closed: Wait for completion of close command
  * @status: Current status of WKA port
  * @refcount: Reference count to keep port open as long as it is in use
  * @d_id: FC destination id or well-known-address
@@ -179,7 +180,8 @@ enum zfcp_fc_wka_status {
  */
 struct zfcp_fc_wka_port {
 	struct zfcp_adapter	*adapter;
-	wait_queue_head_t	completion_wq;
+	wait_queue_head_t	opened;
+	wait_queue_head_t	closed;
 	enum zfcp_fc_wka_status	status;
 	atomic_t		refcount;
 	u32			d_id;
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1582,7 +1582,7 @@ static void zfcp_fsf_open_wka_port_handl
 		wka_port->status = ZFCP_FC_WKA_PORT_ONLINE;
 	}
 out:
-	wake_up(&wka_port->completion_wq);
+	wake_up(&wka_port->opened);
 }
 
 /**
@@ -1640,7 +1640,7 @@ static void zfcp_fsf_close_wka_port_hand
 	}
 
 	wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
-	wake_up(&wka_port->completion_wq);
+	wake_up(&wka_port->closed);
 }
 
 /**


