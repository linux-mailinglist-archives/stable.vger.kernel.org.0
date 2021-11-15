Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E313451FDA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349932AbhKPApi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343827AbhKOTWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70480635ED;
        Mon, 15 Nov 2021 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002006;
        bh=QpGi9pmWDoQWDWTiPXW1eevR+tAtIcUVVaVpg/+oFXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWiVQZz8w6Ay/IDNcVEjxoSQAI+3V5oHunRgskn3peupBzi/5B0uOrR9G/z+sfLQO
         YQwPgGPYOBMQDi/8Mad02fCShX7CDLnlIXJcm6WFuJQwJugpTnVj1FodixYik4fSa7
         HTBg3ogNWAHG2X5vkverAecQaSF6nomm4p3DBagE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        Quentin Perret <qperret@google.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/917] PM: EM: Fix inefficient states detection
Date:   Mon, 15 Nov 2021 17:58:18 +0100
Message-Id: <20211115165442.453254519@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit aa1a43262ad5df010768f69530fa179ff81651d3 ]

Currently, a debug message is printed if an inefficient state is detected
in the Energy Model. Unfortunately, it won't detect if the first state is
inefficient or if two successive states are. Fix this behavior.

Fixes: 27871f7a8a34 (PM: Introduce an Energy Model management framework)
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Reviewed-by: Quentin Perret <qperret@google.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index a332ccd829e24..97e62469a6b32 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -107,8 +107,7 @@ static void em_debug_remove_pd(struct device *dev) {}
 static int em_create_perf_table(struct device *dev, struct em_perf_domain *pd,
 				int nr_states, struct em_data_callback *cb)
 {
-	unsigned long opp_eff, prev_opp_eff = ULONG_MAX;
-	unsigned long power, freq, prev_freq = 0;
+	unsigned long power, freq, prev_freq = 0, prev_cost = ULONG_MAX;
 	struct em_perf_state *table;
 	int i, ret;
 	u64 fmax;
@@ -153,27 +152,21 @@ static int em_create_perf_table(struct device *dev, struct em_perf_domain *pd,
 
 		table[i].power = power;
 		table[i].frequency = prev_freq = freq;
-
-		/*
-		 * The hertz/watts efficiency ratio should decrease as the
-		 * frequency grows on sane platforms. But this isn't always
-		 * true in practice so warn the user if a higher OPP is more
-		 * power efficient than a lower one.
-		 */
-		opp_eff = freq / power;
-		if (opp_eff >= prev_opp_eff)
-			dev_dbg(dev, "EM: hertz/watts ratio non-monotonically decreasing: em_perf_state %d >= em_perf_state%d\n",
-					i, i - 1);
-		prev_opp_eff = opp_eff;
 	}
 
 	/* Compute the cost of each performance state. */
 	fmax = (u64) table[nr_states - 1].frequency;
-	for (i = 0; i < nr_states; i++) {
+	for (i = nr_states - 1; i >= 0; i--) {
 		unsigned long power_res = em_scale_power(table[i].power);
 
 		table[i].cost = div64_u64(fmax * power_res,
 					  table[i].frequency);
+		if (table[i].cost >= prev_cost) {
+			dev_dbg(dev, "EM: OPP:%lu is inefficient\n",
+				table[i].frequency);
+		} else {
+			prev_cost = table[i].cost;
+		}
 	}
 
 	pd->table = table;
-- 
2.33.0



