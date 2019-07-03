Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395285E803
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCPm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 11:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCPm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 11:42:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A19920828;
        Wed,  3 Jul 2019 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562168547;
        bh=Fo8qPtbqVwIN0DTCEzZSropVOphGeUrUfhd2JEycBhA=;
        h=Subject:To:From:Date:From;
        b=ngobxnzBdUHkZ8ZP0OACuhl15OFyhDVUizetMM31jpaxoV+yu1TfU+q7rG7y7Ckju
         sTIOuaeBduevQ1VCoA6PB56+jqhHbOEzlIo8EcZGxSFTmzR/d48NYHslAi37MijPNG
         z9IGWW6Q+iIUtHaDCfZh8K69s/qW7OcBU/lBs5Ig=
Subject: patch "intel_th: msu: Fix unused variable warning on arm64 platform" added to char-misc-testing
To:     zhangshaokun@hisilicon.com, alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 17:42:24 +0200
Message-ID: <156216854422116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    intel_th: msu: Fix unused variable warning on arm64 platform

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From b96fb368b08f1637cbf780a6b83e36c2c5ed4ff5 Mon Sep 17 00:00:00 2001
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Date: Fri, 21 Jun 2019 19:19:27 +0300
Subject: intel_th: msu: Fix unused variable warning on arm64 platform
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit ba39bd8306057 ("intel_th: msu: Switch over to scatterlist")
introduced the following warnings on non-x86 architectures, as a result
of reordering the multi mode buffer allocation sequence:

> drivers/hwtracing/intel_th/msu.c: In function ‘msc_buffer_win_alloc’:
> drivers/hwtracing/intel_th/msu.c:783:21: warning: unused variable ‘i’
> [-Wunused-variable]
> int ret = -ENOMEM, i;
>                    ^
> drivers/hwtracing/intel_th/msu.c: In function ‘msc_buffer_win_free’:
> drivers/hwtracing/intel_th/msu.c:863:6: warning: unused variable ‘i’
> [-Wunused-variable]
> int i;
>     ^

Fix this compiler warning by factoring out set_memory sequences and making
them x86-only.

Suggested-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Fixes: ba39bd8306057 ("intel_th: msu: Switch over to scatterlist")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190621161930.60785-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/msu.c | 40 +++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 81bb54fa3ce8..8c568b5c8920 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -767,6 +767,30 @@ static int __msc_buffer_win_alloc(struct msc_window *win,
 	return -ENOMEM;
 }
 
+#ifdef CONFIG_X86
+static void msc_buffer_set_uc(struct msc_window *win, unsigned int nr_blocks)
+{
+	int i;
+
+	for (i = 0; i < nr_blocks; i++)
+		/* Set the page as uncached */
+		set_memory_uc((unsigned long)msc_win_block(win, i), 1);
+}
+
+static void msc_buffer_set_wb(struct msc_window *win)
+{
+	int i;
+
+	for (i = 0; i < win->nr_blocks; i++)
+		/* Reset the page to write-back */
+		set_memory_wb((unsigned long)msc_win_block(win, i), 1);
+}
+#else /* !X86 */
+static inline void
+msc_buffer_set_uc(struct msc_window *win, unsigned int nr_blocks) {}
+static inline void msc_buffer_set_wb(struct msc_window *win) {}
+#endif /* CONFIG_X86 */
+
 /**
  * msc_buffer_win_alloc() - alloc a window for a multiblock mode
  * @msc:	MSC device
@@ -780,7 +804,7 @@ static int __msc_buffer_win_alloc(struct msc_window *win,
 static int msc_buffer_win_alloc(struct msc *msc, unsigned int nr_blocks)
 {
 	struct msc_window *win;
-	int ret = -ENOMEM, i;
+	int ret = -ENOMEM;
 
 	if (!nr_blocks)
 		return 0;
@@ -811,11 +835,7 @@ static int msc_buffer_win_alloc(struct msc *msc, unsigned int nr_blocks)
 	if (ret < 0)
 		goto err_nomem;
 
-#ifdef CONFIG_X86
-	for (i = 0; i < ret; i++)
-		/* Set the page as uncached */
-		set_memory_uc((unsigned long)msc_win_block(win, i), 1);
-#endif
+	msc_buffer_set_uc(win, ret);
 
 	win->nr_blocks = ret;
 
@@ -860,8 +880,6 @@ static void __msc_buffer_win_free(struct msc *msc, struct msc_window *win)
  */
 static void msc_buffer_win_free(struct msc *msc, struct msc_window *win)
 {
-	int i;
-
 	msc->nr_pages -= win->nr_blocks;
 
 	list_del(&win->entry);
@@ -870,11 +888,7 @@ static void msc_buffer_win_free(struct msc *msc, struct msc_window *win)
 		msc->base_addr = 0;
 	}
 
-#ifdef CONFIG_X86
-	for (i = 0; i < win->nr_blocks; i++)
-		/* Reset the page to write-back */
-		set_memory_wb((unsigned long)msc_win_block(win, i), 1);
-#endif
+	msc_buffer_set_wb(win);
 
 	__msc_buffer_win_free(msc, win);
 
-- 
2.22.0


