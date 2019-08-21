Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B9973E3
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 09:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHUHvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 03:51:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:24467 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfHUHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Aug 2019 03:51:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 00:51:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="329947215"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 21 Aug 2019 00:50:58 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL v1 1/4] stm class: Fix a double free of stm_source_device
Date:   Wed, 21 Aug 2019 10:49:52 +0300
Message-Id: <20190821074955.3925-2-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190821074955.3925-1-alexander.shishkin@linux.intel.com>
References: <20190821074955.3925-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

In the error path of stm_source_register_device(), the kfree is
unnecessary, as the put_device() before it ends up calling
stm_source_device_release() to free stm_source_device, leading to
a double free at the outer kfree() call. Remove it.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 7bd1d4093c2fa ("stm class: Introduce an abstraction for System Trace Module devices")
Link: https://lore.kernel.org/linux-arm-kernel/1563354988-23826-1-git-send-email-dingxiang@cmss.chinamobile.com/
Cc: stable@vger.kernel.org # v4.4+
---
 drivers/hwtracing/stm/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index e55b902560de..181e7ff1ec4f 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -1276,7 +1276,6 @@ int stm_source_register_device(struct device *parent,
 
 err:
 	put_device(&src->dev);
-	kfree(src);
 
 	return err;
 }
-- 
2.23.0.rc1

