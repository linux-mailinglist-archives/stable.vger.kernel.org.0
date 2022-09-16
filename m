Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5265BAB42
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiIPKPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiIPKOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933B9AE84E;
        Fri, 16 Sep 2022 03:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07AA5B82524;
        Fri, 16 Sep 2022 10:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E6CC433C1;
        Fri, 16 Sep 2022 10:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323031;
        bh=r3AOt/UinTmkKytVgah9WWipiOgfRN/VZBI8HsmGJPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0f46L+5iunNc1T5VdmWYOEBNxSGjR2V4q8Hsb0TTdaUcfOdHBfMOUEGvw7+pLkbF
         yJjdKw3PcEWQW9BnbJjOqLaatCuEhQaCurut3oGRSpFti9Utw85cwqmpfH/qivh8LO
         vaVT9BlPfzdyw8tYDfMKdYp//KYknPRTlzFZXkPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/24] platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes
Date:   Fri, 16 Sep 2022 12:08:42 +0200
Message-Id: <20220916100446.131483054@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
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
index 80983f9dfcd55..8e696262215fc 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -93,6 +93,7 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
 	{KE_KEY, 0x22, {KEY_PROG2} },    /* Arcade */
 	{KE_KEY, 0x23, {KEY_PROG3} },    /* P_Key */
 	{KE_KEY, 0x24, {KEY_PROG4} },    /* Social networking_Key */
+	{KE_KEY, 0x27, {KEY_HELP} },
 	{KE_KEY, 0x29, {KEY_PROG3} },    /* P_Key for TM8372 */
 	{KE_IGNORE, 0x41, {KEY_MUTE} },
 	{KE_IGNORE, 0x42, {KEY_PREVIOUSSONG} },
@@ -106,7 +107,13 @@ static const struct key_entry acer_wmi_keymap[] __initconst = {
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



