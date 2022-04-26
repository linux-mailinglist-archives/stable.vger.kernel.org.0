Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9503B50F869
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346839AbiDZJMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347911AbiDZJGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85710B6D2A;
        Tue, 26 Apr 2022 01:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E43B81CFA;
        Tue, 26 Apr 2022 08:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E103C385A0;
        Tue, 26 Apr 2022 08:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962827;
        bh=Uqzo4aS6TNprJWj68XNn/CE1eaZRoWCWRUpdM3puHN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3IHA2KaT2Nloqd9fMdYUsfvCf2jI9Q8vWPDx5naVp2rGxSpaEksB5/0m6X09Ialg
         pnrYH+r+lsYfXOmGj9ede8kwE8BMH50m5aQZR5tBxVCGspQ5l258HbTADdccYkCaSB
         vn9RRfXbErHsm1PqXjM1OmIeMYYR+KHEw5Pit7Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 063/146] platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative
Date:   Tue, 26 Apr 2022 10:20:58 +0200
Message-Id: <20220426081751.836722859@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index c1d9ed9b7b67..19f6b456234f 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1121,8 +1121,6 @@ static void kbd_led_set(struct led_classdev *led_cdev,
 
 	if (value > samsung->kbd_led.max_brightness)
 		value = samsung->kbd_led.max_brightness;
-	else if (value < 0)
-		value = 0;
 
 	samsung->kbd_led_wk = value;
 	queue_work(samsung->led_workqueue, &samsung->kbd_led_work);
-- 
2.35.1



