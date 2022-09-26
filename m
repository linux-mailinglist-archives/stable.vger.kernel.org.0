Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB60C5EA453
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbiIZLpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238608AbiIZLoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:44:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F4972B64;
        Mon, 26 Sep 2022 03:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86360B80691;
        Mon, 26 Sep 2022 10:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A99C433D6;
        Mon, 26 Sep 2022 10:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189180;
        bh=fqLtuLhz5QTIlo+A3IXwAHfAVSOavrA51A9oFc9hZAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMgWkAI4YX9eJj7lEz07Uc3iivqV1G7Hkw9D9h9TDMesoVtJxkaY3ie0QrmUU/aP3
         bkc6zl2/KHekLn4wAiC3sTOok0KnmT+eM8nFGAsgSXPPxraPrKKFiqDqHweq17jSXf
         rvmKDW4tDH4Rg85I7LZ8GBUXUGrQtbm7cwRVnojQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 068/207] arm64: topology: fix possible overflow in amu_fie_setup()
Date:   Mon, 26 Sep 2022 12:10:57 +0200
Message-Id: <20220926100809.645226980@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit d4955c0ad77dbc684fc716387070ac24801b8bca upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -251,7 +251,7 @@ static void amu_fie_setup(const struct c
 	for_each_cpu(cpu, cpus) {
 		if (!freq_counters_valid(cpu) ||
 		    freq_inv_set_max_ratio(cpu,
-					   cpufreq_get_hw_max_freq(cpu) * 1000,
+					   cpufreq_get_hw_max_freq(cpu) * 1000ULL,
 					   arch_timer_get_rate()))
 			return;
 	}


