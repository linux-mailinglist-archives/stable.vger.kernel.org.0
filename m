Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473321F44FD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgFISKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41376 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388159AbgFISF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pL-CH; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vvr-A4; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Todd Poynor" <toddpoynor@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Tue, 09 Jun 2020 19:04:19 +0100
Message-ID: <lsq.1591725832.527833274@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 28/61] scsi: sg: protect against races between mmap()
 and SG_SET_RESERVED_SIZE
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

From: Todd Poynor <toddpoynor@google.com>

commit 6a8dadcca81fceff9976e8828cceb072873b7bd5 upstream.

Take f_mutex around mmap() processing to protect against races with the
SG_SET_RESERVED_SIZE ioctl.  Ensure the reserve buffer length remains
consistent during the mapping operation, and set the "mmap called" flag
to prevent further changes to the reserved buffer size as an atomic
operation with the mapping.

[mkp: fixed whitespace]

Signed-off-by: Todd Poynor <toddpoynor@google.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1310,6 +1310,7 @@ sg_mmap(struct file *filp, struct vm_are
 	unsigned long req_sz, len, sa;
 	Sg_scatter_hold *rsv_schp;
 	int k, length;
+	int ret = 0;
 
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
@@ -1319,8 +1320,11 @@ sg_mmap(struct file *filp, struct vm_are
 	if (vma->vm_pgoff)
 		return -EINVAL;	/* want no offset */
 	rsv_schp = &sfp->reserve;
-	if (req_sz > rsv_schp->bufflen)
-		return -ENOMEM;	/* cannot map more than reserved buffer */
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		ret = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
 
 	sa = vma->vm_start;
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
@@ -1334,7 +1338,9 @@ sg_mmap(struct file *filp, struct vm_are
 	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
-	return 0;
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return ret;
 }
 
 static void

