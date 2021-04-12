Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C5735BF32
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbhDLJDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239827AbhDLJBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7326B6128E;
        Mon, 12 Apr 2021 08:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217969;
        bh=gTJpRSJ3Rwp4gUXVNOn3gG253Yr7bpwJ/0Q5X6UO5xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5f5lRULLzxRoxnUl7HUMNqz8HDJQcbIjOrIyuqyVZbujMYrhZ9p5kUmIG+/gvIi1
         VkY7nUb/fa1h8v71MRGKn+Zw0i0qj4mCOesOiMZb/ZuPOW4W1gT0dsZf4wBU67XF3c
         VfUxXGZDAl8v2Py09cXqu9tJxxrduod0L7n8L9Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.11 024/210] rfkill: revert back to old userspace API by default
Date:   Mon, 12 Apr 2021 10:38:49 +0200
Message-Id: <20210412084016.812605974@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 71826654ce40112f0651b6f4e94c422354f4adb6 upstream.

Recompiling with the new extended version of struct rfkill_event
broke systemd in *two* ways:
 - It used "sizeof(struct rfkill_event)" to read the event, but
   then complained if it actually got something != 8, this broke
   it on new kernels (that include the updated API);
 - It used sizeof(struct rfkill_event) to write a command, but
   didn't implement the intended expansion protocol where the
   kernel returns only how many bytes it accepted, and errored
   out due to the unexpected smaller size on kernels that didn't
   include the updated API.

Even though systemd has now been fixed, that fix may not be always
deployed, and other applications could potentially have similar
issues.

As such, in the interest of avoiding regressions, revert the
default API "struct rfkill_event" back to the original size.

Instead, add a new "struct rfkill_event_ext" that extends it by
the new field, and even more clearly document that applications
should be prepared for extensions in two ways:
 * write might only accept fewer bytes on older kernels, and
   will return how many to let userspace know which data may
   have been ignored;
 * read might return anything between 8 (the original size) and
   whatever size the application sized its buffer at, indicating
   how much event data was supported by the kernel.

Perhaps that will help avoid such issues in the future and we
won't have to come up with another version of the struct if we
ever need to extend it again.

Applications that want to take advantage of the new field will
have to be modified to use struct rfkill_event_ext instead now,
which comes with the danger of them having already been updated
to use it from 'struct rfkill_event', but I found no evidence
of that, and it's still relatively new.

Cc: stable@vger.kernel.org # 5.11
Reported-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM/Clang v12.0.0-r4 (x86-64)
Link: https://lore.kernel.org/r/20210319232510.f1a139cfdd9c.Ic5c7c9d1d28972059e132ea653a21a427c326678@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/rfkill.h |   82 +++++++++++++++++++++++++++++++++++++-------
 net/rfkill/core.c           |    7 ++-
 2 files changed, 73 insertions(+), 16 deletions(-)

