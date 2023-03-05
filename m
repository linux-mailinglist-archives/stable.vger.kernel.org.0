Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA7F6AB03E
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCENyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCENxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:53:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C71FD324;
        Sun,  5 Mar 2023 05:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21484B80ACD;
        Sun,  5 Mar 2023 13:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95953C433D2;
        Sun,  5 Mar 2023 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024383;
        bh=rNnKoxtrwII7gaLBt/qbpPHMj5ZrIIp7yTY30wXIaeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeR0yPLRxWvGTgVE2fUIEWbwzuOPlZaSsUKm4lsA1AnhL5XQlW6EmKiVPmlAVG32I
         y3yyBf04MkUr0p3X41wCrBWoyrzG0IvHQ9izz21i7vLpLmEq6kIYBbGkiePjNctUYp
         vhmOu3anma+lUHBlG5sSdCT9K/CWdLuaXiVb0tJUETbfkDUrRUtF3HPykZ1+gMGq7d
         w2OqxwlAOHXvvdKieQUeP1f7DelkF7drAgTawKDls4byA4N+j2gS4UMZ8nsR6dsutk
         9wWqG9kso4t7lnrFo5lDlYfkHssHCHNLOknZZixLfgt6gaccYV1ZqNroWK/qu53F0g
         //UQ3xdlAQ2Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, benh@kernel.crashing.org,
        ndesaulniers@google.com, u.kleine-koenig@pengutronix.de,
        peter.senna@gmail.com, benjamin.mugnier@foss.st.com,
        heikki.krogerus@linux.intel.com, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.2 14/16] macintosh: windfarm: Use unsigned type for 1-bit bitfields
Date:   Sun,  5 Mar 2023 08:52:05 -0500
Message-Id: <20230305135207.1793266-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 24f0a444d3122..9c6febce2376b 100644
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

