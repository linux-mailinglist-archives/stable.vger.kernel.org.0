Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679FD5B4A24
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiIJV1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiIJV00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:26:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E8E4F649;
        Sat, 10 Sep 2022 14:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 404B3CE0AF6;
        Sat, 10 Sep 2022 21:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDBBC433D6;
        Sat, 10 Sep 2022 21:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844796;
        bh=uASbzskNgxAg+HPPH5Q5UI7OXq1oofkIiy+UyhNuo7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Riu56QS0EbzU/Or8GA0j4DmcdLOLYskvb3HphiPZkx5YPxmX5fP63lNFNtx1Zit3i
         clPVwEY/Ybu+95dP/DVXQmdPmahjEGgn1ffgqS/QjD2tYYeFj5J66Rksz3GWxs9cgy
         ZLLjEzT5hh0Pv1zJdCrUNWb9LIDcIRuOv7cTi9Pih/Vly6ZsF2VbUxMxsWLLz+8lKJ
         daDW1FD5NNwTQc5MutsyerHHDk00ncKDmaqdyku37A/u4D78xuukxD/Iwr9AB6C1u8
         2bFigGxjEYyTS8DUYSaADx5yc/BrFU837sWp74JhOavfTgiqv8xgqCj6PQCIvhqYki
         SSwwyYkD0d8vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jlee@suse.com,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/5] platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes
Date:   Sat, 10 Sep 2022 17:19:47 -0400
Message-Id: <20220910211947.71066-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211947.71066-1-sashal@kernel.org>
References: <20220910211947.71066-1-sashal@kernel.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c3b82d26bc85f5fc2fef5ec8cce17c89633a55a8 ]

2 keymap fixes for the Acer Aspire One AOD270 and the same hardware
rebranded as Packard Bell Dot SC:

1. The F2 key is marked with a big '?' symbol on the Packard Bell Dot SC,
this sends WMID_HOTKEY_EVENTs with a scancode of 0x27 add a mapping
for this.

2. Scancode 0x61 is KEY_SWITCHVIDEOMODE. Usually this is a duplicate
input event with the "Video Bus" input device events. But on these devices
the "Video Bus" does not send events for this key. Map 0x61 to KEY_UNKNOWN
instead of using KE_IGNORE so that udev/hwdb can override it on these devs.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220829163544.5288-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index ec3cbb7844bce..c10b97c91f3cc 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -105,6 +105,7 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x27, {KEY_HELP} },
 	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
@@ -118,7 +119,13 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_IGNORE, 0x48, {KEY_VOLUMEUP} },
 	{KE_IGNORE, 0x49, {KEY_VOLUMEDOWN} },
 	{KE_IGNORE, 0x4a, {KEY_VOLUMEDOWN} },
-	{KE_IGNORE, 0x61, {KEY_SWITCHVIDEOMODE} },
+	/*
+	 * 0x61 is KEY_SWITCHVIDEOMODE. Usually this is a duplicate input event
+	 * with the "Video Bus" input device events. But sometimes it is not
+	 * a dup. Map it to KEY_UNKNOWN instead of using KE_IGNORE so that
+	 * udev/hwdb can override it on systems where it is not a dup.
+	 */
+	{KE_KEY, 0x61, {KEY_UNKNOWN} },
 	{KE_IGNORE, 0x62, {KEY_BRIGHTNESSUP} },
 	{KE_IGNORE, 0x63, {KEY_BRIGHTNESSDOWN} },
 	{KE_KEY, 0x64, {KEY_SWITCHVIDEOMODE} },	/* Display Switch */
-- 
2.35.1

