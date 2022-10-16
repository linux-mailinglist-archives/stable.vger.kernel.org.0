Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D37600341
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJPUVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJPUVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:21:51 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459121AF14
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:21:48 -0700 (PDT)
Received: from [192.168.1.103] (31.173.84.208) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Sun, 16 Oct
 2022 23:21:38 +0300
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH 5.10.y] arm64: topology: fix possible overflow in
 amu_fie_setup()
To:     Will Deacon <will@kernel.org>, <stable@vger.kernel.org>
CC:     <lvc-project@linuxtesting.org>, <lvc-patches@linuxtesting.org>
Organization: Open Mobile Platform
Message-ID: <012bfa47-1597-c0f8-b51a-6a927019b5a6@omp.ru>
Date:   Sun, 16 Oct 2022 23:21:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.173.84.208]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/16/2022 19:57:48
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 173142 [Oct 16 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 500 500 6cc86d8f5638d79810308830d98d6b6279998c49
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_phishing_log_reg_60_70}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: lore.kernel.org:7.1.1;omp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: ApMailHostAddress: 31.173.84.208
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/16/2022 20:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10/16/2022 6:23:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit d4955c0ad77dbc684fc716387070ac24801b8bca upstream.

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

---
 arch/arm64/kernel/topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-stable/arch/arm64/kernel/topology.c
===================================================================
--- linux-stable.orig/arch/arm64/kernel/topology.c
+++ linux-stable/arch/arm64/kernel/topology.c
@@ -158,7 +158,7 @@ static int validate_cpu_freq_invariance_
 	}
 
 	/* Convert maximum frequency from KHz to Hz and validate */
-	max_freq_hz = cpufreq_get_hw_max_freq(cpu) * 1000;
+	max_freq_hz = cpufreq_get_hw_max_freq(cpu) * 1000ULL;
 	if (unlikely(!max_freq_hz)) {
 		pr_debug("CPU%d: invalid maximum frequency.\n", cpu);
 		return -EINVAL;
