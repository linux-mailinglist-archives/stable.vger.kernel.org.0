Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A056357E5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbiKWJrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238200AbiKWJrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:47:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C253637A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:44:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4917BB81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E34C43145;
        Wed, 23 Nov 2022 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196662;
        bh=eEmAfVUZALbk9yjQY5MllatmVNTzT5nRTabkwupBJWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+xFFISO+ULdgIBQoaJvoaigpx3RToyt4XZ/cm/kqpoveXmxmeecuSZ13SsPF2G1H
         YAyFDmhUE0KYc4LnpmUp5JfFUdv0N2wWuinz11+g9aZ3ROoofgDsBk2YeXBNLQIaMX
         Yw1YLOB9qyyH78uVJkxdNxw15YJR+9euAAqzvlq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amit Pundir <amit.pundir@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 090/314] arm64: dts: qcom: sm8250: Disable the not yet supported cluster idle state
Date:   Wed, 23 Nov 2022 09:48:55 +0100
Message-Id: <20221123084629.563287888@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit cadaa773bcf161184fa428180516bae33a7bc667 ]

To support the deeper cluster idle state for sm8250 platforms, some
additional synchronization is needed between the rpmh-rsc device and the
CPU cluster PM domain. Until that is supported, let's disable the cluster
idle state.

This fixes a problem that has been reported for the Qcom RB5 platform (see
below), but most likely other sm8250 platforms suffers from similar issues,
so let's make the fix generic for sm8250.

vreg_l11c_3p3: failed to enable: -ETIMEDOUT
qcom-rpmh-regulator 18200000.rsc:pm8150l-rpmh-regulators: ldo11: devm_regulator_register() failed, ret=-110
qcom-rpmh-regulator: probe of 18200000.rsc:pm8150l-rpmh-regulators failed with error -110

Reported-by: Amit Pundir <amit.pundir@linaro.org>
Fixes: 32bc936d7321 ("arm64: dts: qcom: sm8250: Add cpuidle states")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221027115745.240516-1-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index bc773e210023..052b4dbc1ee4 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -334,6 +334,7 @@ CLUSTER_SLEEP_0: cluster-sleep-0 {
 				exit-latency-us = <6562>;
 				min-residency-us = <9987>;
 				local-timer-stop;
+				status = "disabled";
 			};
 		};
 	};
-- 
2.35.1



