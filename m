Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6418D68D7D1
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjBGNDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbjBGND2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173882707
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:03:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B728EB818E8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FA1C433EF;
        Tue,  7 Feb 2023 13:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775004;
        bh=YU4mVTEL2nKy5Kjh0ZcM9905a2UAaqdAfFjnQL2nGZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLimJvWnrE3HDHnem+QlIqpfSnLuBId6TLo7IYRLqq+NUssJyhNVILV4x2LJfMYeH
         sXZ1uCoNxp3SaSLrmHgY+B/N9szANi5Pl1P8cFH/YIP4mTbF1TrGLmkFuTQPg85x3l
         Ol8UeEoUxEYDvEmbhl4OddSgqE+X+QZo7BHdEpTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rishit Bansal <rishitbansal0@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/208] platform/x86: hp-wmi: Handle Omen Key event
Date:   Tue,  7 Feb 2023 13:55:59 +0100
Message-Id: <20230207125639.103502604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Rishit Bansal <rishitbansal0@gmail.com>

[ Upstream commit 3ee5447b2048c8389ed899838a40b40180d50906 ]

Add support to map the "HP Omen Key" to KEY_PROG2. Laptops in the HP
Omen Series open the HP Omen Command Center application on windows. But,
on linux it fails with the following message from the hp-wmi driver:

[ 5143.415714] hp_wmi: Unknown event_id - 29 - 0x21a5

Also adds support to map Fn+Esc to KEY_FN_ESC. This currently throws the
following message on the hp-wmi driver:

[ 6082.143785] hp_wmi: Unknown key code - 0x21a7

There is also a "Win-Lock" key on HP Omen Laptops which supports
Enabling and Disabling the Windows key, which trigger commands 0x21a4
and 0x121a4 respectively, but I wasn't able to find any KEY in input.h
to map this to.

Signed-off-by: Rishit Bansal <rishitbansal0@gmail.com>
Link: https://lore.kernel.org/r/20230120221214.24426-1-rishitbansal0@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 0a99058be813..4a3851332ef2 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -90,6 +90,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_OMEN_KEY			= 0x1D,
 	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
@@ -216,6 +217,8 @@ static const struct key_entry hp_wmi_keymap[] = {
 	{ KE_KEY, 0x213b,  { KEY_INFO } },
 	{ KE_KEY, 0x2169,  { KEY_ROTATE_DISPLAY } },
 	{ KE_KEY, 0x216a,  { KEY_SETUP } },
+	{ KE_KEY, 0x21a5,  { KEY_PROG2 } }, /* HP Omen Key */
+	{ KE_KEY, 0x21a7,  { KEY_FN_ESC } },
 	{ KE_KEY, 0x21a9,  { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY, 0x121a9, { KEY_TOUCHPAD_ON } },
 	{ KE_KEY, 0x231b,  { KEY_HELP } },
@@ -810,6 +813,7 @@ static void hp_wmi_notify(u32 value, void *context)
 	case HPWMI_SMART_ADAPTER:
 		break;
 	case HPWMI_BEZEL_BUTTON:
+	case HPWMI_OMEN_KEY:
 		key_code = hp_wmi_read_int(HPWMI_HOTKEY_QUERY);
 		if (key_code < 0)
 			break;
-- 
2.39.0



