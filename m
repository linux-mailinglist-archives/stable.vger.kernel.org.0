Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3531923FB42
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgHHXsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgHHXhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F18A207BB;
        Sat,  8 Aug 2020 23:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929851;
        bh=G5K0RJa7nYZUNphGIKeV64484sMdLIh3FAx+a8erWrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TyjTSw9Spthazbkj1ksAhzzcw4YUDRduDYUCkoQBx/x53uls2ziUvVX2eOlXillBx
         sact/PJoYO9FyLpVS+80Bt0eSkiEZNFzZWiEBsq2NeBKCBS2F/COqIwX7GbQrb65XY
         aaN5Qcppnc1cOJCUPoLttHceQOt+VNdXHHShg1Zo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Gherdovich <ggherdovich@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 05/58] x86, sched: Bail out of frequency invariance if turbo_freq/base_freq gives 0
Date:   Sat,  8 Aug 2020 19:36:31 -0400
Message-Id: <20200808233724.3618168-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Gherdovich <ggherdovich@suse.cz>

[ Upstream commit f4291df103315a696f0b8c4f45ca8ae773c17441 ]

Be defensive against the case where the processor reports a base_freq
larger than turbo_freq (the ratio would be zero).

Fixes: 1567c3e3467c ("x86, sched: Add support for frequency invariance")
Signed-off-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lkml.kernel.org/r/20200531182453.15254-4-ggherdovich@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3917a2de1580c..e5b2b20a0aeee 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1974,6 +1974,7 @@ static bool core_set_max_freq_ratio(u64 *base_freq, u64 *turbo_freq)
 static bool intel_set_max_freq_ratio(void)
 {
 	u64 base_freq, turbo_freq;
+	u64 turbo_ratio;
 
 	if (slv_set_max_freq_ratio(&base_freq, &turbo_freq))
 		goto out;
@@ -2007,9 +2008,15 @@ static bool intel_set_max_freq_ratio(void)
 		return false;
 	}
 
-	arch_turbo_freq_ratio = div_u64(turbo_freq * SCHED_CAPACITY_SCALE,
-					base_freq);
+	turbo_ratio = div_u64(turbo_freq * SCHED_CAPACITY_SCALE, base_freq);
+	if (!turbo_ratio) {
+		pr_debug("Non-zero turbo and base frequencies led to a 0 ratio.\n");
+		return false;
+	}
+
+	arch_turbo_freq_ratio = turbo_ratio;
 	arch_set_max_freq_ratio(turbo_disabled());
+
 	return true;
 }
 
-- 
2.25.1

