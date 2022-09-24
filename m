Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7148B5E8A3D
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 10:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiIXIoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 04:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiIXIoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 04:44:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0795B5A4C
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 01:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A729B80E1C
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 08:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9D4C433D7;
        Sat, 24 Sep 2022 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664009040;
        bh=5QnkSNzMLq24BghEagS9HLTaFSVpPTDL7QG+fOauemk=;
        h=Subject:To:Cc:From:Date:From;
        b=ikAquBVWqy8OUQhUrr/sjQ9BOCqJWZMGZPzy6kvAQqOTKyZ9CEkCQxyj+ig+7sCwB
         ly4Gn5nj9vSY2UlQJ/W1Cyfg0QaonJTGtEbYtY23wiBoSXrtauIpN9Zpq15AFNWJai
         adE1y3bWjIvmNocJls60jJeDOWtrEhzi5K+GXlbI=
Subject: FAILED: patch "[PATCH] arm64: topology: fix possible overflow in amu_fie_setup()" failed to apply to 5.10-stable tree
To:     s.shtylyov@omp.ru, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Sep 2022 10:43:57 +0200
Message-ID: <166400903732228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d4955c0ad77d ("arm64: topology: fix possible overflow in amu_fie_setup()")
eec73529a932 ("arch_topology: Rename freq_scale as arch_freq_scale")
a5f1b187cd24 ("arm64: topology: Make AMUs work with modular cpufreq drivers")
47b10b737c07 ("arm64: topology: Reorder init_amu_fie() a bit")
384e5699e101 ("arm64: topology: Avoid the have_policy check")
5ba836eb9fdb ("Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d4955c0ad77dbc684fc716387070ac24801b8bca Mon Sep 17 00:00:00 2001
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Fri, 16 Sep 2022 23:17:07 +0300
Subject: [PATCH] arm64: topology: fix possible overflow in amu_fie_setup()

cpufreq_get_hw_max_freq() returns max frequency in kHz as *unsigned int*,
while freq_inv_set_max_ratio() gets passed this frequency in Hz as 'u64'.
Multiplying max frequency by 1000 can potentially result in overflow --
multiplying by 1000ULL instead should avoid that...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: cd0ed03a8903 ("arm64: use activity monitors for frequency invariance")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/01493d64-2bce-d968-86dc-11a122a9c07d@omp.ru
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index ad2bfc794257..44ebf5b2fc4b 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -237,7 +237,7 @@ static void amu_fie_setup(const struct cpumask *cpus)
 	for_each_cpu(cpu, cpus) {
 		if (!freq_counters_valid(cpu) ||
 		    freq_inv_set_max_ratio(cpu,
-					   cpufreq_get_hw_max_freq(cpu) * 1000,
+					   cpufreq_get_hw_max_freq(cpu) * 1000ULL,
 					   arch_timer_get_rate()))
 			return;
 	}

