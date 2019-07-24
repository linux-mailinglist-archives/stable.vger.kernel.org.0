Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A65773E90
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389419AbfGXTjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389890AbfGXTjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DC9229F3;
        Wed, 24 Jul 2019 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997159;
        bh=0KgvDU0XhNL47yNK+Ou6qumBEZgbCbUo9x6GoEBJEdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Da02D36uyrubblU+nMM5odvjKx34No97lpjFXXdxhpXtYCHDdYB6Q8tgcqCtvwLPb
         X5jBGIqV4FQStjOQSWhcJ8aR3jycR1JJzbi/yMCh83mv2TfWEr+M+9UqV0HQueQAxu
         2NiFizZVblbzKGaOOvRly+qHJ/DNlysU0deW5RMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.2 339/413] intel_th: msu: Fix unused variable warning on arm64 platform
Date:   Wed, 24 Jul 2019 21:20:30 +0200
Message-Id: <20190724191800.091699497@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

commit b96fb368b08f1637cbf780a6b83e36c2c5ed4ff5 upstream.

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
 drivers/hwtracing/intel_th/msu.c |   40 ++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -767,6 +767,30 @@ err_nomem:
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
@@ -780,7 +804,7 @@ err_nomem:
 static int msc_buffer_win_alloc(struct msc *msc, unsigned int nr_blocks)
 {
 	struct msc_window *win;
-	int ret = -ENOMEM, i;
+	int ret = -ENOMEM;
 
 	if (!nr_blocks)
 		return 0;
@@ -811,11 +835,7 @@ static int msc_buffer_win_alloc(struct m
 	if (ret < 0)
 		goto err_nomem;
 
-#ifdef CONFIG_X86
-	for (i = 0; i < ret; i++)
-		/* Set the page as uncached */
-		set_memory_uc((unsigned long)msc_win_block(win, i), 1);
-#endif
+	msc_buffer_set_uc(win, ret);
 
 	win->nr_blocks = ret;
 
@@ -860,8 +880,6 @@ static void __msc_buffer_win_free(struct
  */
 static void msc_buffer_win_free(struct msc *msc, struct msc_window *win)
 {
-	int i;
-
 	msc->nr_pages -= win->nr_blocks;
 
 	list_del(&win->entry);
@@ -870,11 +888,7 @@ static void msc_buffer_win_free(struct m
 		msc->base_addr = 0;
 	}
 
-#ifdef CONFIG_X86
-	for (i = 0; i < win->nr_blocks; i++)
-		/* Reset the page to write-back */
-		set_memory_wb((unsigned long)msc_win_block(win, i), 1);
-#endif
+	msc_buffer_set_wb(win);
 
 	__msc_buffer_win_free(msc, win);
 


