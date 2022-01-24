Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D702498D72
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349951AbiAXTcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351864AbiAXT25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:28:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4DCC08E823;
        Mon, 24 Jan 2022 11:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE923612FC;
        Mon, 24 Jan 2022 19:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0C7C36AE9;
        Mon, 24 Jan 2022 19:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051586;
        bh=Q+MxbbWQVajUN34Ta0HIEmYAyo52hSUK/g2MXOMUHZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXpH7K3X4uK64A1s3YkMSG0lMdXyJ0J7DUCS1z3rrZBOCCFzTPCZGj14f3SR41DTM
         A1kdrP0l+cNNd0xz7N3VpjAqfMs9Amvbx6fKajWZbmTS6Z8p4LQqI6rCCk5p0ksLQA
         oGrEGlHTwvdNSMCGiqFzN+asD1N+Qig5G0R905vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 022/239] HID: uhid: Fix worker destroying device without any protection
Date:   Mon, 24 Jan 2022 19:41:00 +0100
Message-Id: <20220124183943.826952634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -31,11 +31,22 @@
 
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
 
@@ -66,9 +77,18 @@ static void uhid_device_add_worker(struc
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
 
@@ -477,7 +497,7 @@ static int uhid_dev_create2(struct uhid_
 	void *rd_data;
 	int ret;
 
-	if (uhid->running)
+	if (uhid->hid)
 		return -EALREADY;
 
 	rd_size = ev->u.create2.rd_size;
@@ -559,7 +579,7 @@ static int uhid_dev_create(struct uhid_d
 
 static int uhid_dev_destroy(struct uhid_device *uhid)
 {
-	if (!uhid->running)
+	if (!uhid->hid)
 		return -EINVAL;
 
 	uhid->running = false;
@@ -568,6 +588,7 @@ static int uhid_dev_destroy(struct uhid_
 	cancel_work_sync(&uhid->worker);
 
 	hid_destroy_device(uhid->hid);
+	uhid->hid = NULL;
 	kfree(uhid->rd_data);
 
 	return 0;


