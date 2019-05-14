Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB81E54A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 00:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbfENWrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 18:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENWrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 18:47:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ACBB20873;
        Tue, 14 May 2019 22:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557874021;
        bh=PrgaOY1/49I9NHSqXEBWVTZLmX86myiyLyj4i5D4EpQ=;
        h=Date:From:To:Subject:From;
        b=NhS+JtMe6ijd4NLcdcnJcrS0RQjjUY8hcATsdSDTvhuVBtws3ToxLYCWFi4iqPANV
         JZidM85I3bn+ThbVAfjEIo2mTW3bIX4E5wHtLBwhkhk+EoVuquowALbA1GNidw8XT0
         RnBosO1rHkZZc9lbYzBKAoFW4sLaXe9+16obmoYU=
Date:   Tue, 14 May 2019 15:47:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        galak@kernel.crashing.org, mihai.caraman@freescale.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        timur@freescale.com, torvalds@linux-foundation.org
Subject:  [patch 121/126] drivers/virt/fsl_hypervisor.c:
 dereferencing error pointers in ioctl
Message-ID: <20190514224700.fNCksvjNu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl

strndup_user() returns error pointers on error, and then in the error
handling we pass the error pointers to kfree().  It will cause an Oops.

Link: http://lkml.kernel.org/r/20181218082003.GD32567@kadam
Fixes: 6db7199407ca ("drivers/virt: introduce Freescale hypervisor management driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mihai Caraman <mihai.caraman@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virt/fsl_hypervisor.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/virt/fsl_hypervisor.c~fsl_hypervisor-dereferencing-error-pointers-in-ioctl
+++ a/drivers/virt/fsl_hypervisor.c
@@ -331,8 +331,8 @@ static long ioctl_dtprop(struct fsl_hv_i
 	struct fsl_hv_ioctl_prop param;
 	char __user *upath, *upropname;
 	void __user *upropval;
-	char *path = NULL, *propname = NULL;
-	void *propval = NULL;
+	char *path, *propname;
+	void *propval;
 	int ret = 0;
 
 	/* Get the parameters from the user. */
@@ -344,32 +344,30 @@ static long ioctl_dtprop(struct fsl_hv_i
 	upropval = (void __user *)(uintptr_t)param.propval;
 
 	path = strndup_user(upath, FH_DTPROP_MAX_PATHLEN);
-	if (IS_ERR(path)) {
-		ret = PTR_ERR(path);
-		goto out;
-	}
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	propname = strndup_user(upropname, FH_DTPROP_MAX_PATHLEN);
 	if (IS_ERR(propname)) {
 		ret = PTR_ERR(propname);
-		goto out;
+		goto err_free_path;
 	}
 
 	if (param.proplen > FH_DTPROP_MAX_PROPLEN) {
 		ret = -EINVAL;
-		goto out;
+		goto err_free_propname;
 	}
 
 	propval = kmalloc(param.proplen, GFP_KERNEL);
 	if (!propval) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_free_propname;
 	}
 
 	if (set) {
 		if (copy_from_user(propval, upropval, param.proplen)) {
 			ret = -EFAULT;
-			goto out;
+			goto err_free_propval;
 		}
 
 		param.ret = fh_partition_set_dtprop(param.handle,
@@ -388,7 +386,7 @@ static long ioctl_dtprop(struct fsl_hv_i
 			if (copy_to_user(upropval, propval, param.proplen) ||
 			    put_user(param.proplen, &p->proplen)) {
 				ret = -EFAULT;
-				goto out;
+				goto err_free_propval;
 			}
 		}
 	}
@@ -396,10 +394,12 @@ static long ioctl_dtprop(struct fsl_hv_i
 	if (put_user(param.ret, &p->ret))
 		ret = -EFAULT;
 
-out:
-	kfree(path);
+err_free_propval:
 	kfree(propval);
+err_free_propname:
 	kfree(propname);
+err_free_path:
+	kfree(path);
 
 	return ret;
 }
_
