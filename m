Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1AF6AE94D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjCGRWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCGRWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3017286
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:17:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 443E3B81987
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA29C433A1;
        Tue,  7 Mar 2023 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209473;
        bh=rI6vaB/t77bBlrJKEngq0yjTSkcBHkpEMeeLk6ovIa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxsnZR5xieTYUbDkgEW7E65T4FwyYzGvzNx0tIbBSzPPab63rOVp9iKhirVWOWteQ
         ltoMU46g0O0Nutx//fVSA7fXvcdGZTgowqw/qLP8wyr7DQ7s21I+ec0MtKKq7kLakb
         UXW3kwIujv8xtKTdu/Q3qrYgdy+e1q7vpU6i0WcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0231/1001] kselftest/arm64: Fix enumeration of systems without 128 bit SME
Date:   Tue,  7 Mar 2023 17:50:03 +0100
Message-Id: <20230307170031.884558972@linuxfoundation.org>
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

[ Upstream commit 5f389238534ac8ca4ee3ab12eeb89d3984d303a1 ]

The current signal handling tests for SME do not account for the fact that
unlike SVE all SME vector lengths are optional so we can't guarantee that
we will encounter the minimum possible VL, they will hang enumerating VLs
on such systems. Abort enumeration when we find the lowest VL.

Fixes: 4963aeb35a9e ("kselftest/arm64: signal: Add SME signal handling tests")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230131-arm64-kselftest-sig-sme-no-128-v1-1-d47c13dc8e1e@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/testcases/ssve_regs.c | 4 ++++
 tools/testing/selftests/arm64/signal/testcases/za_regs.c   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c b/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c
index d0a178945b1a8..c6b17c47cac4c 100644
--- a/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c
+++ b/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c
@@ -34,6 +34,10 @@ static bool sme_get_vls(struct tdescr *td)
 
 		vl &= PR_SME_VL_LEN_MASK;
 
+		/* Did we find the lowest supported VL? */
+		if (vq < sve_vq_from_vl(vl))
+			break;
+
 		/* Skip missing VLs */
 		vq = sve_vq_from_vl(vl);
 
diff --git a/tools/testing/selftests/arm64/signal/testcases/za_regs.c b/tools/testing/selftests/arm64/signal/testcases/za_regs.c
index ea45acb115d5b..174ad66566964 100644
--- a/tools/testing/selftests/arm64/signal/testcases/za_regs.c
+++ b/tools/testing/selftests/arm64/signal/testcases/za_regs.c
@@ -34,6 +34,10 @@ static bool sme_get_vls(struct tdescr *td)
 
 		vl &= PR_SME_VL_LEN_MASK;
 
+		/* Did we find the lowest supported VL? */
+		if (vq < sve_vq_from_vl(vl))
+			break;
+
 		/* Skip missing VLs */
 		vq = sve_vq_from_vl(vl);
 
-- 
2.39.2



