Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6139060AB84
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiJXNx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbiJXNwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A913BA902;
        Mon, 24 Oct 2022 05:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FF1461280;
        Mon, 24 Oct 2022 12:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73716C43470;
        Mon, 24 Oct 2022 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614743;
        bh=HHUg5KckEKVunibn2u7StkIkV/6yefiT8qKsdvKKleE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRqs9Lt4Nu4FqtNHQNP0vloQvemerN1pShKjvqJetLq6GdjoezL5mUQrHiHJvw19a
         rEZumvUTh1YO019o2Ek/IPpAukXnmiPloNDe6Bpdz03HecQzNMBrd2gNf5WIvowBy9
         D/ibdM+/s1AFIo6TeIHIEF35PL3jqUQlj4nyCtr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 377/390] arm64: topology: fix possible overflow in amu_fie_setup()
Date:   Mon, 24 Oct 2022 13:32:54 +0200
Message-Id: <20221024113039.036524410@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -158,7 +158,7 @@ static int validate_cpu_freq_invariance_
 	}
 
 	/* Convert maximum frequency from KHz to Hz and validate */
-	max_freq_hz = cpufreq_get_hw_max_freq(cpu) * 1000;
+	max_freq_hz = cpufreq_get_hw_max_freq(cpu) * 1000ULL;
 	if (unlikely(!max_freq_hz)) {
 		pr_debug("CPU%d: invalid maximum frequency.\n", cpu);
 		return -EINVAL;


