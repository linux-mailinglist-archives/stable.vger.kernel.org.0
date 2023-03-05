Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBF56AB04D
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCENyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCENyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EA7DBF8;
        Sun,  5 Mar 2023 05:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24D1260A54;
        Sun,  5 Mar 2023 13:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3459EC433D2;
        Sun,  5 Mar 2023 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024436;
        bh=BpYzRbUO6+QDTYmGgfCuetgduaiwpCv1hdivX+XNe7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFVhP4uHQbAdimecEV2R3oCsi26Zc/M9gZducDgxsDU+9fRMXbJRpEtrxCIYiIVRa
         AS6f2aE9mf9b4jC51ytw+m74fhZNAqU4LdvD9AKhrl8whGfrEGEGMnx1hVJhmpzvMn
         bGoja31t/kko6EWV5L1yuVWufbFk75jEdmO/13T3rSfvJWzhzZBCgPs2X0oYWnS2wg
         2xTpeOgIoHxPpONtlceGoCsKASJIcN9q45v1p/Fxi4osue+VewL4hayHDvgBfG/G8H
         RBhQmS7GiThMxjyrJ+5Axv7Su62Cqbu1qIo0t9jynLcfoVdDqXgW0XjXQ/3ZnLojOQ
         RjtmBm3mZM1ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        ndesaulniers@google.com, u.kleine-koenig@pengutronix.de,
        luzmaximilian@gmail.com, cminyard@mvista.com, ajayg@nvidia.com,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 13/15] macintosh: windfarm: Use unsigned type for 1-bit bitfields
Date:   Sun,  5 Mar 2023 08:53:04 -0500
Message-Id: <20230305135306.1793564-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135306.1793564-1-sashal@kernel.org>
References: <20230305135306.1793564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 748ea32d2dbd813d3bd958117bde5191182f909a ]

Clang warns:

  drivers/macintosh/windfarm_lm75_sensor.c:63:14: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
                  lm->inited = 1;
                             ^ ~

  drivers/macintosh/windfarm_smu_sensors.c:356:19: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
                  pow->fake_volts = 1;
                                  ^ ~
  drivers/macintosh/windfarm_smu_sensors.c:368:18: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
                  pow->quadratic = 1;
                                 ^ ~

There is no bug here since no code checks the actual value of these
fields, just whether or not they are zero (boolean context), but this
can be easily fixed by switching to an unsigned type.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230215-windfarm-wsingle-bit-bitfield-constant-conversion-v1-1-26415072e855@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/windfarm_lm75_sensor.c | 4 ++--
 drivers/macintosh/windfarm_smu_sensors.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 204661c8e918f..9dd80837a759a 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -33,8 +33,8 @@
 #endif
 
 struct wf_lm75_sensor {
-	int			ds1775 : 1;
-	int			inited : 1;
+	unsigned int		ds1775 : 1;
+	unsigned int		inited : 1;
 	struct i2c_client	*i2c;
 	struct wf_sensor	sens;
 };
diff --git a/drivers/macintosh/windfarm_smu_sensors.c b/drivers/macintosh/windfarm_smu_sensors.c
index 00c6fe25fcba0..2bdb73b34d291 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -274,8 +274,8 @@ struct smu_cpu_power_sensor {
 	struct list_head	link;
 	struct wf_sensor	*volts;
 	struct wf_sensor	*amps;
-	int			fake_volts : 1;
-	int			quadratic : 1;
+	unsigned int		fake_volts : 1;
+	unsigned int		quadratic : 1;
 	struct wf_sensor	sens;
 };
 #define to_smu_cpu_power(c) container_of(c, struct smu_cpu_power_sensor, sens)
-- 
2.39.2

