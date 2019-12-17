Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A070E122ABC
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 12:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfLQL4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 06:56:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:53797 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfLQLz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 06:55:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 03:55:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="205451607"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 17 Dec 2019 03:55:54 -0800
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>, stable@vger.kernel.org
Subject: [GIT PULL 4/4] intel_th: msu: Fix window switching without windows
Date:   Tue, 17 Dec 2019 13:55:27 +0200
Message-Id: <20191217115527.74383-5-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217115527.74383-1-alexander.shishkin@linux.intel.com>
References: <20191217115527.74383-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Fixes: 6cac7866c2741 ("intel_th: msu: Add a sysfs attribute to trigger window switch")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable@vger.kernel.org # v5.2+
---
 drivers/hwtracing/intel_th/msu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 6d240dfae9d9..8e48c7458aa3 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1676,10 +1676,13 @@ static int intel_th_msc_init(struct msc *msc)
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
@@ -1691,6 +1694,8 @@ static void msc_win_switch(struct msc *msc)
 	msc->base_addr = msc_win_base_dma(msc->cur_win);
 
 	intel_th_trace_switch(msc->thdev);
+
+	return 0;
 }
 
 /**
@@ -2025,16 +2030,15 @@ win_switch_store(struct device *dev, struct device_attribute *attr,
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
-- 
2.24.0

