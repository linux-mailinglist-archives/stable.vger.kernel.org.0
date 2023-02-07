Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA25868D7BE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjBGNDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjBGNCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E26539B8F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3D06140D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E2C433EF;
        Tue,  7 Feb 2023 13:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774947;
        bh=Y8+FvqjuBLDQ4TraZa3mKRi3X8JJScyTWNtADBTUAvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fF1UnpwFhcL1YKdBMR/Ua3Jl9JrqdAv2yi8W1FgGYGVtHyx1C1GL6dSEydcnEAkgc
         Pr87RExNLTd8u4FT2vey0LdjyLfNjFLAh9NyMDMk0KnVb6Y9gVEj67pCFJGuh4Z46h
         skmS/VEj9A6aosnFnRR3vVL3cPjPZh1LgRbKaSIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/208] platform/x86: thinkpad_acpi: Fix thinklight LED brightness returning 255
Date:   Tue,  7 Feb 2023 13:55:13 +0100
Message-Id: <20230207125636.959324715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eebf82012dddbdcb09e4e49d3cdfafb93bc66eb2 ]

Reading the thinklight LED brightnes while the LED is on returns
255 (LED_FULL) but we advertise a max_brightness of 1, so this should
be 1 (LED_ON).

Fixes: db5e2a4ca0a7 ("platform/x86: thinkpad_acpi: Fix max_brightness of thinklight")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230127235723.412864-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7fd735c67a8e..2a48a2d880d8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5566,7 +5566,7 @@ static int light_sysfs_set(struct led_classdev *led_cdev,
 
 static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 {
-	return (light_get_status() == 1) ? LED_FULL : LED_OFF;
+	return (light_get_status() == 1) ? LED_ON : LED_OFF;
 }
 
 static struct tpacpi_led_classdev tpacpi_led_thinklight = {
-- 
2.39.0



