Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0018798B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 07:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgCQGWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 02:22:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:53584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgCQGWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 02:22:39 -0400
IronPort-SDR: DpaV5u2OSmdapHp/CZZP/Btrt02wodnv/vIuTfeeF2dmbusMy7V9t9U3VV1TbyKZiwLdUUR3JH
 QaeQSAuVjYUQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 23:22:38 -0700
IronPort-SDR: 2aYydfiHbIhwgRb2+ek13+5IMFLe0FFyLk8CnmDD0/L771+Z+jfImD/0UVx0raO4fNPINbwLs2
 11qFWHaVRYqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="445390317"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 16 Mar 2020 23:22:37 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 2/6] stm class: sys-t: Fix the use of time_after()
Date:   Tue, 17 Mar 2020 08:22:11 +0200
Message-Id: <20200317062215.15598-3-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The operands of time_after() are in a wrong order in both instances in
the sys-t driver. Fix that.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 39f10239df75 ("stm class: p_sys-t: Add support for CLOCKSYNC packets")
Fixes: d69d5e83110f ("stm class: Add MIPI SyS-T protocol support")
Cc: stable@vger.kernel.org # v4.20+
---
 drivers/hwtracing/stm/p_sys-t.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/stm/p_sys-t.c b/drivers/hwtracing/stm/p_sys-t.c
index b178a5495b67..360b5c03df95 100644
--- a/drivers/hwtracing/stm/p_sys-t.c
+++ b/drivers/hwtracing/stm/p_sys-t.c
@@ -238,7 +238,7 @@ static struct configfs_attribute *sys_t_policy_attrs[] = {
 static inline bool sys_t_need_ts(struct sys_t_output *op)
 {
 	if (op->node.ts_interval &&
-	    time_after(op->ts_jiffies + op->node.ts_interval, jiffies)) {
+	    time_after(jiffies, op->ts_jiffies + op->node.ts_interval)) {
 		op->ts_jiffies = jiffies;
 
 		return true;
@@ -250,8 +250,8 @@ static inline bool sys_t_need_ts(struct sys_t_output *op)
 static bool sys_t_need_clock_sync(struct sys_t_output *op)
 {
 	if (op->node.clocksync_interval &&
-	    time_after(op->clocksync_jiffies + op->node.clocksync_interval,
-		       jiffies)) {
+	    time_after(jiffies,
+		       op->clocksync_jiffies + op->node.clocksync_interval)) {
 		op->clocksync_jiffies = jiffies;
 
 		return true;
-- 
2.25.1

