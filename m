Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4470B4C080B
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiBWCbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiBWCao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86F3583B7;
        Tue, 22 Feb 2022 18:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D457B81E0C;
        Wed, 23 Feb 2022 02:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA4DC36AE3;
        Wed, 23 Feb 2022 02:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583383;
        bh=/TuSRVhhNgcRtaFhCwFzRY1d6sThkyuKd+NanmVdqy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pH89svBwo1SccBSoR6kNsAEvg8VtNCyWuFm5wdnsFT+oe63s6unfyaj7tQibqfD+D
         A3Ou0CWbp84L/CCMvJXSL31GREAbhf6rWftN4o/IZEm1s34QDD9GMacMnlkDYPiJ6Z
         szUDIEIyyCCTllUN+mhs/1bzCOEdIZFyKdSgo4N2XR6+EeNazGktnsP9xOHORekH5s
         4AYmahsyEDh8Smgedtv9M6Bjx/EITxZaPg4VDYuwrnymHj6zxNMEZ75+welqmxp6bb
         xSVNcE/wpfVqgyZpl49NNmp+9g4U2rZZuyfO/SfQCxsUIoxLEV7zEmVLRD6CuiUZk0
         m1u6Evkif5VJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Barta <oliver.barta@aptiv.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.15 06/28] regulator: core: fix false positive in regulator_late_cleanup()
Date:   Tue, 22 Feb 2022 21:29:07 -0500
Message-Id: <20220223022929.241127-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Oliver Barta <oliver.barta@aptiv.com>

[ Upstream commit 4e2a354e3775870ca823f1fb29bbbffbe11059a6 ]

The check done by regulator_late_cleanup() to detect whether a regulator
is on was inconsistent with the check done by _regulator_is_enabled().
While _regulator_is_enabled() takes the enable GPIO into account,
regulator_late_cleanup() was not doing that.

This resulted in a false positive, e.g. when a GPIO-controlled fixed
regulator was used, which was not enabled at boot time, e.g.

reg_disp_1v2: reg_disp_1v2 {
	compatible = "regulator-fixed";
	regulator-name = "display_1v2";
	regulator-min-microvolt = <1200000>;
	regulator-max-microvolt = <1200000>;
	gpio = <&tlmm 148 0>;
	enable-active-high;
};

Such regulator doesn't have an is_enabled() operation. Nevertheless
it's state can be determined based on the enable GPIO. The check in
regulator_late_cleanup() wrongly assumed that the regulator is on and
tried to disable it.

Signed-off-by: Oliver Barta <oliver.barta@aptiv.com>
Link: https://lore.kernel.org/r/20220208084645.8686-1-oliver.barta@aptiv.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ca6caba8a191a..46e76b5b21efe 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -6010,9 +6010,8 @@ core_initcall(regulator_init);
 static int regulator_late_cleanup(struct device *dev, void *data)
 {
 	struct regulator_dev *rdev = dev_to_rdev(dev);
-	const struct regulator_ops *ops = rdev->desc->ops;
 	struct regulation_constraints *c = rdev->constraints;
-	int enabled, ret;
+	int ret;
 
 	if (c && c->always_on)
 		return 0;
@@ -6025,14 +6024,8 @@ static int regulator_late_cleanup(struct device *dev, void *data)
 	if (rdev->use_count)
 		goto unlock;
 
-	/* If we can't read the status assume it's always on. */
-	if (ops->is_enabled)
-		enabled = ops->is_enabled(rdev);
-	else
-		enabled = 1;
-
-	/* But if reading the status failed, assume that it's off. */
-	if (enabled <= 0)
+	/* If reading the status failed, assume that it's off. */
+	if (_regulator_is_enabled(rdev) <= 0)
 		goto unlock;
 
 	if (have_full_constraints()) {
-- 
2.34.1

