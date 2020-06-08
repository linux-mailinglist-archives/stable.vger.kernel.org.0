Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B651F2A63
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgFIAHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbgFHXUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4012072F;
        Mon,  8 Jun 2020 23:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658449;
        bh=W2i2BRZmni5PV4/rL1upFoQqytctqsQ9UEQOK5v5ZHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhIOB+zO4tc5nNJDogeTMkD0q3QjPads7/zNKU23FW/JU2jQhRRsZ/S6JY5HfbppJ
         glVVPnvJCJIaD3FZGlreFghj0AZ2ZPFPcY7sftSAJSqrfEHAUayZxvX1Tw9AhBGr1C
         TuqU1HHCHRFYsdAPLuPxcgkCqKY0AhkDN1xu2B6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 091/175] iocost_monitor: drop string wrap around numbers when outputting json
Date:   Mon,  8 Jun 2020 19:17:24 -0400
Message-Id: <20200608231848.3366970-91-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 21f3cfeab304fc07b90d93d98d4d2f62110fe6b2 ]

Wrapping numbers in strings is used by some to work around bit-width issues in
some enviroments. The problem isn't innate to json and the workaround seems to
cause more integration problems than help. Let's drop the string wrapping.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/cgroup/iocost_monitor.py | 42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index 7e344a78a627..b8c082c9fd7d 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -112,14 +112,14 @@ class IocStat:
 
     def dict(self, now):
         return { 'device'               : devname,
-                 'timestamp'            : str(now),
-                 'enabled'              : str(int(self.enabled)),
-                 'running'              : str(int(self.running)),
-                 'period_ms'            : str(self.period_ms),
-                 'period_at'            : str(self.period_at),
-                 'period_vtime_at'      : str(self.vperiod_at),
-                 'busy_level'           : str(self.busy_level),
-                 'vrate_pct'            : str(self.vrate_pct), }
+                 'timestamp'            : now,
+                 'enabled'              : self.enabled,
+                 'running'              : self.running,
+                 'period_ms'            : self.period_ms,
+                 'period_at'            : self.period_at,
+                 'period_vtime_at'      : self.vperiod_at,
+                 'busy_level'           : self.busy_level,
+                 'vrate_pct'            : self.vrate_pct, }
 
     def table_preamble_str(self):
         state = ('RUN' if self.running else 'IDLE') if self.enabled else 'OFF'
@@ -179,19 +179,19 @@ class IocgStat:
 
     def dict(self, now, path):
         out = { 'cgroup'                : path,
-                'timestamp'             : str(now),
-                'is_active'             : str(int(self.is_active)),
-                'weight'                : str(self.weight),
-                'weight_active'         : str(self.active),
-                'weight_inuse'          : str(self.inuse),
-                'hweight_active_pct'    : str(self.hwa_pct),
-                'hweight_inuse_pct'     : str(self.hwi_pct),
-                'inflight_pct'          : str(self.inflight_pct),
-                'debt_ms'               : str(self.debt_ms),
-                'use_delay'             : str(self.use_delay),
-                'delay_ms'              : str(self.delay_ms),
-                'usage_pct'             : str(self.usage),
-                'address'               : str(hex(self.address)) }
+                'timestamp'             : now,
+                'is_active'             : self.is_active,
+                'weight'                : self.weight,
+                'weight_active'         : self.active,
+                'weight_inuse'          : self.inuse,
+                'hweight_active_pct'    : self.hwa_pct,
+                'hweight_inuse_pct'     : self.hwi_pct,
+                'inflight_pct'          : self.inflight_pct,
+                'debt_ms'               : self.debt_ms,
+                'use_delay'             : self.use_delay,
+                'delay_ms'              : self.delay_ms,
+                'usage_pct'             : self.usage,
+                'address'               : self.address }
         for i in range(len(self.usages)):
             out[f'usage_pct_{i}'] = str(self.usages[i])
         return out
-- 
2.25.1

