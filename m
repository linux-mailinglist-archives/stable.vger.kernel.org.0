Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D9594D0D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbiHPAsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350124AbiHPAqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6EDD8E32;
        Mon, 15 Aug 2022 13:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6105BB80EAD;
        Mon, 15 Aug 2022 20:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34C8C433D7;
        Mon, 15 Aug 2022 20:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596339;
        bh=oYX06H7Q/VqhynFigD32O2XLFCsEWftHbR1tJ5BP51Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbLzHBeCeAjco07WDk3jweT0Zu4jb3ctpccvWPn/fI/hG4Sfw+mT/gS8wdhN992jq
         5CmS1COOaEhfXyrCdrT7aksAy7pJ8hSCexzf5vqMr/qiZrL3YCd1GMdKiY4gpWYbIV
         /BO7cgWvPBOf9ZDiAVvnlbSS2/NNAN1TsHcw76oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1015/1157] x86/bus_lock: Dont assume the init value of DEBUGCTLMSR.BUS_LOCK_DETECT to be zero
Date:   Mon, 15 Aug 2022 20:06:11 +0200
Message-Id: <20220815180520.475236950@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

[ Upstream commit ffa6482e461ff550325356ae705b79e256702ea9 ]

It's possible that this kernel has been kexec'd from a kernel that
enabled bus lock detection, or (hypothetically) BIOS/firmware has set
DEBUGCTLMSR_BUS_LOCK_DETECT.

Disable bus lock detection explicitly if not wanted.

Fixes: ebb1064e7c2e ("x86/traps: Handle #DB for bus lock")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20220802033206.21333-1-chenyi.qiang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index fd5dead8371c..cb796ca6eff5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1216,22 +1216,23 @@ static void bus_lock_init(void)
 {
 	u64 val;
 
-	/*
-	 * Warn and fatal are handled by #AC for split lock if #AC for
-	 * split lock is supported.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) ||
-	    (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
-	    (sld_state == sld_warn || sld_state == sld_fatal)) ||
-	    sld_state == sld_off)
+	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
 		return;
 
-	/*
-	 * Enable #DB for bus lock. All bus locks are handled in #DB except
-	 * split locks are handled in #AC in the fatal case.
-	 */
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, val);
-	val |= DEBUGCTLMSR_BUS_LOCK_DETECT;
+
+	if ((boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    (sld_state == sld_warn || sld_state == sld_fatal)) ||
+	    sld_state == sld_off) {
+		/*
+		 * Warn and fatal are handled by #AC for split lock if #AC for
+		 * split lock is supported.
+		 */
+		val &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
+	} else {
+		val |= DEBUGCTLMSR_BUS_LOCK_DETECT;
+	}
+
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
 }
 
-- 
2.35.1



