Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F8320DE69
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732641AbgF2UZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732538AbgF2TZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D66C253FE;
        Mon, 29 Jun 2020 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445349;
        bh=6NCLh468s3MnlmKfmD9EEgmVzGE5yq/Xs2FkF+dWh/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osOpiINohpJwWVf4fUVmWqSRWQYRDKTk3DE18ZbLXm3X2MvEmAd8Vd17h0Ibx7zUG
         7U3cSOKdb/XeSh0K788JfKz1N3FnkzE7UFAnXktXo/5kfMzZKZUipWAfk4ieRXB5g6
         0M1ePz+2LvljTgRsyc0SEsZZQnoZIRmnfcqrlWpw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 107/191] media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
Date:   Mon, 29 Jun 2020 11:38:43 -0400
Message-Id: <20200629154007.2495120-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 2b5df42b8dec69fb926a242007fd462343db4408 upstream

Use a switch() on this function, just like on other ioctl
handlers and handle parameters inside each part of the
switch.

That makes it easier to integrate with the already existing
ioctl handler function.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 83 ++++++++++++++++-----------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2bf55a786e297..c446f51be21a9 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1956,21 +1956,25 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = 0;
-
-	struct dtv_properties *tvps = parg;
-	struct dtv_property *tvp = NULL;
-	int i;
+	int err, i;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-	if (cmd == FE_SET_PROPERTY) {
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
+	switch(cmd) {
+	case FE_SET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
 		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
@@ -1979,23 +1983,34 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_set(fe, tvp + i, file);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 			(tvp + i)->result = err;
 		}
 
 		if (c->state == DTV_TUNE)
 			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
 
-	} else if (cmd == FE_GET_PROPERTY) {
+		kfree(tvp);
+		break;
+	}
+	case FE_GET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
 		struct dtv_frontend_properties getp = fe->dtv_property_cache;
 
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
 		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
@@ -2010,28 +2025,32 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 */
 		if (fepriv->state != FESTATE_IDLE) {
 			err = dtv_get_frontend(fe, &getp, NULL);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, &getp, tvp + i, file);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user((void __user *)tvps->props, tvp,
 				 tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
+			kfree(tvp);
+			return -EFAULT;
 		}
-
-	} else
-		err = -EOPNOTSUPP;
-
-out:
-	kfree(tvp);
-	return err;
+		kfree(tvp);
+		break;
+	}
+	default:
+		return -ENOTSUPP;
+	} /* switch */
+	return 0;
 }
 
 static int dtv_set_frontend(struct dvb_frontend *fe)
-- 
2.25.1

