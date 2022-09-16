Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB805BAA98
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiIPKMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiIPKMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B8DFAD;
        Fri, 16 Sep 2022 03:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 062C1629E2;
        Fri, 16 Sep 2022 10:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5B0C433C1;
        Fri, 16 Sep 2022 10:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322976;
        bh=de0UWzH2KUXwSSVq/hNoyyVgaNRZRqOmYE7O8y8s+Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch3sq9aJzdkphSh/PATcXnWC9+hprqAcqv9DiH4cMf0LZItIrFNnXBxVqXgHCsB9K
         nqywvOWO+IMAVMS9W+QjOyDE09FA6FsISJT0KdXjV4sWrTWTDYs2mFpAMfPwlZPaHY
         khhYkLBOU6SxJzpsSWO7PRt4mbZyLQvg94TQ3UVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Tulli <greg.iforce@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/14] Input: iforce - add support for Boeder Force Feedback Wheel
Date:   Fri, 16 Sep 2022 12:08:13 +0200
Message-Id: <20220916100443.440363368@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
References: <20220916100443.123226979@linuxfoundation.org>
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



