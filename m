Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB8859D643
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243070AbiHWI1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243032AbiHWIWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52685719A1;
        Tue, 23 Aug 2022 01:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B62B81C25;
        Tue, 23 Aug 2022 08:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBF7C433C1;
        Tue, 23 Aug 2022 08:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242361;
        bh=+4mqkUOQ6qxlFBMqnZ3APWQWTom/BEONGf/ObWlgZYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCIzdXWbUwqf5aPPghHjomZdjF3FAvciZmJOVVMiTJ9BQ0Q5qUIOTIaxxo/pN3B6j
         lCBE3FKaz9tQvC7bpCLyLwIOzK4u+n1QOc+5sAkKkcAUEpB4yL5ouUV3wEcjVylBc/
         HusDCgSv7/VVe/GQpj04Bt2MNl63nGekGug6l+o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 060/101] scsi: sg: Allow waiting for commands to complete on removed device
Date:   Tue, 23 Aug 2022 10:03:33 +0200
Message-Id: <20220823080036.885931244@linuxfoundation.org>
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

From: Tony Battersby <tonyb@cybernetics.com>

commit 3455607fd7be10b449f5135c00dc306b85dc0d21 upstream.

When a SCSI device is removed while in active use, currently sg will
immediately return -ENODEV on any attempt to wait for active commands that
were sent before the removal.  This is problematic for commands that use
SG_FLAG_DIRECT_IO since the data buffer may still be in use by the kernel
when userspace frees or reuses it after getting ENODEV, leading to
corrupted userspace memory (in the case of READ-type commands) or corrupted
data being sent to the device (in the case of WRITE-type commands).  This
has been seen in practice when logging out of a iscsi_tcp session, where
the iSCSI driver may still be processing commands after the device has been
marked for removal.

Change the policy to allow userspace to wait for active sg commands even
when the device is being removed.  Return -ENODEV only when there are no
more responses to read.

Link: https://lore.kernel.org/r/5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com
Cc: <stable@vger.kernel.org>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |   57 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -196,7 +196,7 @@ static void sg_link_reserve(Sg_fd * sfp,
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static Sg_fd *sg_add_sfp(Sg_device * sdp);
 static void sg_remove_sfp(struct kref *);
-static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
+static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id, bool *busy);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static Sg_device *sg_get_dev(int dev);
@@ -418,6 +418,7 @@ sg_read(struct file *filp, char __user *
 	Sg_fd *sfp;
 	Sg_request *srp;
 	int req_pack_id = -1;
+	bool busy;
 	sg_io_hdr_t *hp;
 	struct sg_header *old_hdr = NULL;
 	int retval = 0;
@@ -465,25 +466,19 @@ sg_read(struct file *filp, char __user *
 		} else
 			req_pack_id = old_hdr->pack_id;
 	}
-	srp = sg_get_rq_mark(sfp, req_pack_id);
+	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
 		if (filp->f_flags & O_NONBLOCK) {
 			retval = -EAGAIN;
 			goto free_old_hdr;
 		}
 		retval = wait_event_interruptible(sfp->read_wait,
-			(atomic_read(&sdp->detaching) ||
-			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (retval) {
-			/* -ERESTARTSYS as signal hit process */
+			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
+			(!busy && atomic_read(&sdp->detaching))));
+		if (!srp) {
+			/* signal or detaching */
+			if (!retval)
+				retval = -ENODEV;
 			goto free_old_hdr;
 		}
 	}
@@ -936,9 +931,7 @@ sg_ioctl(struct file *filp, unsigned int
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
-			(srp_done(sfp, srp) || atomic_read(&sdp->detaching)));
-		if (atomic_read(&sdp->detaching))
-			return -ENODEV;
+			srp_done(sfp, srp));
 		write_lock_irq(&sfp->rq_list_lock);
 		if (srp->done) {
 			srp->done = 2;
@@ -2095,19 +2088,28 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_reques
 }
 
 static Sg_request *
-sg_get_rq_mark(Sg_fd * sfp, int pack_id)
+sg_get_rq_mark(Sg_fd * sfp, int pack_id, bool *busy)
 {
 	Sg_request *resp;
 	unsigned long iflags;
 
+	*busy = false;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	list_for_each_entry(resp, &sfp->rq_list, entry) {
-		/* look for requests that are ready + not SG_IO owned */
-		if ((1 == resp->done) && (!resp->sg_io_owned) &&
+		/* look for requests that are not SG_IO owned */
+		if ((!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
-			resp->done = 2;	/* guard against other readers */
-			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			return resp;
+			switch (resp->done) {
+			case 0: /* request active */
+				*busy = true;
+				break;
+			case 1: /* request done; response ready to return */
+				resp->done = 2;	/* guard against other readers */
+				write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+				return resp;
+			case 2: /* response already being returned */
+				break;
+			}
 		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
@@ -2161,6 +2163,15 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
 		res = 1;
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+
+	/*
+	 * If the device is detaching, wakeup any readers in case we just
+	 * removed the last response, which would leave nothing for them to
+	 * return other than -ENODEV.
+	 */
+	if (unlikely(atomic_read(&sfp->parentdp->detaching)))
+		wake_up_interruptible_all(&sfp->read_wait);
+
 	return res;
 }
 


