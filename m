Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F3D6BB177
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjCOM1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbjCOM1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:27:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E452E9C9A0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CECD4B81E09
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3328DC433EF;
        Wed, 15 Mar 2023 12:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883182;
        bh=exJWNM5wercgRre0R2OEL6UJcxStHpLt792cNugqMeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkYXsmWvemIMN6wk0RxINcb1CgjwAuOI9VDMnOzIpaks+/m9hWpsqYyoUMVkQWWeG
         yPnrNdKWtkUE+s1Xl/eCfJ12uMUFys1yquDYdbxcqS4xRRpAHSJBuQdrqyLmHrtt48
         PPZXRbYQ7LI32HBc78mmXehqB9cKScKS5OZNVcow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/145] regulator: Flag uncontrollable regulators as always_on
Date:   Wed, 15 Mar 2023 13:11:45 +0100
Message-Id: <20230315115740.364794202@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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

[ Upstream commit 261f06315cf7c3744731e36bfd8d4434949e3389 ]

While we currently assume that regulators with no control available are
just uncontionally enabled this isn't always as clearly displayed to
users as is desirable, for example the code for disabling unused
regulators will log that it is about to disable them. Clean this up a
bit by setting always_on during constraint evaluation if we have no
available mechanism for controlling the regualtor so things that check
the constraint will do the right thing.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220325144637.1543496-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 80d2c29e09e6 ("regulator: core: Use ktime_get_boottime() to determine how long a regulator was off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3eae3aa5ad1d2..450aa0756dd8c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1521,6 +1521,24 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		}
 	}
 
+	/*
+	 * If there is no mechanism for controlling the regulator then
+	 * flag it as always_on so we don't end up duplicating checks
+	 * for this so much.  Note that we could control the state of
+	 * a supply to control the output on a regulator that has no
+	 * direct control.
+	 */
+	if (!rdev->ena_pin && !ops->enable) {
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+
+		if (rdev->supply)
+			rdev->constraints->always_on =
+				rdev->supply->rdev->constraints->always_on;
+		else
+			rdev->constraints->always_on = true;
+	}
+
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
-- 
2.39.2



