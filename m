Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C116A18798C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCQGWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:22:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:53584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgCQGWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 02:22:44 -0400
IronPort-SDR: gshdWBo30FL/OH8dhz3Re6uKxQSdEG+3nRMKaOzU5mL7kbVLyBgiE6mURQ3+SizbtsRAmykAj5
 2ZDnT1/RLetQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 23:22:44 -0700
IronPort-SDR: MeOW/RkChix9+L3XZWkbULOSqzYrZF12rc8e6ZOPMx0ghIoVq5R39Bhmq1aKzP9Rzj7OnGsDgm
 Fe5s63EY6rvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="445390326"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 16 Mar 2020 23:22:42 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 5/6] intel_th: Fix user-visible error codes
Date:   Tue, 17 Mar 2020 08:22:14 +0200
Message-Id: <20200317062215.15598-6-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are a few places in the driver that end up returning ENOTSUPP to
the user, replace those with EINVAL.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: ba82664c134ef ("intel_th: Add Memory Storage Unit driver")
Cc: stable@vger.kernel.org # v4.4+
---
 drivers/hwtracing/intel_th/msu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 7ac7dd4d3b1c..f08e9e883710 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -765,7 +765,7 @@ static int msc_configure(struct msc *msc)
 	lockdep_assert_held(&msc->buf_mutex);
 
 	if (msc->mode > MSC_MODE_MULTI)
-		return -ENOTSUPP;
+		return -EINVAL;
 
 	if (msc->mode == MSC_MODE_MULTI) {
 		if (msc_win_set_lockout(msc->cur_win, WIN_READY, WIN_INUSE))
@@ -1299,7 +1299,7 @@ static int msc_buffer_alloc(struct msc *msc, unsigned long *nr_pages,
 	} else if (msc->mode == MSC_MODE_MULTI) {
 		ret = msc_buffer_multi_alloc(msc, nr_pages, nr_wins);
 	} else {
-		ret = -ENOTSUPP;
+		ret = -EINVAL;
 	}
 
 	if (!ret) {
@@ -1535,7 +1535,7 @@ static ssize_t intel_th_msc_read(struct file *file, char __user *buf,
 		if (ret >= 0)
 			*ppos = iter->offset;
 	} else {
-		ret = -ENOTSUPP;
+		ret = -EINVAL;
 	}
 
 put_count:
-- 
2.25.1

