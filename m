Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788E520D724
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbgF2T1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732241AbgF2TZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDEA2540D;
        Mon, 29 Jun 2020 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445357;
        bh=3G6RcH4HFEvNVyVbppRrb++MZ9amUYbAvaaqBJgKZp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcMR9is4TB708HxPYCmsgOq+7D2N3n2/vcVInTfIuBjPUBi7gExCrHms7wZNBpDiR
         6sXLdEnzaRcSov+mvGoRn436UnN5JgjTIm1DJlS7JkYca0R+yf7SC65/ZQLMToYdJj
         Xkw6uaDJqI3pO/HudMxMrGdz26Ma25rmVblwl8AE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaedon Shin <jaedon.shin@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 115/191] media: dvb_frontend: Add compat_ioctl callback
Date:   Mon, 29 Jun 2020 11:38:51 -0400
Message-Id: <20200629154007.2495120-116-sashal@kernel.org>
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

commit c2dfd2276cec63a0c6f6ce18ed83800d96fde542 upstream

Adds compat_ioctl for 32-bit user space applications on a 64-bit system.

[m.chehab@osg.samsung.com: add missing include compat.h]
Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 12 ++++++++++++
 fs/compat_ioctl.c                     | 17 -----------------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index dacc467e24af2..c0a25cd6ccb8b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -41,6 +41,7 @@
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
 #include <linux/ktime.h>
+#include <linux/compat.h>
 #include <asm/processor.h>
 
 #include "dvb_frontend.h"
@@ -1981,6 +1982,14 @@ static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
 	return dvb_usercopy(file, cmd, arg, dvb_frontend_do_ioctl);
 }
 
+#ifdef CONFIG_COMPAT
+static long dvb_frontend_compat_ioctl(struct file *file, unsigned int cmd,
+				      unsigned long arg)
+{
+	return dvb_frontend_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2651,6 +2660,9 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= dvb_frontend_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= dvb_frontend_compat_ioctl,
+#endif
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 02ac9067a3542..9fa3285425fef 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1340,23 +1340,6 @@ COMPATIBLE_IOCTL(DMX_GET_PES_PIDS)
 COMPATIBLE_IOCTL(DMX_GET_CAPS)
 COMPATIBLE_IOCTL(DMX_SET_SOURCE)
 COMPATIBLE_IOCTL(DMX_GET_STC)
-COMPATIBLE_IOCTL(FE_GET_INFO)
-COMPATIBLE_IOCTL(FE_DISEQC_RESET_OVERLOAD)
-COMPATIBLE_IOCTL(FE_DISEQC_SEND_MASTER_CMD)
-COMPATIBLE_IOCTL(FE_DISEQC_RECV_SLAVE_REPLY)
-COMPATIBLE_IOCTL(FE_DISEQC_SEND_BURST)
-COMPATIBLE_IOCTL(FE_SET_TONE)
-COMPATIBLE_IOCTL(FE_SET_VOLTAGE)
-COMPATIBLE_IOCTL(FE_ENABLE_HIGH_LNB_VOLTAGE)
-COMPATIBLE_IOCTL(FE_READ_STATUS)
-COMPATIBLE_IOCTL(FE_READ_BER)
-COMPATIBLE_IOCTL(FE_READ_SIGNAL_STRENGTH)
-COMPATIBLE_IOCTL(FE_READ_SNR)
-COMPATIBLE_IOCTL(FE_READ_UNCORRECTED_BLOCKS)
-COMPATIBLE_IOCTL(FE_SET_FRONTEND)
-COMPATIBLE_IOCTL(FE_GET_FRONTEND)
-COMPATIBLE_IOCTL(FE_GET_EVENT)
-COMPATIBLE_IOCTL(FE_DISHNETWORK_SEND_LEGACY_CMD)
 COMPATIBLE_IOCTL(VIDEO_STOP)
 COMPATIBLE_IOCTL(VIDEO_PLAY)
 COMPATIBLE_IOCTL(VIDEO_FREEZE)
-- 
2.25.1

