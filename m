Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C891F44B7
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbgFISHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:07:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41510 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388194AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pb-Hv; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006VwL-J4; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <alexander.levin@microsoft.com>,
        "Hannes Reinecke" <hare@suse.com>, "Hannes Reinecke" <hare@suse.de>
Date:   Tue, 09 Jun 2020 19:04:29 +0100
Message-ID: <lsq.1591725832.372855628@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 38/61] scsi: sg: close race condition in
 sg_remove_sfp_usercontext()
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 97d27b0dd015e980ade63fda111fd1353276e28b upstream.

sg_remove_sfp_usercontext() is clearing any sg requests, but needs to
take 'rq_list_lock' when modifying the list.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -561,6 +561,7 @@ sg_read(struct file *filp, char __user *
 	} else
 		count = (old_hdr->result == 0) ? 0 : -EIO;
 	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	retval = count;
 free_old_hdr:
 	kfree(old_hdr);
@@ -601,6 +602,7 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	}
 err_out:
 	err2 = sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	return err ? : err2 ? : count;
 }
 
@@ -835,6 +837,7 @@ sg_common_write(Sg_fd * sfp, Sg_request
 	if (k) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: start_req err=%d\n", k));
 		sg_finish_rem_req(srp);
+		sg_remove_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if (atomic_read(&sdp->detaching)) {
@@ -844,6 +847,7 @@ sg_common_write(Sg_fd * sfp, Sg_request
 		}
 
 		sg_finish_rem_req(srp);
+		sg_remove_request(sfp, srp);
 		return -ENODEV;
 	}
 
@@ -1367,6 +1371,7 @@ sg_rq_end_io_usercontext(struct work_str
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_rem_req(srp);
+	sg_remove_request(sfp, srp);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
@@ -1876,8 +1881,6 @@ sg_finish_rem_req(Sg_request *srp)
 	else
 		sg_remove_scat(req_schp);
 
-	sg_remove_request(sfp, srp);
-
 	return ret;
 }
 
@@ -2211,12 +2214,17 @@ sg_remove_sfp_usercontext(struct work_st
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
 	Sg_request *srp;
+	unsigned long iflags;
 
 	/* Cleanup any responses which were never read(). */
+	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
 		srp = list_first_entry(&sfp->rq_list, Sg_request, entry);
 		sg_finish_rem_req(srp);
+		list_del(&srp->entry);
+		srp->parentfp = NULL;
 	}
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6,

