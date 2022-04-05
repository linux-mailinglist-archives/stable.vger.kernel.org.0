Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC64F3578
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbiDEJE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243378AbiDEIuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC1C12609;
        Tue,  5 Apr 2022 01:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0D661551;
        Tue,  5 Apr 2022 08:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB060C385A7;
        Tue,  5 Apr 2022 08:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147895;
        bh=uQMB6DRnrFezFKqAd+bYNqR+eGeLNyW5WRYA6+53Eu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGnjLu2QtPrLvi9PFSY2To4Fa63Xvc5p/CnbEo2PtxF2MxUPkUW/7BwRcJyc0cJJg
         VSaFP1QwVhA+uga9msAc8QabRwYGS/pqobIHwegnU8jE5YcgTtUwzvt2W89XlvGqh/
         ljmh88O/L32SgvswtzD6sFoR7mpYFJj1NL11oXXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.16 0153/1017] rfkill: make new event layout opt-in
Date:   Tue,  5 Apr 2022 09:17:46 +0200
Message-Id: <20220405070358.751749539@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 54f586a9153201c6cff55e1f561990c78bd99aa7 upstream.

Again new complaints surfaced that we had broken the ABI here,
although previously all the userspace tools had agreed that it
was their mistake and fixed it. Yet now there are cases (e.g.
RHEL) that want to run old userspace with newer kernels, and
thus are broken.

Since this is a bit of a whack-a-mole thing, change the whole
extensibility scheme of rfkill to no longer just rely on the
message lengths, but instead require userspace to opt in via a
new ioctl to a given maximum event size that it is willing to
understand.

By default, set that to RFKILL_EVENT_SIZE_V1 (8), so that the
behaviour for userspace not calling the ioctl will look as if
it's just running on an older kernel.

Fixes: 14486c82612a ("rfkill: add a reason to the HW rfkill state")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220316212749.16491491b270.Ifcb1950998330a596f29a2a162e00b7546a1d6d0@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rfkill.h |   14 +++++++++++-
 net/rfkill/core.c           |   48 +++++++++++++++++++++++++++++++-------------
 2 files changed, 46 insertions(+), 16 deletions(-)

--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -159,8 +159,16 @@ struct rfkill_event_ext {
  * old behaviour for all userspace, unless it explicitly opts in to the
  * rules outlined here by using the new &struct rfkill_event_ext.
  *
- * Userspace using &struct rfkill_event_ext must adhere to the following
- * rules
+ * Additionally, some other userspace (bluez, g-s-d) was reading with a
+ * large size but as streaming reads rather than message-based, or with
+ * too strict checks for the returned size. So eventually, we completely
+ * reverted this, and extended messages need to be opted in to by using
+ * an ioctl:
+ *
+ *  ioctl(fd, RFKILL_IOCTL_MAX_SIZE, sizeof(struct rfkill_event_ext));
+ *
+ * Userspace using &struct rfkill_event_ext and the ioctl must adhere to
+ * the following rules:
  *
  * 1. accept short writes, optionally using them to detect that it's
  *    running on an older kernel;
@@ -175,6 +183,8 @@ struct rfkill_event_ext {
 #define RFKILL_IOC_MAGIC	'R'
 #define RFKILL_IOC_NOINPUT	1
 #define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
+#define RFKILL_IOC_MAX_SIZE	2
+#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_EXT_SIZE, __u32)
 
 /* and that's all userspace gets */
 
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -78,6 +78,7 @@ struct rfkill_data {
 	struct mutex		mtx;
 	wait_queue_head_t	read_wait;
 	bool			input_handler;
+	u8			max_size;
 };
 
 
@@ -1141,6 +1142,8 @@ static int rfkill_fop_open(struct inode
 	if (!data)
 		return -ENOMEM;
 
+	data->max_size = RFKILL_EVENT_SIZE_V1;
+
 	INIT_LIST_HEAD(&data->events);
 	mutex_init(&data->mtx);
 	init_waitqueue_head(&data->read_wait);
@@ -1223,6 +1226,7 @@ static ssize_t rfkill_fop_read(struct fi
 				list);
 
 	sz = min_t(unsigned long, sizeof(ev->ev), count);
+	sz = min_t(unsigned long, sz, data->max_size);
 	ret = sz;
 	if (copy_to_user(buf, &ev->ev, sz))
 		ret = -EFAULT;
@@ -1237,6 +1241,7 @@ static ssize_t rfkill_fop_read(struct fi
 static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *pos)
 {
+	struct rfkill_data *data = file->private_data;
 	struct rfkill *rfkill;
 	struct rfkill_event_ext ev;
 	int ret;
@@ -1251,6 +1256,7 @@ static ssize_t rfkill_fop_write(struct f
 	 * our API version even in a write() call, if it cares.
 	 */
 	count = min(count, sizeof(ev));
+	count = min_t(size_t, count, data->max_size);
 	if (copy_from_user(&ev, buf, count))
 		return -EFAULT;
 
@@ -1310,31 +1316,47 @@ static int rfkill_fop_release(struct ino
 	return 0;
 }
 
-#ifdef CONFIG_RFKILL_INPUT
 static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
 	struct rfkill_data *data = file->private_data;
+	int ret = -ENOSYS;
+	u32 size;
 
 	if (_IOC_TYPE(cmd) != RFKILL_IOC_MAGIC)
 		return -ENOSYS;
 
-	if (_IOC_NR(cmd) != RFKILL_IOC_NOINPUT)
-		return -ENOSYS;
-
 	mutex_lock(&data->mtx);
-
-	if (!data->input_handler) {
-		if (atomic_inc_return(&rfkill_input_disabled) == 1)
-			printk(KERN_DEBUG "rfkill: input handler disabled\n");
-		data->input_handler = true;
+	switch (_IOC_NR(cmd)) {
+#ifdef CONFIG_RFKILL_INPUT
+	case RFKILL_IOC_NOINPUT:
+		if (!data->input_handler) {
+			if (atomic_inc_return(&rfkill_input_disabled) == 1)
+				printk(KERN_DEBUG "rfkill: input handler disabled\n");
+			data->input_handler = true;
+		}
+		ret = 0;
+		break;
+#endif
+	case RFKILL_IOC_MAX_SIZE:
+		if (get_user(size, (__u32 __user *)arg)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (size < RFKILL_EVENT_SIZE_V1 || size > U8_MAX) {
+			ret = -EINVAL;
+			break;
+		}
+		data->max_size = size;
+		ret = 0;
+		break;
+	default:
+		break;
 	}
-
 	mutex_unlock(&data->mtx);
 
-	return 0;
+	return ret;
 }
-#endif
 
 static const struct file_operations rfkill_fops = {
 	.owner		= THIS_MODULE,
@@ -1343,10 +1365,8 @@ static const struct file_operations rfki
 	.write		= rfkill_fop_write,
 	.poll		= rfkill_fop_poll,
 	.release	= rfkill_fop_release,
-#ifdef CONFIG_RFKILL_INPUT
 	.unlocked_ioctl	= rfkill_fop_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
-#endif
 	.llseek		= no_llseek,
 };
 


