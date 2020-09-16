Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF226C0E7
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgIPJmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:42:33 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:62293 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726760AbgIPJm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 05:42:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22443434-1500050 
        for multiple; Wed, 16 Sep 2020 10:42:19 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] drm/i915/gt: Always send a pulse down the engine after disabling heartbeat
Date:   Wed, 16 Sep 2020 10:42:18 +0100
Message-Id: <20200916094219.3878-3-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200916094219.3878-1-chris@chris-wilson.co.uk>
References: <20200916094219.3878-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, we check we can send a pulse prior to disabling the
heartbeat to verify that we can change the heartbeat, but since we may
re-evaluate execution upon changing the heartbeat interval we need another
pulse afterwards to refresh execution.

Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.7+
---
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
index 8ffdf676c0a0..d09df370f7cd 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
@@ -192,10 +192,12 @@ int intel_engine_set_heartbeat(struct intel_engine_cs *engine,
 	WRITE_ONCE(engine->props.heartbeat_interval_ms, delay);
 
 	if (intel_engine_pm_get_if_awake(engine)) {
-		if (delay)
+		if (delay) {
 			intel_engine_unpark_heartbeat(engine);
-		else
+		} else {
 			intel_engine_park_heartbeat(engine);
+			intel_engine_pulse(engine); /* recheck execution */
+		}
 		intel_engine_pm_put(engine);
 	}
 
-- 
2.20.1

