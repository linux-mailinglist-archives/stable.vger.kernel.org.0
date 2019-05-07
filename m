Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7351B15B52
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfEGFix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbfEGFiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:38:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42F3020B7C;
        Tue,  7 May 2019 05:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207530;
        bh=Zd42pB4ZxN3SQEVJDbJKCBiRcURiET1pP95rU3dCpRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVTU/AmQ3ZSp/SbeQ3T47W+X+kg3gQiVJcJcgPGGvvq2LycOV0M4yAUbGIwgMaa8C
         KJS8P5SZDkbPERublo5BbAH+aCMJvYS2zdfQoDvVfNtyH+c7864DC1Vs1rRVnWqGyy
         cIr5GA3kxWUlu6QW1PWYE57IREL39SAbdeX9105I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/95] s390/3270: fix lockdep false positive on view->lock
Date:   Tue,  7 May 2019 01:37:02 -0400
Message-Id: <20190507053826.31622-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[ Upstream commit 5712f3301a12c0c3de9cc423484496b0464f2faf ]

The spinlock in the raw3270_view structure is used by con3270, tty3270
and fs3270 in different ways. For con3270 the lock can be acquired in
irq context, for tty3270 and fs3270 the highest context is bh.

Lockdep sees the view->lock as a single class and if the 3270 driver
is used for the console the following message is generated:

WARNING: inconsistent lock state
5.1.0-rc3-05157-g5c168033979d #12 Not tainted
--------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
swapper/0/1 [HC0[0]:SC1[1]:HE1:SE0] takes:
(____ptrval____) (&(&view->lock)->rlock){?.-.}, at: tty3270_update+0x7c/0x330

Introduce a lockdep subclass for the view lock to distinguish bh from
irq locks.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/con3270.c | 2 +-
 drivers/s390/char/fs3270.c  | 3 ++-
 drivers/s390/char/raw3270.c | 3 ++-
 drivers/s390/char/raw3270.h | 4 +++-
 drivers/s390/char/tty3270.c | 3 ++-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index be3e3c1206c2..1868ff803f43 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -629,7 +629,7 @@ con3270_init(void)
 		     (void (*)(unsigned long)) con3270_read_tasklet,
 		     (unsigned long) condev->read);
 
-	raw3270_add_view(&condev->view, &con3270_fn, 1);
+	raw3270_add_view(&condev->view, &con3270_fn, 1, RAW3270_VIEW_LOCK_IRQ);
 
 	INIT_LIST_HEAD(&condev->freemem);
 	for (i = 0; i < CON3270_STRING_PAGES; i++) {
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index c4518168fd02..4f73a38c7cbd 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -463,7 +463,8 @@ fs3270_open(struct inode *inode, struct file *filp)
 
 	init_waitqueue_head(&fp->wait);
 	fp->fs_pid = get_pid(task_pid(current));
-	rc = raw3270_add_view(&fp->view, &fs3270_fn, minor);
+	rc = raw3270_add_view(&fp->view, &fs3270_fn, minor,
+			      RAW3270_VIEW_LOCK_BH);
 	if (rc) {
 		fs3270_free_view(&fp->view);
 		goto out;
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 5d4f053d7c38..0f47fec35acc 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -919,7 +919,7 @@ raw3270_deactivate_view(struct raw3270_view *view)
  * Add view to device with minor "minor".
  */
 int
-raw3270_add_view(struct raw3270_view *view, struct raw3270_fn *fn, int minor)
+raw3270_add_view(struct raw3270_view *view, struct raw3270_fn *fn, int minor, int subclass)
 {
 	unsigned long flags;
 	struct raw3270 *rp;
@@ -941,6 +941,7 @@ raw3270_add_view(struct raw3270_view *view, struct raw3270_fn *fn, int minor)
 		view->cols = rp->cols;
 		view->ascebc = rp->ascebc;
 		spin_lock_init(&view->lock);
+		lockdep_set_subclass(&view->lock, subclass);
 		list_add(&view->list, &rp->view_list);
 		rc = 0;
 		spin_unlock_irqrestore(get_ccwdev_lock(rp->cdev), flags);
diff --git a/drivers/s390/char/raw3270.h b/drivers/s390/char/raw3270.h
index 114ca7cbf889..3afaa35f7351 100644
--- a/drivers/s390/char/raw3270.h
+++ b/drivers/s390/char/raw3270.h
@@ -150,6 +150,8 @@ struct raw3270_fn {
 struct raw3270_view {
 	struct list_head list;
 	spinlock_t lock;
+#define RAW3270_VIEW_LOCK_IRQ	0
+#define RAW3270_VIEW_LOCK_BH	1
 	atomic_t ref_count;
 	struct raw3270 *dev;
 	struct raw3270_fn *fn;
@@ -158,7 +160,7 @@ struct raw3270_view {
 	unsigned char *ascebc;		/* ascii -> ebcdic table */
 };
 
-int raw3270_add_view(struct raw3270_view *, struct raw3270_fn *, int);
+int raw3270_add_view(struct raw3270_view *, struct raw3270_fn *, int, int);
 int raw3270_activate_view(struct raw3270_view *);
 void raw3270_del_view(struct raw3270_view *);
 void raw3270_deactivate_view(struct raw3270_view *);
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index e5ebe2fbee23..401688bf8fd3 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -978,7 +978,8 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		return PTR_ERR(tp);
 
 	rc = raw3270_add_view(&tp->view, &tty3270_fn,
-			      tty->index + RAW3270_FIRSTMINOR);
+			      tty->index + RAW3270_FIRSTMINOR,
+			      RAW3270_VIEW_LOCK_BH);
 	if (rc) {
 		tty3270_free_view(tp);
 		return rc;
-- 
2.20.1

