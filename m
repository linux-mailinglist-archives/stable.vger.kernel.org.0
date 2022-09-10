Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0890C5B4A50
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiIJVhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiIJVgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CBA27167;
        Sat, 10 Sep 2022 14:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE492B80954;
        Sat, 10 Sep 2022 21:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE0C433D7;
        Sat, 10 Sep 2022 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844756;
        bh=de0UWzH2KUXwSSVq/hNoyyVgaNRZRqOmYE7O8y8s+Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLmBLD4cfhfBHi3kIvfB7ETjSi5oun8eaG5ROaMTftQhF5gTx1jpczueZf+SiCni0
         ej+OsziGhbG+IqmwOlZTHkKu46o/JoeXPPkj/5t9Jnby6bjG9DUAvAf5lRuZVHFCqJ
         9CoQGqgwV0VJIqYYMH60DI39NQ+sbxRG/Z/lu41qmSNCl3fZL3xXJ3U0NmctGIqyaW
         LC7lQDkyrCwh4V0XsoKKdUQ8Nb7gyvQjGCuuLX+YtEX/HnvD7S0ZkDV2lSL9QO5oX+
         836fjogQ8viucVFYebOP7yKNCOh2+mjtUt5r/Zg8WGfX9+2fmYBUVnfl5v3e/LK15M
         1yw2MRXm7IYHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Tulli <greg.iforce@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, corbet@lwn.net,
        linux-input@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/10] Input: iforce - add support for Boeder Force Feedback Wheel
Date:   Sat, 10 Sep 2022 17:18:57 -0400
Message-Id: <20220910211901.70760-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211901.70760-1-sashal@kernel.org>
References: <20220910211901.70760-1-sashal@kernel.org>
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

From: Greg Tulli <greg.iforce@gmail.com>

[ Upstream commit 9c9c71168f7979f3798b61c65b4530fbfbcf19d1 ]

Add a new iforce_device entry to support the Boeder Force Feedback Wheel
device.

Signed-off-by: Greg Tulli <greg.iforce@gmail.com>
Link: https://lore.kernel.org/r/3256420-c8ac-31b-8499-3c488a9880fd@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/input/joydev/joystick.rst     | 1 +
 drivers/input/joystick/iforce/iforce-main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/input/joydev/joystick.rst b/Documentation/input/joydev/joystick.rst
index 9746fd76cc581..f38c330c028e5 100644
--- a/Documentation/input/joydev/joystick.rst
+++ b/Documentation/input/joydev/joystick.rst
@@ -517,6 +517,7 @@ All I-Force devices are supported by the iforce module. This includes:
 * AVB Mag Turbo Force
 * AVB Top Shot Pegasus
 * AVB Top Shot Force Feedback Racing Wheel
+* Boeder Force Feedback Wheel
 * Logitech WingMan Force
 * Logitech WingMan Force Wheel
 * Guillemot Race Leader Force Feedback
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index b2a68bc9f0b4d..b86de1312512b 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -50,6 +50,7 @@ static struct iforce_device iforce_device[] = {
 	{ 0x046d, 0xc291, "Logitech WingMan Formula Force",		btn_wheel, abs_wheel, ff_iforce },
 	{ 0x05ef, 0x020a, "AVB Top Shot Pegasus",			btn_joystick_avb, abs_avb_pegasus, ff_iforce },
 	{ 0x05ef, 0x8884, "AVB Mag Turbo Force",			btn_wheel, abs_wheel, ff_iforce },
+	{ 0x05ef, 0x8886, "Boeder Force Feedback Wheel",		btn_wheel, abs_wheel, ff_iforce },
 	{ 0x05ef, 0x8888, "AVB Top Shot Force Feedback Racing Wheel",	btn_wheel, abs_wheel, ff_iforce }, //?
 	{ 0x061c, 0xc0a4, "ACT LABS Force RS",                          btn_wheel, abs_wheel, ff_iforce }, //?
 	{ 0x061c, 0xc084, "ACT LABS Force RS",				btn_wheel, abs_wheel, ff_iforce },
-- 
2.35.1

