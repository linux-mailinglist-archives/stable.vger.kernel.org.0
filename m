Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39D35E804
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 17:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfGCPmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 11:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCPmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 11:42:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8082D20828;
        Wed,  3 Jul 2019 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562168555;
        bh=C0aIRvHt6ir4DzQCzm4nAHMdPiVAOozVaUiMuse10b8=;
        h=Subject:To:From:Date:From;
        b=UZs9EWmTNE4v1zcqinamy7dUIu1W0Jh8WXKzPSEld6wnVAEzFALaScXcq8MEruMmV
         o9KVA6esitJTFWQyi2Wao0orSY2fCKOVORXKrP6/WrFbQBDxWul1Pbu1P0knx64x/z
         13UFIwaDN7ZKiKeVwe2SSWMgEoxfv+Vm0LXcrVig=
Subject: patch "intel_th: msu: Remove set but not used variable 'last'" added to char-misc-testing
To:     yuehaibing@huawei.com, alexander.shishkin@linux.intel.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 17:42:24 +0200
Message-ID: <1562168544199156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    intel_th: msu: Remove set but not used variable 'last'

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 9800db282dff675dd700d5985d90b605c34b5ccd Mon Sep 17 00:00:00 2001
From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 21 Jun 2019 19:19:28 +0300
Subject: intel_th: msu: Remove set but not used variable 'last'

Commit aad14ad3cf3a ("intel_th: msu: Add current window tracking") added
the following gcc warning:

> drivers/hwtracing/intel_th/msu.c: In function msc_win_switch:
> drivers/hwtracing/intel_th/msu.c:1389:21: warning: variable last set but
> not used [-Wunused-but-set-variable]

Fix it by removing the variable.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Fixes: aad14ad3cf3a ("intel_th: msu: Add current window tracking")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190621161930.60785-3-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/msu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 8c568b5c8920..6bfce03c6489 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1400,10 +1400,9 @@ static int intel_th_msc_init(struct msc *msc)
 
 static void msc_win_switch(struct msc *msc)
 {
-	struct msc_window *last, *first;
+	struct msc_window *first;
 
 	first = list_first_entry(&msc->win_list, struct msc_window, entry);
-	last = list_last_entry(&msc->win_list, struct msc_window, entry);
 
 	if (msc_is_last_win(msc->cur_win))
 		msc->cur_win = first;
-- 
2.22.0


