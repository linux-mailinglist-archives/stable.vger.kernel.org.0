Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8E5078C2
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357063AbiDSSZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357522AbiDSSX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4910443EB;
        Tue, 19 Apr 2022 11:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93F3B6142D;
        Tue, 19 Apr 2022 18:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF2CC385A9;
        Tue, 19 Apr 2022 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392190;
        bh=XO+htxcasVjIz8LtHd+6NBfz45Ayc74nohNSB2FcCHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hddHEmOSU6/eDTpODG4exrqDH/spA72YVO6sok7Pk80hOf/m6UYG3Kav+jttF/7Oo
         TbncXzvU62lIKWv/1/IYpmgdMtJX9FvaUZXImfTlS+Ki00OXiTiawZ2hasM+7rjBTg
         7ikvPA5qTl6+ChC0V5EW66uEzkoCZCcd/zjuNX5IaalVJ04npUbf0ndBcu7RkAmHbi
         P/93PV7ImHOISjW0MUrv5mOBq5lbGfc3Skm6osLmPFtEO0/cURGpZQU4d9O4vRkx5Y
         G4Uy/nOcCJjALdGnUzsobERHz8Yt8BF0Ed9FvG2Dc/bDSPyuJUCdKZ3zGN77fyoLoc
         p3FEzK4zkmveQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/7] platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative
Date:   Tue, 19 Apr 2022 14:16:20 -0400
Message-Id: <20220419181625.486476-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181625.486476-1-sashal@kernel.org>
References: <20220419181625.486476-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 0284d4d1be753f648f28b77bdfbe6a959212af5c ]

Eliminate the follow smatch warnings:

drivers/platform/x86/samsung-laptop.c:1124 kbd_led_set() warn: unsigned
'value' is never less than zero.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220322061830.105579-1-jiapeng.chong@linux.alibaba.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/samsung-laptop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 8c146e2b6727..4664d3e191c8 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1125,8 +1125,6 @@ static void kbd_led_set(struct led_classdev *led_cdev,
 
 	if (value > samsung->kbd_led.max_brightness)
 		value = samsung->kbd_led.max_brightness;
-	else if (value < 0)
-		value = 0;
 
 	samsung->kbd_led_wk = value;
 	queue_work(samsung->led_workqueue, &samsung->kbd_led_work);
-- 
2.35.1

