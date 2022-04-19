Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1719507892
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357132AbiDSSZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357244AbiDSSWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:22:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5843EA86;
        Tue, 19 Apr 2022 11:15:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B0C60E07;
        Tue, 19 Apr 2022 18:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3B3C385A9;
        Tue, 19 Apr 2022 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392133;
        bh=JrTg5TVja6fp8tRt+hMunCtik+nRg8374/t6ZUaDplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2aj9MvWWdk1Dg4hG/6Vq8f75m4z5o5KupQl5cJomPQaIuK58Jfx4f65AajFF8aro
         HSb12RrW7YbnGMxjvS9klCyxD6pCvP9bSA6Gthb6ONipjBszRp4Y03p2qoAM9uYzsn
         gahsqyTwoQ6HCfR2pg4YESvwgo95ADhIRPfQVshYGxRdxDTSfPWw7hXUrYikXXtF0Z
         sWIYv5TJ0WYay6QGV/duYlLFogQXfZmTd5B5Bw5Y+ybNjfSzvbB4AW+05bwHwavoLG
         4ScgeTsTo9Ps5Zis+x5p2C9gfmPv3Ewc/KXZv74hIEPB+sHfULSU5vwTBlTFfTzOmv
         lmP4k5+V2Rpkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/12] platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative
Date:   Tue, 19 Apr 2022 14:15:16 -0400
Message-Id: <20220419181525.486166-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181525.486166-1-sashal@kernel.org>
References: <20220419181525.486166-1-sashal@kernel.org>
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
index 7b160ee98115..3e66be504a0d 100644
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

