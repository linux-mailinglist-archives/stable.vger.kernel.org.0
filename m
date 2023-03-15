Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77E46BB182
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjCOM2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjCOM1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:27:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC049CBE2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDFBA61D51
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBD5C433D2;
        Wed, 15 Mar 2023 12:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883211;
        bh=bSd5bfD4yYw/KciTPHFZ3Dfkdl9E6TZxHNUb7ggdWhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP64fTpinYwFqDsf4oG7vAMfxIsk3cLTOje2atBDEOaBnE6MoVbesMBJRIkpAJB/O
         95Sqdhgspm8kKp9y94h64dtXxM7n0B4g7PZL9yX5QDuuMtsoEhtW2j0A/kboERLtAe
         AIGslUtPDe4hxV7aK86ZW2mYeVLg6QwDXjinoGsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/145] regulator: core: Fix off-on-delay-us for always-on/boot-on regulators
Date:   Wed, 15 Mar 2023 13:11:46 +0100
Message-Id: <20230315115740.398331976@linuxfoundation.org>
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

From: Christian Kohlschütter <christian@kohlschutter.com>

[ Upstream commit 218320fec29430438016f88dd4fbebfa1b95ad8d ]

Regulators marked with "regulator-always-on" or "regulator-boot-on"
as well as an "off-on-delay-us", may run into cycling issues that are
hard to detect.

This is caused by the "last_off" state not being initialized in this
case.

Fix the "last_off" initialization by setting it to the current kernel
time upon initialization, regardless of always_on/boot_on state.

Signed-off-by: Christian Kohlschütter <christian@kohlschutter.com>
Link: https://lore.kernel.org/r/FAFD5B39-E9C4-47C7-ACF1-2A04CD59758D@kohlschutter.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 80d2c29e09e6 ("regulator: core: Use ktime_get_boottime() to determine how long a regulator was off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 450aa0756dd8c..c7b1e15bf7bb5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1539,6 +1539,9 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 			rdev->constraints->always_on = true;
 	}
 
+	if (rdev->desc->off_on_delay)
+		rdev->last_off = ktime_get();
+
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
@@ -1572,8 +1575,6 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 
 		if (rdev->constraints->always_on)
 			rdev->use_count++;
-	} else if (rdev->desc->off_on_delay) {
-		rdev->last_off = ktime_get();
 	}
 
 	print_constraints(rdev);
-- 
2.39.2



