Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BD54DB26F
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbiCPORA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356472AbiCPOQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3101B6352C;
        Wed, 16 Mar 2022 07:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DECA6113D;
        Wed, 16 Mar 2022 14:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46D3C340F4;
        Wed, 16 Mar 2022 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440129;
        bh=oECYDvIRBL9OMBSMeOmUsaD9PwaLEVCsd4jApkaaWug=;
        h=From:To:Cc:Subject:Date:From;
        b=fFr5icXnePXgaOR76sQYjwRikIKrHoFJ+i1BFrxHAAKQPeusq+UQy5Voc8Lx0UVoJ
         LkJ5ZMGhcmLvAf0w4NRnuA3mBXuP1aK/LW+iubrcuW8YJ4jJq5tqfAgQVcAfqST5eD
         lOrm/WXaIMOrY8caXMLLhMG+OvX4eBh2Fvm/9JdhSnwGushFwa3UdfRN6MZC9WbxXy
         9vhc64iBw0Phy1K/CR2NhkcSRgzn+ApFAB2ah3+LKp+8/sBtsOckWIm98blUo7y8rF
         q/GkZDOGMCrpPwhQIP2BHCNv9235SxU8o8ps8Ib1isO40YzSLIZ+6zwfqo/0M/iq8V
         B1Q//Wbwi59NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/13] arm64: dts: qcom: c630: disable crypto due to serror
Date:   Wed, 16 Mar 2022 10:15:01 -0400
Message-Id: <20220316141513.247965-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steev Klimaszewski <steev@kali.org>

[ Upstream commit 382e3e0eb6a83f1cf73d4dfa3448ade1ed721f22 ]

Disable the crypto block due to it causing an SError in qce_start() on
the C630, which happens upon every boot when cryptomanager tests are
enabled.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
[bjorn: Reworked commit message]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211105035235.2392-1-steev@kali.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 617a634ac905..d6a9dbe59a1d 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -793,3 +793,8 @@ &wifi {
 
 	qcom,snoc-host-cap-8bit-quirk;
 };
+
+&crypto {
+	/* FIXME: qce_start triggers an SError */
+	status= "disable";
+};
-- 
2.34.1

