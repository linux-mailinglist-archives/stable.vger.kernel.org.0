Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48B71F19B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbfEOLQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbfEOLQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:16:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0762220862;
        Wed, 15 May 2019 11:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918969;
        bh=qgZc3Z8zdzh1B2U9Bb7zVLAoHdp/V4YW9HmbOzLst04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KwFk8CrPMlnDUxvhCTswe5DnPr3vSP0lXu7By/eSy26ItgyO5d5s8447XrlKjqTD
         YzHyyZIN7qpZTXpdWFGDdfqnGz0H1EVv700ABTKMyIsW9b9tgcM3Oh7hO3ZJKHxvrD
         zYxQ3d5oMTetYnqm+jLedTM6YA7pgsHY+75cMa8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 018/115] s390/3270: fix lockdep false positive on view->lock
Date:   Wed, 15 May 2019 12:54:58 +0200
Message-Id: <20190515090700.611806320@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index be3e3c1206c24..1868ff803f439 100644
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
index c4518168fd02c..4f73a38c7cbd2 100644
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
index 5d4f053d7c38c..0f47fec35acc0 100644
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
index 114ca7cbf8897..3afaa35f73513 100644
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
index e5ebe2fbee235..401688bf8fd37 100644
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



