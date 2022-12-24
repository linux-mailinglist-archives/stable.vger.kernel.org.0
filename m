Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1817655782
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiLXBgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbiLXBf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:35:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9A54DE50;
        Fri, 23 Dec 2022 17:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28657B821B6;
        Sat, 24 Dec 2022 01:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125E1C433D2;
        Sat, 24 Dec 2022 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845510;
        bh=kZIdz+kwK19u4X7Jpo86YBXa80e8UIlL96mj+VX3Z3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szZx1qVQCAsHzJ7XdQLU92FMTx9rdFRfu/PMz1qUXviebR1BlHt3vHF7itd2i0/1t
         V1YjilnqSqHMo9z7BX9Mtnlq1bdCENv5mWVaNkQBSlV+6FwqR1uoDyti6KTWN+rvL8
         uJ18Dly4ilIY6ZnxZFqByoR9UVOnUgKij8UPYY/xuKwwGXsh8peQZTHiMH3n41v10F
         iNG5X5q5H4kpLzbtejYCdtTUVItOb2V6UaTa2yWxK2qundSf/OV64cdASjnGnluvm5
         uuxH1u/bK31bhWgjzc/DdQCSUNZHK24MX7k0WrZ0p96HcW6CCSctmBelyvG7GKuylm
         AjQ7EUcHIAENA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Billauer <eli.billauer@gmail.com>,
        Hyunwoo Kim <imv4bel@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 08/14] char: xillybus: Prevent use-after-free due to race condition
Date:   Fri, 23 Dec 2022 20:31:21 -0500
Message-Id: <20221224013127.393187-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013127.393187-1-sashal@kernel.org>
References: <20221224013127.393187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Billauer <eli.billauer@gmail.com>

[ Upstream commit 282a4b71816b6076029017a7bab3a9dcee12a920 ]

The driver for XillyUSB devices maintains a kref reference count on each
xillyusb_dev structure, which represents a physical device. This reference
count reaches zero when the device has been disconnected and there are no
open file descriptors that are related to the device. When this occurs,
kref_put() calls cleanup_dev(), which clears up the device's data,
including the structure itself.

However, when xillyusb_open() is called, this reference count becomes
tricky: This function needs to obtain the xillyusb_dev structure that
relates to the inode's major and minor (as there can be several such).
xillybus_find_inode() (which is defined in xillybus_class.c) is called
for this purpose. xillybus_find_inode() holds a mutex that is global in
xillybus_class.c to protect the list of devices, and releases this
mutex before returning. As a result, nothing protects the xillyusb_dev's
reference counter from being decremented to zero before xillyusb_open()
increments it on its own behalf. Hence the structure can be freed
due to a rare race condition.

To solve this, a mutex is added. It is locked by xillyusb_open() before
the call to xillybus_find_inode() and is released only after the kref
counter has been incremented on behalf of the newly opened inode. This
protects the kref reference counters of all xillyusb_dev structs from
being decremented by xillyusb_disconnect() during this time segment, as
the call to kref_put() in this function is done with the same lock held.

There is no need to hold the lock on other calls to kref_put(), because
if xillybus_find_inode() finds a struct, xillyusb_disconnect() has not
made the call to remove it, and hence not made its call to kref_put(),
which takes place afterwards. Hence preventing xillyusb_disconnect's
call to kref_put() is enough to ensure that the reference doesn't reach
zero before it's incremented by xillyusb_open().

It would have been more natural to increment the reference count in
xillybus_find_inode() of course, however this function is also called by
Xillybus' driver for PCIe / OF, which registers a completely different
structure. Therefore, xillybus_find_inode() treats these structures as
void pointers, and accordingly can't make any changes.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20221030094209.65916-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/xillybus/xillyusb.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index 39bcbfd908b4..5a5afa14ca8c 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -184,6 +184,14 @@ struct xillyusb_dev {
 	struct mutex process_in_mutex; /* synchronize wakeup_all() */
 };
 
+/*
+ * kref_mutex is used in xillyusb_open() to prevent the xillyusb_dev
+ * struct from being freed during the gap between being found by
+ * xillybus_find_inode() and having its reference count incremented.
+ */
+
+static DEFINE_MUTEX(kref_mutex);
+
 /* FPGA to host opcodes */
 enum {
 	OPCODE_DATA = 0,
@@ -1237,9 +1245,16 @@ static int xillyusb_open(struct inode *inode, struct file *filp)
 	int rc;
 	int index;
 
+	mutex_lock(&kref_mutex);
+
 	rc = xillybus_find_inode(inode, (void **)&xdev, &index);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&kref_mutex);
 		return rc;
+	}
+
+	kref_get(&xdev->kref);
+	mutex_unlock(&kref_mutex);
 
 	chan = &xdev->channels[index];
 	filp->private_data = chan;
@@ -1275,8 +1290,6 @@ static int xillyusb_open(struct inode *inode, struct file *filp)
 	    ((filp->f_mode & FMODE_WRITE) && chan->open_for_write))
 		goto unmutex_fail;
 
-	kref_get(&xdev->kref);
-
 	if (filp->f_mode & FMODE_READ)
 		chan->open_for_read = 1;
 
@@ -1413,6 +1426,7 @@ static int xillyusb_open(struct inode *inode, struct file *filp)
 	return rc;
 
 unmutex_fail:
+	kref_put(&xdev->kref, cleanup_dev);
 	mutex_unlock(&chan->lock);
 	return rc;
 }
@@ -2227,7 +2241,9 @@ static void xillyusb_disconnect(struct usb_interface *interface)
 
 	xdev->dev = NULL;
 
+	mutex_lock(&kref_mutex);
 	kref_put(&xdev->kref, cleanup_dev);
+	mutex_unlock(&kref_mutex);
 }
 
 static struct usb_driver xillyusb_driver = {
-- 
2.35.1