--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -86,34 +86,90 @@ enum rfkill_hard_block_reasons {
  * @op: operation code
  * @hard: hard state (0/1)
  * @soft: soft state (0/1)
+ *
+ * Structure used for userspace communication on /dev/rfkill,
+ * used for events from the kernel and control to the kernel.
+ */
+struct rfkill_event {
+	__u32 idx;
+	__u8  type;
+	__u8  op;
+	__u8  soft;
+	__u8  hard;
+} __attribute__((packed));
+
+/**
+ * struct rfkill_event_ext - events for userspace on /dev/rfkill
+ * @idx: index of dev rfkill
+ * @type: type of the rfkill struct
+ * @op: operation code
+ * @hard: hard state (0/1)
+ * @soft: soft state (0/1)
  * @hard_block_reasons: valid if hard is set. One or several reasons from
  *	&enum rfkill_hard_block_reasons.
  *
  * Structure used for userspace communication on /dev/rfkill,
  * used for events from the kernel and control to the kernel.
+ *
+ * See the extensibility docs below.
  */
-struct rfkill_event {
+struct rfkill_event_ext {
 	__u32 idx;
 	__u8  type;
 	__u8  op;
 	__u8  soft;
 	__u8  hard;
+
+	/*
+	 * older kernels will accept/send only up to this point,
+	 * and if extended further up to any chunk marked below
+	 */
+
 	__u8  hard_block_reasons;
 } __attribute__((packed));
 
-/*
- * We are planning to be backward and forward compatible with changes
- * to the event struct, by adding new, optional, members at the end.
- * When reading an event (whether the kernel from userspace or vice
- * versa) we need to accept anything that's at least as large as the
- * version 1 event size, but might be able to accept other sizes in
- * the future.
- *
- * One exception is the kernel -- we already have two event sizes in
- * that we've made the 'hard' member optional since our only option
- * is to ignore it anyway.
+/**
+ * DOC: Extensibility
+ *
+ * Originally, we had planned to allow backward and forward compatible
+ * changes by just adding fields at the end of the structure that are
+ * then not reported on older kernels on read(), and not written to by
+ * older kernels on write(), with the kernel reporting the size it did
+ * accept as the result.
+ *
+ * This would have allowed userspace to detect on read() and write()
+ * which kernel structure version it was dealing with, and if was just
+ * recompiled it would have gotten the new fields, but obviously not
+ * accessed them, but things should've continued to work.
+ *
+ * Unfortunately, while actually exercising this mechanism to add the
+ * hard block reasons field, we found that userspace (notably systemd)
+ * did all kinds of fun things not in line with this scheme:
+ *
+ * 1. treat the (expected) short writes as an error;
+ * 2. ask to read sizeof(struct rfkill_event) but then compare the
+ *    actual return value to RFKILL_EVENT_SIZE_V1 and treat any
+ *    mismatch as an error.
+ *
+ * As a consequence, just recompiling with a new struct version caused
+ * things to no longer work correctly on old and new kernels.
+ *
+ * Hence, we've rolled back &struct rfkill_event to the original version
+ * and added &struct rfkill_event_ext. This effectively reverts to the
+ * old behaviour for all userspace, unless it explicitly opts in to the
+ * rules outlined here by using the new &struct rfkill_event_ext.
+ *
+ * Userspace using &struct rfkill_event_ext must adhere to the following
+ * rules
+ *
+ * 1. accept short writes, optionally using them to detect that it's
+ *    running on an older kernel;
+ * 2. accept short reads, knowing that this means it's running on an
+ *    older kernel;
+ * 3. treat reads that are as long as requested as acceptable, not
+ *    checking against RFKILL_EVENT_SIZE_V1 or such.
  */
-#define RFKILL_EVENT_SIZE_V1	8
+#define RFKILL_EVENT_SIZE_V1	sizeof(struct rfkill_event)
 
 /* ioctl for turning off rfkill-input (if present) */
 #define RFKILL_IOC_MAGIC	'R'
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -69,7 +69,7 @@ struct rfkill {
 
 struct rfkill_int_event {
 	struct list_head	list;
-	struct rfkill_event	ev;
+	struct rfkill_event_ext	ev;
 };
 
 struct rfkill_data {
@@ -253,7 +253,8 @@ static void rfkill_global_led_trigger_un
 }
 #endif /* CONFIG_RFKILL_LEDS */
 
-static void rfkill_fill_event(struct rfkill_event *ev, struct rfkill *rfkill,
+static void rfkill_fill_event(struct rfkill_event_ext *ev,
+			      struct rfkill *rfkill,
 			      enum rfkill_operation op)
 {
 	unsigned long flags;
@@ -1237,7 +1238,7 @@ static ssize_t rfkill_fop_write(struct f
 				size_t count, loff_t *pos)
 {
 	struct rfkill *rfkill;
-	struct rfkill_event ev;
+	struct rfkill_event_ext ev;
 	int ret;
 
 	/* we don't need the 'hard' variable but accept it */


