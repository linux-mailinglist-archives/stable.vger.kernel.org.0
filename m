Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7280B1C8F2B
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgEGO34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgEGO3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A627821473;
        Thu,  7 May 2020 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861795;
        bh=HmyanbqIU+mg0HbgtYSUBECyKESgiVSnXXzJzAHboeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSMt8FTTw2LZxO1STI/nrjJMuJotadBaHVRUM+4FveZACbkKiNUivwefCx3MGjgh2
         l9fQ6VRHqldjPG9Anw1Un2ozo392Yd3Oio7zgx6Uwkpl822FKU+sFnab8cAL6h5rQe
         Kc8M38JjeFULWypTSvqD5IzX3V56wIMh8jtNdi5g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/16] cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once
Date:   Thu,  7 May 2020 10:29:37 -0400
Message-Id: <20200507142943.26848-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142943.26848-1-sashal@kernel.org>
References: <20200507142943.26848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 8c539776ac83c0857395e1ccc9c6b516521a2d32 ]

Make a note of the first time we discover the turbo mode has been
disabled by the BIOS, as otherwise we complain every time we try to
update the mode.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7a5662425b291..1aa0b05c8cbdf 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -935,7 +935,7 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 
 	update_turbo_state();
 	if (global.turbo_disabled) {
-		pr_warn("Turbo disabled by BIOS or unavailable on processor\n");
+		pr_notice_once("Turbo disabled by BIOS or unavailable on processor\n");
 		mutex_unlock(&intel_pstate_limits_lock);
 		mutex_unlock(&intel_pstate_driver_lock);
 		return -EPERM;
-- 
2.20.1

