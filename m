Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E51EFBA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfEOLew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732773AbfEOLd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:33:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 602BA2053B;
        Wed, 15 May 2019 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557920036;
        bh=okYy+GU6/N0t4Tvh74P9xri3NwBQ8lf9DQZpI4Zyqi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Obk+UDVriScmBmqtTQTV2Sb/skIPxEf668Cyzc4SIYowHRbDTJjiHYB/fVMuoZr0y
         fHQs116BmFOJecewyPb3t28xeqcx5RFxJ5Wzev+tHrIbwrq4CwnpJ3un3o8T6csjVY
         xuA/POvZ2dJmuMAuG06dqhT8cfMs5Fny5qnoAkW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Timur Tabi <timur@freescale.com>,
        Mihai Caraman <mihai.caraman@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 37/46] drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
Date:   Wed, 15 May 2019 12:57:01 +0200
Message-Id: <20190515090627.583258620@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c8ea3663f7a8e6996d44500ee818c9330ac4fd88 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virt/fsl_hypervisor.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
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


