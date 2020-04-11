Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F241A5B32
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgDKXs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbgDKXEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB3720CC7;
        Sat, 11 Apr 2020 23:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646282;
        bh=Iobl1Rhpvo1Gt0PVbsdi2If4cMfmPKvvfD3VeJ2o4z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8A7IDQX8atmQpziuJBkiIxb9dcSXjDRW09ekavBfYKaTozIHj/37ja/TpUcy95Jw
         g+sO0HnSk/N1Ned7b2XzFfdU2gtb72RZIcmUm63J9DQ6CfyJAnRVRGIWAQUk8/dOln
         Q8PX/P4ZriC6FhTXQPWoQWgA2sdox4LFqkmGJOf8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 044/149] platform/x86/intel-uncore-freq: Fix static checker issue and potential race condition
Date:   Sat, 11 Apr 2020 19:02:01 -0400
Message-Id: <20200411230347.22371-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 64b73cff66acee7c1ec063676e0771534578c164 ]

There is a possible race condition when:
All CPUs in a package is offlined and just before the last CPU offline,
user tries to read sysfs entry and read happens while offline callback
is about to delete the sysfs entry.

Although not reproduced but this is possible scenerio and can be
reproduced by adding a msleep() in the show_min_max_freq_khz() before
mutex_lock() and read min_freq attribute from user space. Before
msleep() finishes, force every CPUs in a package offline.

This will cause deadlock, with offline and sysfs read/write operation
because of mutex_lock. The uncore_remove_die_entry() will not release
mutex till read/write callback returns because of kobject_put() and
read/write callback waiting on mutex.

We don't have to remove the sysfs folder when the package is offline.
While there is no CPU present, we can fail the read/write calls by
returning ENXIO error. So remove the kobject_put() call in offline path.

This also address the warning from static checker, as there is no
access to "data" variable after kobject_put:
"The patch 49a474c7ba51: "platform/x86: Add support for Uncore
frequency control" from Jan 13, 2020, leads to the following static
checker warning:

        drivers/platform/x86/intel-uncore-frequency.c:285 uncore_remove_die_entry()
        error: dereferencing freed memory 'data'
"

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-uncore-frequency.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel-uncore-frequency.c b/drivers/platform/x86/intel-uncore-frequency.c
index 2b1a0734c3f87..c83ec95e8f3ed 100644
--- a/drivers/platform/x86/intel-uncore-frequency.c
+++ b/drivers/platform/x86/intel-uncore-frequency.c
@@ -97,6 +97,9 @@ static int uncore_read_ratio(struct uncore_data *data, unsigned int *min,
 	u64 cap;
 	int ret;
 
+	if (data->control_cpu < 0)
+		return -ENXIO;
+
 	ret = rdmsrl_on_cpu(data->control_cpu, MSR_UNCORE_RATIO_LIMIT, &cap);
 	if (ret)
 		return ret;
@@ -116,6 +119,11 @@ static int uncore_write_ratio(struct uncore_data *data, unsigned int input,
 
 	mutex_lock(&uncore_lock);
 
+	if (data->control_cpu < 0) {
+		ret = -ENXIO;
+		goto finish_write;
+	}
+
 	input /= UNCORE_FREQ_KHZ_MULTIPLIER;
 	if (!input || input > 0x7F) {
 		ret = -EINVAL;
@@ -273,18 +281,15 @@ static void uncore_add_die_entry(int cpu)
 	mutex_unlock(&uncore_lock);
 }
 
-/* Last CPU in this die is offline, so remove sysfs entries */
+/* Last CPU in this die is offline, make control cpu invalid */
 static void uncore_remove_die_entry(int cpu)
 {
 	struct uncore_data *data;
 
 	mutex_lock(&uncore_lock);
 	data = uncore_get_instance(cpu);
-	if (data) {
-		kobject_put(&data->kobj);
+	if (data)
 		data->control_cpu = -1;
-		data->valid = false;
-	}
 	mutex_unlock(&uncore_lock);
 }
 
-- 
2.20.1

