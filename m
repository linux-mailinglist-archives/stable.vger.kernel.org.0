Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8927120DE6B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387511AbgF2UZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732532AbgF2TZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F1E825401;
        Mon, 29 Jun 2020 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445350;
        bh=mo3l9q4Tox/YgLQW2eD488VoAaRiIA4FjGSqBi2KuAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0/BJNy4Zk9v++cVzmaq8fF+SVlhvBaeHHGLJmqvhi7wMwzvrcbDhKhfVj6RVFLq5
         aH/wCiz3wc3rMbY/E8qwlIufK8AkY1T9ZXT7/WcZOM2C5QmDWPKMpzOcVsEVhz1P8T
         akwvhDp61xh09eyCJfdbHFno9NGF/F9nKKNFTnas=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 108/191] media: dvb_frontend: cleanup ioctl handling logic
Date:   Mon, 29 Jun 2020 11:38:44 -0400
Message-Id: <20200629154007.2495120-109-sashal@kernel.org>
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

commit d73dcf0cdb95a47f7e4e991ab63dd30f6eb67b4e upstream

Currently, there are two handlers for ioctls:
 - dvb_frontend_ioctl_properties()
 - dvb_frontend_ioctl_legacy()

Despite their names, both handles non-legacy DVB ioctls.

Besides that, there's no reason why to not handle all ioctls
on a single handler function.

So, merge them into a single function (dvb_frontend_handle_ioctl)
and reorganize the ioctl's to indicate what's the current DVB
API and what's deprecated.

Despite the big diff, the handling logic for each ioctl is the
same as before.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 328 +++++++++++++-------------
 1 file changed, 158 insertions(+), 170 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c446f51be21a9..5b06ac91420ff 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1296,10 +1296,8 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int dvb_frontend_ioctl_legacy(struct file *file,
-			unsigned int cmd, void *parg);
-static int dvb_frontend_ioctl_properties(struct file *file,
-			unsigned int cmd, void *parg);
+static int dvb_frontend_handle_ioctl(struct file *file,
+				     unsigned int cmd, void *parg);
 
 static int dtv_property_process_get(struct dvb_frontend *fe,
 				    const struct dtv_frontend_properties *c,
@@ -1801,12 +1799,12 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		break;
 	case DTV_VOLTAGE:
 		c->voltage = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_VOLTAGE,
+		r = dvb_frontend_handle_ioctl(file, FE_SET_VOLTAGE,
 			(void *)c->voltage);
 		break;
 	case DTV_TONE:
 		c->sectone = tvp->u.data;
-		r = dvb_frontend_ioctl_legacy(file, FE_SET_TONE,
+		r = dvb_frontend_handle_ioctl(file, FE_SET_TONE,
 			(void *)c->sectone);
 		break;
 	case DTV_CODE_RATE_HP:
@@ -1913,14 +1911,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct file *file,
-			unsigned int cmd, void *parg)
+static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
+	int err;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (down_interruptible(&fepriv->sem))
@@ -1938,121 +1935,13 @@ static int dvb_frontend_ioctl(struct file *file,
 		return -EPERM;
 	}
 
-	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
-		err = dvb_frontend_ioctl_properties(file, cmd, parg);
-	else {
-		c->state = DTV_UNDEFINED;
-		err = dvb_frontend_ioctl_legacy(file, cmd, parg);
-	}
+	c->state = DTV_UNDEFINED;
+	err = dvb_frontend_handle_ioctl(file, cmd, parg);
 
 	up(&fepriv->sem);
 	return err;
 }
 
