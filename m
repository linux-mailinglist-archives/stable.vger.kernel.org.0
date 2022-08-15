Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534CE59354A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbiHOSWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbiHOSVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BB62CCB4;
        Mon, 15 Aug 2022 11:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98C52B81076;
        Mon, 15 Aug 2022 18:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E10C433C1;
        Mon, 15 Aug 2022 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587412;
        bh=a6j4RgwOgiEoI3IwAnr6EUont6HIFzm1Q6gAlMKqAhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4oFIyipyGmHmFwVUdvjx5mdnibkRdYmxHiani6iOk3Zw4pUJG2HUYPfLNPfoQHh3
         qH3XTVbcPQ9AQKNjgzNRskAAZY9QK8YVUfW9iGMq65VRBC9okumdBKmhDpf2OVgN1T
         tyraaay7dB8xWBn+T2c5OmrRLJfygtiYl+uyk5hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 078/779] scsi: sg: Allow waiting for commands to complete on removed device
Date:   Mon, 15 Aug 2022 19:55:22 +0200
Message-Id: <20220815180340.637103624@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
 drivers/scsi/sg.c |   53 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -191,7 +191,7 @@ static void sg_link_reserve(Sg_fd * sfp,
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static Sg_fd *sg_add_sfp(Sg_device * sdp);
 static void sg_remove_sfp(struct kref *);
-static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
+static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id, bool *busy);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static Sg_device *sg_get_dev(int dev);
@@ -445,6 +445,7 @@ sg_read(struct file *filp, char __user *
 	Sg_fd *sfp;
 	Sg_request *srp;
 	int req_pack_id = -1;
+	bool busy;
 	sg_io_hdr_t *hp;
 	struct sg_header *old_hdr;
 	int retval;
@@ -467,20 +468,16 @@ sg_read(struct file *filp, char __user *
 	if (retval)
 		return retval;
 
-	srp = sg_get_rq_mark(sfp, req_pack_id);
+	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (atomic_read(&sdp->detaching))
-			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 		retval = wait_event_interruptible(sfp->read_wait,
-			(atomic_read(&sdp->detaching) ||
-			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (atomic_read(&sdp->detaching))
-			return -ENODEV;
-		if (retval)
-			/* -ERESTARTSYS as signal hit process */
-			return retval;
+			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
+			(!busy && atomic_read(&sdp->detaching))));
+		if (!srp)
+			/* signal or detaching */
+			return retval ? retval : -ENODEV;
 	}
 	if (srp->header.interface_id != '\0')
 		return sg_new_read(sfp, buf, count, srp);
@@ -941,9 +938,7 @@ sg_ioctl_common(struct file *filp, Sg_de
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
@@ -2056,19 +2051,28 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_reques
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
@@ -2122,6 +2126,15 @@ sg_remove_request(Sg_fd * sfp, Sg_reques
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
 


