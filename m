Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F8748EAC2
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 14:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiANNdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 08:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbiANNdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 08:33:52 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DEFC06161C
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:33:51 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id k30so15616443wrd.9
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxiQlhOo4zQQckBkWamyjXdCFErIGazuTgYjaePRe9I=;
        b=B2eGWpsgCWO7/yiavMx+ZQDWQodoUu7AjRQBiqQ3wqH/jcx/IoZO28tOeeUG++NbGW
         fj7DqGIixIr8CmYo3ZYsMr87ELLMGBI8bvFa5mPBfvYAI6gJ73xjTd9PToTpr8zh/Y3T
         w2DVf+/QrCcb6z73rrBm9JzwbaJKo31mU0kmSR631R87UGItEmUywTgep54g9vUQfMOF
         NAWcn0cemFHgtVgtLpApJsmfBuaQTSN/BIz/cxfRoHCTVKC3RugJRvIpjwpiaVs6nMzv
         LKppxLa0PvfYlLkc0dedznDIevM+sUr51iA4o6VPIR+gzUOtOPIb/kVr8uiVIEmmRqqY
         pgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LxiQlhOo4zQQckBkWamyjXdCFErIGazuTgYjaePRe9I=;
        b=1zDYz4Zx6g8K4FhMEmqtOnvgUrOPJ5dT12VDsQlpkYD1oRrabEkE6SxpH1ooHrihYx
         JzGqHguvZ4du0SSy5dm5aOnTT6YO2bb5FKY7f5RzPuytSr20wt8Ac96mxVigMKDNOWLM
         czI4D/xOPiTr/c6b4GhASDmEf1zzCzGE9IR1CcbG98LwcxXTDEtQCiJAh3VXvFHbScoz
         zWvtf7eatR6K9rntpFVxetQqY95r+uXKRuyfdNOk6a+9XibA/BXUuDHyq1dLh5QgXSwI
         yEyC8hGkYE0KfMPJwB85Al6yQJOqjiIipcmYT7xuJqA1vF5KR5hRT0jvjN77pG1+/nJe
         wJUA==
X-Gm-Message-State: AOAM530ODfqaHxWJBEe5ikd75MAjznoJnR3LyXH1JgP2VNCIsFAOd+dq
        lPZ0RrI4Sn9ebqvhjuPYH+UCxg==
X-Google-Smtp-Source: ABdhPJz8RDVMF53Zo/9Tz+O40fAR7OB7bkA69Yg/lMrX6hUwjtzY3zFGqgtej1U+mgQy2ymIyltcVQ==
X-Received: by 2002:a5d:4bc5:: with SMTP id l5mr8083954wrt.475.1642167229742;
        Fri, 14 Jan 2022 05:33:49 -0800 (PST)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id v13sm6125185wro.90.2022.01.14.05.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:33:49 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     David Rheinsberg <david.rheinsberg@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org
Cc:     Roderick Colenbrander <roderick.colenbrander@sony.com>,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] HID: uhid: Fix worker destroying device without any protection
Date:   Fri, 14 Jan 2022 14:33:30 +0100
Message-Id: <20220114133331.873057-1-jannh@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Notes:
    This crasher triggers an ASAN UAF warning:
=20=20=20=20
    int main(void) {
      int dev =3D open("/dev/uhid", O_RDWR);
      if (dev =3D=3D -1) err(1, "open");
=20=20=20=20
      while (1) {
        struct uhid_event ev_create =3D {
          .type =3D UHID_CREATE2,
          /* choose vendor+product IDs that will be rejected by hid_add_dev=
ice() */
          .u.create2 =3D { .rd_size =3D 1, .vendor =3D 0x07c0, .product =3D=
 0x1500 }
        };
        if (write(dev, &ev_create, sizeof(ev_create)) <=3D 0)
          err(1, "write CREATE");
=20=20=20=20
        while (1) {
          struct uhid_event ev_input =3D {
            .type =3D UHID_INPUT2,
            .u.input2 =3D {
              .data =3D { 0xff },
              .size =3D 1
            }
          };
          int res =3D write(dev, &ev_input, sizeof(ev_input));
          if (res =3D=3D -1 && errno =3D=3D EINVAL)
            break;
        }
      }
    }
=20=20=20=20
    It results in a splat like this:
=20=20=20=20
    BUG: KASAN: use-after-free in __lock_acquire+0x3eb9/0x5550
    Read of size 8 at addr ffff88800c2218f8 by task uhid_uaf/588
=20=20=20=20
    CPU: 1 PID: 588 Comm: uhid_uaf Not tainted 5.16.0-08301-gfb3b0673b7d5 #=
886
    [...]
    Call Trace:
     [...]
     lock_acquire+0x1b9/0x4e0
     _raw_spin_lock_irqsave+0x3e/0x60
     down_trylock+0x13/0x70
     hid_input_report+0x3d/0x500
     uhid_char_write+0x210/0xdb0
     vfs_write+0x1c7/0x920
     ksys_write+0x176/0x1d0
     do_syscall_64+0x43/0x90
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    [...]

 drivers/hid/uhid.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 8fe3efcb8327..fc06d8bb42e0 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -28,11 +28,22 @@
=20
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
=20
 	__u8 *rd_data;
 	uint rd_size;
=20
+	/* When this is NULL, userspace may use UHID_CREATE/UHID_CREATE2. */
 	struct hid_device *hid;
 	struct uhid_event input_buf;
=20
@@ -63,9 +74,18 @@ static void uhid_device_add_worker(struct work_struct *w=
ork)
 	if (ret) {
 		hid_err(uhid->hid, "Cannot register HID device: error %d\n", ret);
=20
-		hid_destroy_device(uhid->hid);
-		uhid->hid =3D NULL;
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
 		uhid->running =3D false;
+		wake_up_interruptible(&uhid->report_wait);
 	}
 }
=20
@@ -474,7 +494,7 @@ static int uhid_dev_create2(struct uhid_device *uhid,
 	void *rd_data;
 	int ret;
=20
-	if (uhid->running)
+	if (uhid->hid)
 		return -EALREADY;
=20
 	rd_size =3D ev->u.create2.rd_size;
@@ -556,7 +576,7 @@ static int uhid_dev_create(struct uhid_device *uhid,
=20
 static int uhid_dev_destroy(struct uhid_device *uhid)
 {
-	if (!uhid->running)
+	if (!uhid->hid)
 		return -EINVAL;
=20
 	uhid->running =3D false;
@@ -565,6 +585,7 @@ static int uhid_dev_destroy(struct uhid_device *uhid)
 	cancel_work_sync(&uhid->worker);
=20
 	hid_destroy_device(uhid->hid);
+	uhid->hid =3D NULL;
 	kfree(uhid->rd_data);
=20
 	return 0;

base-commit: fb3b0673b7d5b477ed104949450cd511337ba3c6
--=20
2.34.1.703.g22d0c6ccf7-goog