-static int dvb_frontend_ioctl_properties(struct file *file,
-			unsigned int cmd, void *parg)
-{
-	struct dvb_device *dvbdev = file->private_data;
-	struct dvb_frontend *fe = dvbdev->priv;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err, i;
-
-	dev_dbg(fe->dvb->device, "%s:\n", __func__);
-
-	switch(cmd) {
-	case FE_SET_PROPERTY: {
-		struct dtv_properties *tvps = parg;
-		struct dtv_property *tvp = NULL;
-
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
-
-		/*
-		 * Put an arbitrary limit on the number of messages that can
-		 * be sent at once
-		 */
-		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
-		if (IS_ERR(tvp))
-			return PTR_ERR(tvp);
-
-		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_set(fe, tvp + i, file);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-			(tvp + i)->result = err;
-		}
-
-		if (c->state == DTV_TUNE)
-			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
-
-		kfree(tvp);
-		break;
-	}
-	case FE_GET_PROPERTY: {
-		struct dtv_properties *tvps = parg;
-		struct dtv_property *tvp = NULL;
-		struct dtv_frontend_properties getp = fe->dtv_property_cache;
-
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
-			__func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
-			__func__, tvps->props);
-
-		/*
-		 * Put an arbitrary limit on the number of messages that can
-		 * be sent at once
-		 */
-		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
-			return -EINVAL;
-
-		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
-		if (IS_ERR(tvp))
-			return PTR_ERR(tvp);
-
-		/*
-		 * Let's use our own copy of property cache, in order to
-		 * avoid mangling with DTV zigzag logic, as drivers might
-		 * return crap, if they don't check if the data is available
-		 * before updating the properties cache.
-		 */
-		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, &getp, NULL);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-		}
-		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_get(fe, &getp, tvp + i, file);
-			if (err < 0) {
-				kfree(tvp);
-				return err;
-			}
-			(tvp + i)->result = err;
-		}
-
-		if (copy_to_user((void __user *)tvps->props, tvp,
-				 tvps->num * sizeof(struct dtv_property))) {
-			kfree(tvp);
-			return -EFAULT;
-		}
-		kfree(tvp);
-		break;
-	}
-	default:
-		return -ENOTSUPP;
-	} /* switch */
-	return 0;
-}
-
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2190,16 +2079,105 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 }
 
 
-static int dvb_frontend_ioctl_legacy(struct file *file,
-			unsigned int cmd, void *parg)
+static int dvb_frontend_handle_ioctl(struct file *file,
+				     unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = -EOPNOTSUPP;
+	int i, err;
+
+	dev_dbg(fe->dvb->device, "%s:\n", __func__);
+
+	switch(cmd) {
+	case FE_SET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_set(fe, tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+			(tvp + i)->result = err;
+		}
+
+		if (c->state == DTV_TUNE)
+			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
+
+		kfree(tvp);
+		break;
+	}
+	case FE_GET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		/*
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
+		 */
+		if (fepriv->state != FESTATE_IDLE) {
+			err = dtv_get_frontend(fe, &getp, NULL);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_get(fe, &getp, tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+			(tvp + i)->result = err;
+		}
+
+		if (copy_to_user((void __user *)tvps->props, tvp,
+				 tvps->num * sizeof(struct dtv_property))) {
+			kfree(tvp);
+			return -EFAULT;
+		}
+		kfree(tvp);
+		break;
+	}
 
-	switch (cmd) {
 	case FE_GET_INFO: {
 		struct dvb_frontend_info* info = parg;
 
@@ -2263,42 +2241,6 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 	}
 
-	case FE_READ_BER:
-		if (fe->ops.read_ber) {
-			if (fepriv->thread)
-				err = fe->ops.read_ber(fe, (__u32 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_SIGNAL_STRENGTH:
-		if (fe->ops.read_signal_strength) {
-			if (fepriv->thread)
-				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_SNR:
-		if (fe->ops.read_snr) {
-			if (fepriv->thread)
-				err = fe->ops.read_snr(fe, (__u16 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
-	case FE_READ_UNCORRECTED_BLOCKS:
-		if (fe->ops.read_ucblocks) {
-			if (fepriv->thread)
-				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
-			else
-				err = -EAGAIN;
-		}
-		break;
-
 	case FE_DISEQC_RESET_OVERLOAD:
 		if (fe->ops.diseqc_reset_overload) {
 			err = fe->ops.diseqc_reset_overload(fe);
@@ -2350,6 +2292,23 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		}
 		break;
 
+	case FE_DISEQC_RECV_SLAVE_REPLY:
+		if (fe->ops.diseqc_recv_slave_reply)
+			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+		break;
+
+	case FE_ENABLE_HIGH_LNB_VOLTAGE:
+		if (fe->ops.enable_high_lnb_voltage)
+			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
+		break;
+
+	case FE_SET_FRONTEND_TUNE_MODE:
+		fepriv->tune_mode_flags = (unsigned long) parg;
+		err = 0;
+		break;
+
+	/* DEPRECATED dish control ioctls */
+
 	case FE_DISHNETWORK_SEND_LEGACY_CMD:
 		if (fe->ops.dishnetwork_send_legacy_command) {
 			err = fe->ops.dishnetwork_send_legacy_command(fe,
@@ -2414,16 +2373,46 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		}
 		break;
 
-	case FE_DISEQC_RECV_SLAVE_REPLY:
-		if (fe->ops.diseqc_recv_slave_reply)
-			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+	/* DEPRECATED statistics ioctls */
+
+	case FE_READ_BER:
+		if (fe->ops.read_ber) {
+			if (fepriv->thread)
+				err = fe->ops.read_ber(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
-	case FE_ENABLE_HIGH_LNB_VOLTAGE:
-		if (fe->ops.enable_high_lnb_voltage)
-			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
+	case FE_READ_SIGNAL_STRENGTH:
+		if (fe->ops.read_signal_strength) {
+			if (fepriv->thread)
+				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	case FE_READ_SNR:
+		if (fe->ops.read_snr) {
+			if (fepriv->thread)
+				err = fe->ops.read_snr(fe, (__u16 *) parg);
+			else
+				err = -EAGAIN;
+		}
+		break;
+
+	case FE_READ_UNCORRECTED_BLOCKS:
+		if (fe->ops.read_ucblocks) {
+			if (fepriv->thread)
+				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
+			else
+				err = -EAGAIN;
+		}
 		break;
 
+	/* DEPRECATED DVBv3 ioctls */
+
 	case FE_SET_FRONTEND:
 		err = dvbv3_set_delivery_system(fe);
 		if (err)
@@ -2450,11 +2439,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		err = dtv_get_frontend(fe, &getp, parg);
 		break;
 	}
-	case FE_SET_FRONTEND_TUNE_MODE:
-		fepriv->tune_mode_flags = (unsigned long) parg;
-		err = 0;
-		break;
-	}
+
+	default:
+		return -ENOTSUPP;
+	} /* switch */
 
 	return err;
 }
-- 
2.25.1

