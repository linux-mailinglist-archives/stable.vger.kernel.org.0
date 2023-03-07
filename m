Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80136AE940
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjCGRWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCGRWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D425798E87
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 717DB61507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CEDC433D2;
        Tue,  7 Mar 2023 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209432;
        bh=cIKITZ0rg0q81OMnAi3fSWo9WaDeyazQwtAE9jMT2U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4majqT+UXElN9eoIdYKQ+sTDmC6B89OciT4Y/jZ3/Z04bXb8oRlJNHb8dUrs3XlQ
         hHRqfZYuDrNZ+s2GyAhsEtFQUVLzhPCBxKVTHuiHQf1YoVhvgfpjgOljBhNjDaHN65
         5VDtsnQGm9/pAa89c4VEYWOxrD9T2Uu1NN2tmiiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0190/1001] arm64/sysreg: Fix errors in 32 bit enumeration values
Date:   Tue,  7 Mar 2023 17:49:22 +0100
Message-Id: <20230307170030.127423495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8c6e105558628b63292ae770198f11a1d5535660 ]

The recently converted 32 bit ID registers have errors in MVFR0_EL1.FPSP,
MVFR0_EL1.SIMDReg and MVFR1_EL1.SIMDHP where enumeration values which
should be 0b0010 are specified as 0b0001. Correct these.

Fixes: e79c94a2a487 ("arm64/sysreg: Convert MVFR0_EL1 to automatic generation")
Fixes: c9b718eda706 ("arm64/sysreg: Convert MVFR1_EL1 to automatic generation")
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221207-arm64-sysreg-helpers-v3-2-0d71a7b174a8@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/tools/sysreg | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 184e58fd5631a..e8fb6684d7f3c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -689,17 +689,17 @@ EndEnum
 Enum	11:8	FPDP
 	0b0000	NI
 	0b0001	VFPv2
-	0b0001	VFPv3
+	0b0010	VFPv3
 EndEnum
 Enum	7:4	FPSP
 	0b0000	NI
 	0b0001	VFPv2
-	0b0001	VFPv3
+	0b0010	VFPv3
 EndEnum
 Enum	3:0	SIMDReg
 	0b0000	NI
 	0b0001	IMP_16x64
-	0b0001	IMP_32x64
+	0b0010	IMP_32x64
 EndEnum
 EndSysreg
 
@@ -718,7 +718,7 @@ EndEnum
 Enum	23:20	SIMDHP
 	0b0000	NI
 	0b0001	SIMDHP
-	0b0001	SIMDHP_FLOAT
+	0b0010	SIMDHP_FLOAT
 EndEnum
 Enum	19:16	SIMDSP
 	0b0000	NI
-- 
2.39.2



