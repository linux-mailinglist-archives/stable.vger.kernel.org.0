Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB3110BB1B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbfK0VJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbfK0VJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF439216F4;
        Wed, 27 Nov 2019 21:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888976;
        bh=vqMW5dtzYH8+pdzDl5X+kiSDaTGXOnHbne2Iug37/gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY7cGE1BXxpzbIh36o7LVJRdGW8xwKSQeqqe6QAlwD+Z0kuY0gZ5eWD16Y8BZXAOv
         eVHD+ftEwJHGb/qTHYN0MhMiwKxlOcSd6g8ALX4T8/EVcfANyUbH/POiUR2a98n87H
         0opPIHOeqG+Fxp5++nqsf80G/4aLzpvt09yByMxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 34/95] drm/i915/pmu: "Frequency" is reported as accumulated cycles
Date:   Wed, 27 Nov 2019 21:31:51 +0100
Message-Id: <20191127202858.796926776@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit add3eeed3683e2636ef524db48e1a678757c8e96 upstream.

We report "frequencies" (actual-frequency, requested-frequency) as the
number of accumulated cycles so that the average frequency over that
period may be determined by the user. This means the units we report to
the user are Mcycles (or just M), not MHz.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191109105356.5273-1-chris@chris-wilson.co.uk
(cherry picked from commit e88866ef02851c88fe95a4bb97820b94b4d46f36)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit a7d87b70d6da96c6772e50728c8b4e78e4cbfd55)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_pmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -833,8 +833,8 @@ create_event_attributes(struct drm_i915_
 		const char *name;
 		const char *unit;
 	} events[] = {
-		__event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "MHz"),
-		__event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "MHz"),
+		__event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "M"),
+		__event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "M"),
 		__event(I915_PMU_INTERRUPTS, "interrupts", NULL),
 		__event(I915_PMU_RC6_RESIDENCY, "rc6-residency", "ns"),
 	};


