Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF59F2FA30E
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392968AbhARObZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbhARLnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA7222C9E;
        Mon, 18 Jan 2021 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970163;
        bh=ZaxmYAtPovvFtipAxAYfImaO2vyGuNvCQP6Vs2/QdZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewaf+X+bttecWHAcOEO8QjR5V7kJr8g2rDKmo4zwhA7wHHEG6RdZqFGN+YrtvMe/O
         qPt0QDhe/nJtpcLCVy2WZJ9qqhtPZQLUFMT0wviGix1Xi4mukLTeX5RAVEwOCSzHhL
         du76mQEWKsKlD2womm8TSq5l9OVU4+esvKY0E3YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH 5.10 036/152] xen/privcmd: allow fetching resource sizes
Date:   Mon, 18 Jan 2021 12:33:31 +0100
Message-Id: <20210118113354.512931546@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit ef3a575baf53571dc405ee4028e26f50856898e7 upstream.

Allow issuing an IOCTL_PRIVCMD_MMAP_RESOURCE ioctl with num = 0 and
addr = 0 in order to fetch the size of a specific resource.

Add a shortcut to the default map resource path, since fetching the
size requires no address to be passed in, and thus no VMA to setup.

This is missing from the initial implementation, and causes issues
when mapping resources that don't have fixed or known sizes.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: stable@vger.kernel.org # >= 4.18
Link: https://lore.kernel.org/r/20210112115358.23346-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/privcmd.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -717,14 +717,15 @@ static long privcmd_ioctl_restrict(struc
 	return 0;
 }
 
-static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
+static long privcmd_ioctl_mmap_resource(struct file *file,
+				struct privcmd_mmap_resource __user *udata)
 {
 	struct privcmd_data *data = file->private_data;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct privcmd_mmap_resource kdata;
 	xen_pfn_t *pfns = NULL;
-	struct xen_mem_acquire_resource xdata;
+	struct xen_mem_acquire_resource xdata = { };
 	int rc;
 
 	if (copy_from_user(&kdata, udata, sizeof(kdata)))
@@ -734,6 +735,22 @@ static long privcmd_ioctl_mmap_resource(
 	if (data->domid != DOMID_INVALID && data->domid != kdata.dom)
 		return -EPERM;
 
+	/* Both fields must be set or unset */
+	if (!!kdata.addr != !!kdata.num)
+		return -EINVAL;
+
+	xdata.domid = kdata.dom;
+	xdata.type = kdata.type;
+	xdata.id = kdata.id;
+
+	if (!kdata.addr && !kdata.num) {
+		/* Query the size of the resource. */
+		rc = HYPERVISOR_memory_op(XENMEM_acquire_resource, &xdata);
+		if (rc)
+			return rc;
+		return __put_user(xdata.nr_frames, &udata->num);
+	}
+
 	mmap_write_lock(mm);
 
 	vma = find_vma(mm, kdata.addr);
@@ -768,10 +785,6 @@ static long privcmd_ioctl_mmap_resource(
 	} else
 		vma->vm_private_data = PRIV_VMA_LOCKED;
 
-	memset(&xdata, 0, sizeof(xdata));
-	xdata.domid = kdata.dom;
-	xdata.type = kdata.type;
-	xdata.id = kdata.id;
 	xdata.frame = kdata.idx;
 	xdata.nr_frames = kdata.num;
 	set_xen_guest_handle(xdata.frame_list, pfns);


