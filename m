Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1532E86D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhCEM0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231390AbhCEM01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:26:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BF8A6502C;
        Fri,  5 Mar 2021 12:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947187;
        bh=gOBTWqoTn2+HwoSdiseF1+ZGvOYzZH17dtVU/0oEl18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8Vdk00hLQFvHiMfFL8xvOKpoqIGEbd0d8MJR9UhFFVx/CGlXqjkb9ZrRLZJ4dUeA
         wTztehi0WQ0mpdgLo17wAW3qLHSKZgDGN5zCfrVRrI8ekEmBlPGoJhFyInMOmzA+Pe
         syf7mGY7hdHD+hrEvsJXx+7I26tff+84WuPqzxH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 080/104] perf/x86/kvm: Add Cascade Lake Xeon steppings to isolation_ucodes[]
Date:   Fri,  5 Mar 2021 13:21:25 +0100
Message-Id: <20210305120907.089563286@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d4569bfa83e3..4faaef3a8f6c 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4397,6 +4397,9 @@ static const struct x86_cpu_desc isolation_ucodes[] = {
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
2.30.1



