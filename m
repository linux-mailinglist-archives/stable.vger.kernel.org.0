Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B34418798A
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgCQGWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:22:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:53584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgCQGWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 02:22:43 -0400
IronPort-SDR: 3erJ1kviT51g3FPCZYjwj5ikSK0Kcqz6A2jIsgppbBGakVcrXNU7SGfW32AeCjglBTspr3Vgv+
 p+/MUnctim7w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 23:22:43 -0700
IronPort-SDR: dF9lqlgOi8hk5lSI1s/j4THCYuZCCey2wDzUzstiYJOh/CRO5Ptjz+CfV61zgYysy7TB5YNQRI
 ZYFlZxTftVXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="445390324"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 16 Mar 2020 23:22:40 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 4/6] intel_th: msu: Fix the unexpected state warning
Date:   Tue, 17 Mar 2020 08:22:13 +0200
Message-Id: <20200317062215.15598-5-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The unexpected state warning should only warn on illegal state
transitions. Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 615c164da0eb4 ("intel_th: msu: Introduce buffer interface")
Cc: stable@vger.kernel.org # v5.4+
---
 drivers/hwtracing/intel_th/msu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 45916b48bcf0..7ac7dd4d3b1c 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -722,9 +722,6 @@ static int msc_win_set_lockout(struct msc_window *win,
 
 	if (old != expect) {
 		ret = -EINVAL;
-		dev_warn_ratelimited(msc_dev(win->msc),
-				     "expected lockout state %d, got %d\n",
-				     expect, old);
 		goto unlock;
 	}
 
@@ -745,6 +742,10 @@ static int msc_win_set_lockout(struct msc_window *win,
 		/* from intel_th_msc_window_unlock(), don't warn if not locked */
 		if (expect == WIN_LOCKED && old == new)
 			return 0;
+
+		dev_warn_ratelimited(msc_dev(win->msc),
+				     "expected lockout state %d, got %d\n",
+				     expect, old);
 	}
 
 	return ret;
-- 
2.25.1

