Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4821912C8C3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbfL2R50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732963AbfL2R5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189B121744;
        Sun, 29 Dec 2019 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642244;
        bh=tLimZJIgN2Fma8fEKXPYFx7UStdsZvk3pJGF5ppdUDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8V9ijcFHlM3duXG3otxy1SxxAHdvrryX3Niazv5e1XReAaPa25+W5pJLTw841l6w
         VyXS6/JO9Nae82w12sh3GzPTTzUhHU2qFONzQjrCRI/0MREtczdX498qHSE4y8LrYy
         AZ0BybLjbxLm5vpD1KLPGX//gKbEVKrbnSNq0Op0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>
Subject: [PATCH 5.4 401/434] intel_th: msu: Fix window switching without windows
Date:   Sun, 29 Dec 2019 18:27:34 +0100
Message-Id: <20191229172729.149072010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 05b686b573cfb35a227c30787083a6631ff0f0c9 upstream.

Commit 6cac7866c2741 ("intel_th: msu: Add a sysfs attribute to trigger
window switch") adds a NULL pointer dereference in the case when there are
no windows allocated:

> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 1 SMP
> CPU: 5 PID: 1110 Comm: bash Not tainted 5.5.0-rc1+ #1
> RIP: 0010:msc_win_switch+0xa/0x80 [intel_th_msu]
> Call Trace:
> ? win_switch_store+0x9b/0xc0 [intel_th_msu]
> dev_attr_store+0x17/0x30
> sysfs_kf_write+0x3e/0x50
> kernfs_fop_write+0xda/0x1b0
> __vfs_write+0x1b/0x40
> vfs_write+0xb9/0x1a0
> ksys_write+0x67/0xe0
> __x64_sys_write+0x1a/0x20
> do_syscall_64+0x57/0x1d0
> entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix that by disallowing window switching with multiwindow buffers without
windows.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 6cac7866c274 ("intel_th: msu: Add a sysfs attribute to trigger window switch")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable@vger.kernel.org # v5.2+
Link: https://lore.kernel.org/r/20191217115527.74383-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/msu.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1676,10 +1676,13 @@ static int intel_th_msc_init(struct msc
 	return 0;
 }
 
-static void msc_win_switch(struct msc *msc)
+static int msc_win_switch(struct msc *msc)
 {
 	struct msc_window *first;
 
+	if (list_empty(&msc->win_list))
+		return -EINVAL;
+
 	first = list_first_entry(&msc->win_list, struct msc_window, entry);
 
 	if (msc_is_last_win(msc->cur_win))
@@ -1691,6 +1694,8 @@ static void msc_win_switch(struct msc *m
 	msc->base_addr = msc_win_base_dma(msc->cur_win);
 
 	intel_th_trace_switch(msc->thdev);
+
+	return 0;
 }
 
 /**
@@ -2025,16 +2030,15 @@ win_switch_store(struct device *dev, str
 	if (val != 1)
 		return -EINVAL;
 
+	ret = -EINVAL;
 	mutex_lock(&msc->buf_mutex);
 	/*
 	 * Window switch can only happen in the "multi" mode.
 	 * If a external buffer is engaged, they have the full
 	 * control over window switching.
 	 */
-	if (msc->mode != MSC_MODE_MULTI || msc->mbuf)
-		ret = -ENOTSUPP;
-	else
-		msc_win_switch(msc);
+	if (msc->mode == MSC_MODE_MULTI && !msc->mbuf)
+		ret = msc_win_switch(msc);
 	mutex_unlock(&msc->buf_mutex);
 
 	return ret ? ret : size;


