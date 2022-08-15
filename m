Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DA259434C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351709AbiHOWwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352350AbiHOWvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5188C13894B;
        Mon, 15 Aug 2022 12:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 840FF61178;
        Mon, 15 Aug 2022 19:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710A6C433C1;
        Mon, 15 Aug 2022 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593256;
        bh=MmaqZzJMFfhczwdG6lBI7PY17ZXYb9+bNAo7nLLp8qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wC+KIxfOr6Ls4q/cs8fPjc5EI3UuXfZRrqV6nvSDDvISCmbRWhmpmbOIKfz7rSNMd
         LRRyCtVC3QuGM0+ifmxkb1MCt8Dx7VaOGEuI/hF4wQJRINELV59VbSIN0D2S53h9Vd
         JXbs+kcZPMKiCTui25J2/LzYeKOS7sJLO10C18F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0237/1157] regulator: qcom_smd: Fix pm8916_pldo range
Date:   Mon, 15 Aug 2022 19:53:13 +0200
Message-Id: <20220815180449.045594664@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit e8977917e116d1571dacb8e9864474551c1c12bd ]

The PM8916 device specification [1] documents a programmable range of
1.75V to 3.337V with 12.5mV steps for the PMOS LDOs in PM8916. This
range is also used when controlling the regulator directly using the
qcom_spmi-regulator driver ("ult_pldo" there).

However, for some reason the qcom_smd-regulator driver allows a much
larger range for the same hardware component. This could be simply a
typo, since the start of the range is essentially just missing a '1'.

In practice this does not cause any major problems, since the driver
just sends the actual voltage to the RPM firmware instead of making use
of the incorrect voltage selector. Still, having the wrong range there
is confusing and prevents the regulator core from validating requests
correctly.

[1]: https://developer.qualcomm.com/download/sd410/pm8916pm8916-1-power-management-ic-device-specification.pdf

Fixes: 57d6567680ed ("regulator: qcom-smd: Add PM8916 support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Link: https://lore.kernel.org/r/20220623094614.1410180-2-stephan.gerhold@kernkonzept.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_smd-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
index ef6e47d025ca..60f3513f7038 100644
--- a/drivers/regulator/qcom_smd-regulator.c
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -357,10 +357,10 @@ static const struct regulator_desc pm8941_switch = {
 
 static const struct regulator_desc pm8916_pldo = {
 	.linear_ranges = (struct linear_range[]) {
-		REGULATOR_LINEAR_RANGE(750000, 0, 208, 12500),
+		REGULATOR_LINEAR_RANGE(1750000, 0, 127, 12500),
 	},
 	.n_linear_ranges = 1,
-	.n_voltages = 209,
+	.n_voltages = 128,
 	.ops = &rpm_smps_ldo_ops,
 };
 
-- 
2.35.1



