Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8897A20D712
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgF2T0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732673AbgF2TZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE132540B;
        Mon, 29 Jun 2020 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445358;
        bh=8syAJ3fthn+zD5CKMzlub3CBePknRBgAdwrW7T343+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEgJa2la82dmSj03dG2jZeZRlSm1XV1KBIgkSNnv7+/32iBz82kKrb4dYVSKJAEVv
         GtnS6yzCv35PbI2TtRrBMIhEZkkgrQwCjLh9rpJ2svvxNED/6StHd+W8SYsy1mgdj7
         IVisC0NpWSD25nToViu8nd8VupZkd3GPryFBzU8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaedon Shin <jaedon.shin@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 116/191] media: dvb_frontend: Add commands implementation for compat ioct
Date:   Mon, 29 Jun 2020 11:38:52 -0400
Message-Id: <20200629154007.2495120-117-sashal@kernel.org>
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

From: Jaedon Shin <jaedon.shin@gmail.com>

commit 18192a77f0810933ab71a46c1b260d230d7352ee upstream

The dtv_properties structure and the dtv_property structure are
different sizes in 32-bit and 64-bit system. This patch provides
FE_SET_PROPERTY and FE_GET_PROPERTY ioctl commands implementation for
32-bit user space applications.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 131 ++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c0a25cd6ccb8b..34f55a2ba071d 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1983,9 +1983,140 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
 }
 
 #ifdef CONFIG_COMPAT
+struct compat_dtv_property {
+	__u32 cmd;
+	__u32 reserved[3];
+	union {
+		__u32 data;
+		struct dtv_fe_stats st;
+		struct {
+			__u8 data[32];
+			__u32 len;
+			__u32 reserved1[3];
+			compat_uptr_t reserved2;
+		} buffer;
+	} u;
+	int result;
+} __attribute__ ((packed));
+
+struct compat_dtv_properties {
+	__u32 num;
+	compat_uptr_t props;
+};
+
+#define COMPAT_FE_SET_PROPERTY	   _IOW('o', 82, struct compat_dtv_properties)
+#define COMPAT_FE_GET_PROPERTY	   _IOR('o', 83, struct compat_dtv_properties)
+
+static int dvb_frontend_handle_compat_ioctl(struct file *file, unsigned int cmd,
+					    unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int i, err = 0;
+
+	if (cmd == COMPAT_FE_SET_PROPERTY) {
+		struct compat_dtv_properties prop, *tvps = NULL;
+		struct compat_dtv_property *tvp = NULL;
+
+		if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
+			return -EFAULT;
+
+		tvps = &prop;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
+		if (IS_ERR(tvp))
+			return PTR_ERR(tvp);
+
+		for (i = 0; i < tvps->num; i++) {
+			err = dtv_property_process_set(fe, file,
+							(tvp + i)->cmd,
+							(tvp + i)->u.data);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+		kfree(tvp);
+	} else if (cmd == COMPAT_FE_GET_PROPERTY) {
+		struct compat_dtv_properties prop, *tvps = NULL;
+		struct compat_dtv_property *tvp = NULL;
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
+		if (copy_from_user(&prop, compat_ptr(arg), sizeof(prop)))
+			return -EFAULT;
+
+		tvps = &prop;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
+			return -EINVAL;
+
+		tvp = memdup_user(compat_ptr(tvps->props), tvps->num * sizeof(*tvp));
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
+			err = dtv_property_process_get(
+			    fe, &getp, (struct dtv_property *)tvp + i, file);
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
+		}
+
+		if (copy_to_user((void __user *)compat_ptr(tvps->props), tvp,
+				 tvps->num * sizeof(struct compat_dtv_property))) {
+			kfree(tvp);
+			return -EFAULT;
+		}
+		kfree(tvp);
+	}
+
+	return err;
+}
+
 static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
 				      unsigned long arg)
 {
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int err;
+
+	if (cmd == COMPAT_FE_SET_PROPERTY || cmd == COMPAT_FE_GET_PROPERTY) {
+		if (down_interruptible(&fepriv->sem))
+			return -ERESTARTSYS;
+
+		err = dvb_frontend_handle_compat_ioctl(file, cmd, arg);
+
+		up(&fepriv->sem);
+		return err;
+	}
+
 	return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
 }
 #endif
-- 
2.25.1

