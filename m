Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562A75EA334
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbiIZLV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiIZLTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEE052E76;
        Mon, 26 Sep 2022 03:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC2660A55;
        Mon, 26 Sep 2022 10:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182E1C433C1;
        Mon, 26 Sep 2022 10:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188676;
        bh=iouAbAkI/ElJu2TX+ZZh0YDNRjgxZWNLSqzyyDzKLNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsRLTfQOQvB5O/3bXlc5Tqzysx8zr5NLYTikH1UbS0CGAfY5eC5oVVf4Sn4rnsZTW
         yajbdZH04DZR3uH6F5R74eCt1FKqcUA01t0I2RFFlbzc0OVIZkFv7aAsOBlj/mHhq1
         O+9yjTUz0h9rSk0Ez307eefIKa21jw2RZmedRAn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 053/148] arm64: topology: fix possible overflow in amu_fie_setup()
Date:   Mon, 26 Sep 2022 12:11:27 +0200
Message-Id: <20220926100758.007635136@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
@@ -249,7 +249,7 @@ static void amu_fie_setup(const struct c
 	for_each_cpu(cpu, cpus) {
 		if (!freq_counters_valid(cpu) ||
 		    freq_inv_set_max_ratio(cpu,
-					   cpufreq_get_hw_max_freq(cpu) * 1000,
+					   cpufreq_get_hw_max_freq(cpu) * 1000ULL,
 					   arch_timer_get_rate()))
 			return;
 	}


