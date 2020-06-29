Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0376020D713
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgF2T0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732677AbgF2TZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE63C25406;
        Mon, 29 Jun 2020 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445356;
        bh=dWZgweTsH9O0pwJFdmAD8JiQLLkCnmL0L87Gdd4f6ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbWYBw9D2GXIibDy89SnRLmEUuZlvxj40JV2N3Il3CYLj8aOH2X6xM4bzPQKPdDf6
         ay7bg/D9wI0GzDWBmo42xSDm59WdnXNLYGadpdFz5C/IpgMt7Gws9xqMLAGfat0FDe
         w0DUalXimooXMlWBhYoHXvpLf58r7Z3/urABPIw4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaedon Shin <jaedon.shin@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 114/191] media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
Date:   Mon, 29 Jun 2020 11:38:50 -0400
Message-Id: <20200629154007.2495120-115-sashal@kernel.org>
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

commit a2282fd1fe2ebcda480426dbfaaa7c4e87e27399 upstream

Adds unlocked ioctl function directly in dvb_frontend.c instead of using
dvb_generic_ioctl().

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6f9ee78a18703..dacc467e24af2 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1926,7 +1926,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	return r;
 }
 
-static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
+static int dvb_frontend_do_ioctl(struct file *file, unsigned int cmd,
+				 void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
@@ -1969,6 +1970,17 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 	return err;
 }
 
+static long dvb_frontend_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+
+	if (!dvbdev)
+		return -ENODEV;
+
+	return dvb_usercopy(file, cmd, arg, dvb_frontend_do_ioctl);
+}
+
 static int dtv_set_frontend(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -2638,7 +2650,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 static const struct file_operations dvb_frontend_fops = {
 	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= dvb_generic_ioctl,
+	.unlocked_ioctl	= dvb_frontend_ioctl,
 	.poll		= dvb_frontend_poll,
 	.open		= dvb_frontend_open,
 	.release	= dvb_frontend_release,
@@ -2706,7 +2718,6 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 		.name = fe->ops.info.name,
 #endif
-		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
 	dev_dbg(dvb->device, "%s:\n", __func__);
-- 
2.25.1

