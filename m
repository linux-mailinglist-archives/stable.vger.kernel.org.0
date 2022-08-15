Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D67F59313D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiHOPDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiHOPDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:03:39 -0400
Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE51EAF3
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:03:36 -0700 (PDT)
X-ASG-Debug-ID: 1660575814-1cf4391f3b75130001-OJig3u
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 0cTyYB4gH85KfXgW; Mon, 15 Aug 2022 11:03:34 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
        bh=HcRXhw7dHzGFUyyLapieYvoKTRMM1lzppkMLKGQAzpc=;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To:
        Content-Language:Subject:MIME-Version:Date:Message-ID; b=caBe5twvycFNtn+PKQjb
        v9kfs8mkSg4WE4UTsWfeRBsiFtWrEdqxb5/NAxoYPDZL261ttj1lYFxEFAnm6QaKlgz6eOp1d6Md/
        GAba8eSpihRsn0EqhdT5731smXVwNh2nY7rAdWH+uhRjNGFI3R4fgIHxJ8FHUjvsW+bHWZkv2c=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 7.1.1)
  with ESMTPS id 12137875; Mon, 15 Aug 2022 11:03:34 -0400
Message-ID: <f6d97c65-08c7-28f8-7d63-dd4ed9fb6423@cybernetics.com>
Date:   Mon, 15 Aug 2022 11:03:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH] scsi: sg: Allow waiting for commands to complete on removed
 device
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH] scsi: sg: Allow waiting for commands to complete on removed
 device
To:     gregkh@linuxfoundation.org, dgilbert@interlog.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
References: <166039721378118@kroah.com>
From:   Tony Battersby <tonyb@cybernetics.com>
In-Reply-To: <166039721378118@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1660575814
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 5516
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This backport applies to 4.19, 4.14, and 4.9.  The only difference from the
upstream commit is "goto free_old_hdr" instead of just return retval in
sg_read().

---

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
---
 drivers/scsi/sg.c | 57 ++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 6bb45ae19d58..339582690482 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -195,7 +195,7 @@ static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
 static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
 static Sg_fd *sg_add_sfp(Sg_device * sdp);
 static void sg_remove_sfp(struct kref *);
-static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
+static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id, bool *busy);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static Sg_device *sg_get_dev(int dev);
@@ -417,6 +417,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	Sg_fd *sfp;
 	Sg_request *srp;
 	int req_pack_id = -1;
+	bool busy;
 	sg_io_hdr_t *hp;
 	struct sg_header *old_hdr = NULL;
 	int retval = 0;
@@ -464,25 +465,19 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
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
@@ -933,9 +928,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
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
@@ -2079,19 +2072,28 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
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
@@ -2145,6 +2147,15 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
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
 

