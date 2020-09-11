Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC12659F4
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 09:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgIKHEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 03:04:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45086 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgIKHCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 03:02:30 -0400
Date:   Fri, 11 Sep 2020 07:02:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599807748;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=+XSspCwQvh0J2ooBYP6QFotf1pi6VYTApeBPfzxv4qI=;
        b=sZ8iSV5urF6SRCMpkQLSq/+zUlVnwuLBuhaPwP0aC/dEB5vXYZNftFb7Hy8YdynG+PmWRG
        FBFcE2Z3nlX2uYgSpNSeicfbvt6k0CjBdBHgeXCSXDKhwnrWBiPyPdeDQAvfm1K01kOOJo
        P21FjTjF/STmIeEsdSLZMr/YYtDhQBzejhIcdNFT710MZFf0qmKc7kI4Kmh90GMwuKcSVG
        dEepmfP6ciJsPdkuTXTteFWGCVJLXNB/Ydgft7iF4YcFrVugaxMc9WwFQ6vFA2TIAb2Mlx
        w+WUut/KB5ok7EGd2JCejcvh+0C0c67IGvd6xeXoUgX1VNGH28EDuZtdwZpqRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599807748;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=+XSspCwQvh0J2ooBYP6QFotf1pi6VYTApeBPfzxv4qI=;
        b=rgI3PhM9ncHeZ9fpm2o8ZRqyTIe50MN/kX9QF0y9ixsa2i2OP2GN7IERni8v7M2UHVPcXB
        AoVacRJHNdJoWdCA==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/amd/ibs: Don't include randomized bits in
 get_ibs_op_count()
Cc:     Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159980774779.20229.6843050151606547108.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     680d69635005ba0e58fe3f4c52fc162b8fc743b0
Gitweb:        https://git.kernel.org/tip/680d69635005ba0e58fe3f4c52fc162b8fc743b0
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Tue, 08 Sep 2020 16:47:37 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 10 Sep 2020 11:19:35 +02:00

perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()

get_ibs_op_count() adds hardware's current count (IbsOpCurCnt) bits
to its count regardless of hardware's valid status.

According to the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54,
if the counter rolls over, valid status is set, and the lower 7 bits
of IbsOpCurCnt are randomized by hardware.

Don't include those bits in the driver's event count.

Fixes: 8b1e13638d46 ("perf/x86-ibs: Fix usage of IBS op current count")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
---
 arch/x86/events/amd/ibs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 26c3635..863174a 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -334,11 +334,15 @@ static u64 get_ibs_op_count(u64 config)
 {
 	u64 count = 0;
 
+	/*
+	 * If the internal 27-bit counter rolled over, the count is MaxCnt
+	 * and the lower 7 bits of CurCnt are randomized.
+	 * Otherwise CurCnt has the full 27-bit current counter value.
+	 */
 	if (config & IBS_OP_VAL)
-		count += (config & IBS_OP_MAX_CNT) << 4; /* cnt rolled over */
-
-	if (ibs_caps & IBS_CAPS_RDWROPCNT)
-		count += (config & IBS_OP_CUR_CNT) >> 32;
+		count = (config & IBS_OP_MAX_CNT) << 4;
+	else if (ibs_caps & IBS_CAPS_RDWROPCNT)
+		count = (config & IBS_OP_CUR_CNT) >> 32;
 
 	return count;
 }
