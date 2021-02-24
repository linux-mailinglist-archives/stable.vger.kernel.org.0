Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA93323DA9
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhBXNOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235800AbhBXNHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:07:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA1364F74;
        Wed, 24 Feb 2021 12:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171264;
        bh=TQwmV7NPb8dltdahmEF610sOO26f3WTes+Ne7T8MV1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2YnjQofnJ6xEd1uU26ir7Rj9KY+0oCoC61Qpwg2s9TmvGVEBcoepAF69Ab8Qze3W
         g8njACT9pTdZk18iBuf2Q5YK5yHZ78chu1ma8r70+pHxZeeIy2+FUn0rtlDcIDkQfZ
         VkfPL1q5V/z8HV8aR547u28OXQ5dgA4eoBJR02fRTgCdtqKNqP4bu5Xtb0BB/z7LUX
         U2s7lQT7FyntMTNsYxM9PFucLt4qVZ9XDApiDmPWNS+qkJbOXQ3JteDmP1RmVOhHs5
         7Tb0kRhfTCKabxuC13kMVwneVixJXt/Nquwkk1xO1pWCC6imezrlhSudS8cyL78Fyf
         pd0Yo8CVtvRWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 33/40] perf/x86/kvm: Add Cascade Lake Xeon steppings to isolation_ucodes[]
Date:   Wed, 24 Feb 2021 07:53:33 -0500
Message-Id: <20210224125340.483162-33-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit b3c3361fe325074d4144c29d46daae4fc5a268d5 ]

Cascade Lake Xeon parts have the same model number as Skylake Xeon
parts, so they are tagged with the intel_pebs_isolation
quirk. However, as with Skylake Xeon H0 stepping parts, the PEBS
isolation issue is fixed in all microcode versions.

Add the Cascade Lake Xeon steppings (5, 6, and 7) to the
isolation_ucodes[] table so that these parts benefit from Andi's
optimization in commit 9b545c04abd4f ("perf/x86/kvm: Avoid unnecessary
work in guest filtering").

Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/20210205191324.2889006-1-jmattson@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index b24c38090dd99..90760393a9643 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4002,6 +4002,9 @@ static const struct x86_cpu_desc isolation_ucodes[] = {
 	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_X,		 2, 0x0b000014),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 3, 0x00000021),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 4, 0x00000000),
+	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 5, 0x00000000),
+	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 6, 0x00000000),
+	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 7, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_L,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		 9, 0x0000004e),
-- 
2.27.0

