Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86138617098
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 23:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiKBWXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 18:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKBWXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 18:23:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636745FDD;
        Wed,  2 Nov 2022 15:23:08 -0700 (PDT)
Date:   Wed, 02 Nov 2022 22:23:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667427786;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAMX8ZfmH3vXs4ns1qUTMjw38glCAwWY6fHEzJZ3b3o=;
        b=ywNC0eXjj3rXE+MmLzEGIRBKV6hBu9hs495dq8QlmFzL5raU6Hzg8VGAIOP8HJawqNBSvy
        oO4+lxS7r+sFuYLIMU7Ej+txBUM1V75/hPXPDlSFaMTcXyztH6Qy4M1y4C7jvXWzizKvH1
        gEZacD6GXJoqRTTDgwutMZrMX2wp6gvF1Un/SrgxloNT8zj9RPlgDW5IvV7O3m9725Q6bj
        d28tm9TfwYtVFtnxm9X7zsOHYhCPj+r6yGFG9dfjv8WIifs2MPjSQB1zxMZIQnwr2JRJvp
        E1SowzK0ClvrZDQQDRRrWHxxj7LpCjvW/MsdPCKDQNlayB38SyUmx/dNWuwK5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667427786;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SAMX8ZfmH3vXs4ns1qUTMjw38glCAwWY6fHEzJZ3b3o=;
        b=esV+tWklemYRXEVmZB9UbLPrd42OBAa0cQ8hOAtGfQFgvfg9QUGT/ZrS59jz9ZeOJMmuJe
        FzRL20dAgfOMfbBw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Add Cooper Lake stepping to
 isolation_ucodes[]
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221031154550.571663-1-kan.liang@linux.intel.com>
References: <20221031154550.571663-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166742778433.6127.17896330702614964032.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     6f8faf471446844bb9c318e0340221049d5c19f4
Gitweb:        https://git.kernel.org/tip/6f8faf471446844bb9c318e0340221049d5c19f4
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Mon, 31 Oct 2022 08:45:50 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 02 Nov 2022 12:22:07 +01:00

perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]

The intel_pebs_isolation quirk checks both model number and stepping.
Cooper Lake has a different stepping (11) than the other Skylake Xeon.
It cannot benefit from the optimization in commit 9b545c04abd4f
("perf/x86/kvm: Avoid unnecessary work in guest filtering").

Add the stepping of Cooper Lake into the isolation_ucodes[] table.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221031154550.571663-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a646a5f..1b92bf0 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4911,6 +4911,7 @@ static const struct x86_cpu_desc isolation_ucodes[] = {
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 5, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 6, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 7, 0x00000000),
+	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		11, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_L,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE,		 3, 0x0000007c),
 	INTEL_CPU_DESC(INTEL_FAM6_KABYLAKE,		 9, 0x0000004e),
