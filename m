Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4685946B4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352575AbiHOXAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352509AbiHOW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F2331DEA;
        Mon, 15 Aug 2022 12:56:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05894B80EAD;
        Mon, 15 Aug 2022 19:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B798C433C1;
        Mon, 15 Aug 2022 19:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593403;
        bh=RbdrB2ItTg/BQanc9oDqPCLEHobXmx1sahtu8v1k7UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLqHZHHPxTeCGzssG6wpTUtDFqdR5EwSb8O2LYRZvahfyRoefvomaI9GfkYf6u8s4
         yyAYZNApvA3dIf+hE7yz5XhfnIQsWspSeTtA/DDgtYuYPhPO4nVBbIjGXpMz5sQR8q
         eD0NBoaOYTr1kzBhDcTiYxxHOAogDJm/difcno0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0941/1095] x86/bus_lock: Dont assume the init value of DEBUGCTLMSR.BUS_LOCK_DETECT to be zero
Date:   Mon, 15 Aug 2022 20:05:40 +0200
Message-Id: <20220815180508.118332691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 2c87d62f191e..ae7d4c85f4f4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1145,22 +1145,23 @@ static void bus_lock_init(void)
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



