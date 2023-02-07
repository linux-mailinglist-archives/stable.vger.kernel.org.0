Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E097068D7C7
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjBGNDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbjBGNDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860C39EE7
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 215EF611AA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145FEC433EF;
        Tue,  7 Feb 2023 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774974;
        bh=RQvz+kH4LSpL35lxAqi+Bd7/BNj1sjnMI557/UDZ4Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHTIpK5dpCaZ3rjocGMD8MxmHCeK1z2wFS8oelN5IvS5QuaLIpbyXz7KEF78cdAd3
         ArQh2lisRi0H+8D7ibiPK/waWysbvw1Z19WhMp09NnhA9Uvkydq3UQnIVk0o8u1+zE
         TeGipCBHnbkliySvN9aGcnPmjxi319rfzrHCTkao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yair Podemsky <ypodemsk@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/208] x86/aperfmperf: Erase stale arch_freq_scale values when disabling frequency invariance readings
Date:   Tue,  7 Feb 2023 13:55:50 +0100
Message-Id: <20230207125638.726535914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yair Podemsky <ypodemsk@redhat.com>

[ Upstream commit 5f5cc9ed992cbab6361f198966f0edba5fc52688 ]

Once disable_freq_invariance_work is called the scale_freq_tick function
will not compute or update the arch_freq_scale values.
However the scheduler will still read these values and use them.
The result is that the scheduler might perform unfair decisions based on stale
values.

This patch adds the step of setting the arch_freq_scale values for all
cpus to the default (max) value SCHED_CAPACITY_SCALE, Once all cpus
have the same arch_freq_scale value the scaling is meaningless.

Signed-off-by: Yair Podemsky <ypodemsk@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230110160206.75912-1-ypodemsk@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/aperfmperf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 1f60a2b27936..fdbb5f07448f 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -330,7 +330,16 @@ static void __init bp_init_freq_invariance(void)
 
 static void disable_freq_invariance_workfn(struct work_struct *work)
 {
+	int cpu;
+
 	static_branch_disable(&arch_scale_freq_key);
+
+	/*
+	 * Set arch_freq_scale to a default value on all cpus
+	 * This negates the effect of scaling
+	 */
+	for_each_possible_cpu(cpu)
+		per_cpu(arch_freq_scale, cpu) = SCHED_CAPACITY_SCALE;
 }
 
 static DECLARE_WORK(disable_freq_invariance_work,
-- 
2.39.0



