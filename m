Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4651C499076
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344551AbiAXUAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350854AbiAXTwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:52:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD33C041894;
        Mon, 24 Jan 2022 11:24:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 149D6B81215;
        Mon, 24 Jan 2022 19:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E01C340E5;
        Mon, 24 Jan 2022 19:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052284;
        bh=vSGR6VHbNUyq1gjucRiTGoZ958d6JifO3hYpyr6RMI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw13KTV1WO1xstTne2VLNndh+6o355KDHN0unho1se0EbP0FvsRxUOq6NqHsT2vLE
         7PFGKvlwGfh46lNNmVIZegNzT6XNONbRtSiro6iRyCsm8ZMawtFMLkdg3DmgPdeUDn
         SJWBnVMoGUGZ8LMqFDpCpw4l6qE+pTbFG+tv7CxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 001/320] HID: uhid: Fix worker destroying device without any protection
Date:   Mon, 24 Jan 2022 19:39:45 +0100
Message-Id: <20220124183953.802311933@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 4ea5763fb79ed89b3bdad455ebf3f33416a81624 upstream.

uhid has to run hid_add_device() from workqueue context while allowing
parallel use of the userspace API (which is protected with ->devlock).
But hid_add_device() can fail. Currently, that is handled by immediately
destroying the associated HID device, without using ->devlock - but if
there are concurrent requests from userspace, that's wrong and leads to
NULL dereferences and/or memory corruption (via use-after-free).

Fix it by leaving the HID device as-is in the worker. We can clean it up
later, either in the UHID_DESTROY command handler or in the ->release()
handler.

Cc: stable@vger.kernel.org
Fixes: 67f8ecc550b5 ("HID: uhid: fix timeout when probe races with IO")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/uhid.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -28,11 +28,22 @@
 
 struct uhid_device {
 	struct mutex devlock;
+
+	/* This flag tracks whether the HID device is usable for commands from
+	 * userspace. The flag is already set before hid_add_device(), which
+	 * runs in workqueue context, to allow hid_add_device() to communicate
+	 * with userspace.
+	 * However, if hid_add_device() fails, the flag is cleared without
+	 * holding devlock.
+	 * We guarantee that if @running changes from true to false while you're
+	 * holding @devlock, it's still fine to access @hid.
+	 */
 	bool running;
 
 	__u8 *rd_data;
 	uint rd_size;
 
+	/* When this is NULL, userspace may use UHID_CREATE/UHID_CREATE2. */
 	struct hid_device *hid;
 	struct uhid_event input_buf;
 
@@ -63,9 +74,18 @@ static void uhid_device_add_worker(struc
 	if (ret) {
 		hid_err(uhid->hid, "Cannot register HID device: error %d\n", ret);
 
-		hid_destroy_device(uhid->hid);
-		uhid->hid = NULL;
+		/* We used to call hid_destroy_device() here, but that's really
+		 * messy to get right because we have to coordinate with
+		 * concurrent writes from userspace that might be in the middle
+		 * of using uhid->hid.
+		 * Just leave uhid->hid as-is for now, and clean it up when
+		 * userspace tries to close or reinitialize the uhid instance.
+		 *
+		 * However, we do have to clear the ->running flag and do a
+		 * wakeup to make sure userspace knows that the device is gone.
+		 */
 		uhid->running = false;
+		wake_up_interruptible(&uhid->report_wait);
 	}
 }
 
@@ -474,7 +494,7 @@ static int uhid_dev_create2(struct uhid_
 	void *rd_data;
 	int ret;
 
-	if (uhid->running)
+	if (uhid->hid)
 		return -EALREADY;
 
 	rd_size = ev->u.create2.rd_size;
@@ -556,7 +576,7 @@ static int uhid_dev_create(struct uhid_d
 
 static int uhid_dev_destroy(struct uhid_device *uhid)
 {
-	if (!uhid->running)
+	if (!uhid->hid)
 		return -EINVAL;
 
 	uhid->running = false;
@@ -565,6 +585,7 @@ static int uhid_dev_destroy(struct uhid_
 	cancel_work_sync(&uhid->worker);
 
 	hid_destroy_device(uhid->hid);
+	uhid->hid = NULL;
 	kfree(uhid->rd_data);
 
 	return 0;


