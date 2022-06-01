Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1053A78B
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354175AbiFAOCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354917AbiFAOBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A434E3A0;
        Wed,  1 Jun 2022 06:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D67B615B9;
        Wed,  1 Jun 2022 13:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAB2C385A5;
        Wed,  1 Jun 2022 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091807;
        bh=fDG575ttLgWbeLrePzoV7rDswfiDL4S0LUn1GVNsufA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQ3ibUjysyhYFRwV0Xdo/ZvgJW06POU12BPuSAqHblDT8U4+u+qwnk1MeWGFyuQIH
         eJIl5oJBWB8OYelPoS2crGdR0Tz5/MjP/g5eVu/MlCTyIPQFXc7ae2IQ3zXTdqkQnU
         CPRuI5c9RtEBKgh0cMhwkYnU3EAmCcVWOpEVuGBVkpbzn3pMXwPJt3upolw8Ov1idB
         Z5YEhqHze6YorwWPsPw1mRIlnyFgX+owRw1kztDTCeC4FX9pkqKJNZCdiUJYvMy23R
         WsVFnOSO+2A0oMwQjnFHeeOUyRj9baC9FkagqQukVDbz/P7A8gF/GdtM8Vx2SUBgPz
         ruXI8LWO6YIsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, corbet@lwn.net,
        geraldogabriel@gmail.com, matteomartelli3@gmail.com, bp@suse.de,
        alsa-devel@alsa-project.org, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/37] ALSA: usb-audio: Add quirk bits for enabling/disabling generic implicit fb
Date:   Wed,  1 Jun 2022 09:55:58 -0400
Message-Id: <20220601135622.2003939-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0f1f7a6661394fe4a53db254c346d6aa2dd64397 ]

For making easier to test, add the new quirk_flags bits 17 and 18 to
enable and disable the generic implicit feedback mode.  The bit 17 is
equivalent with implicit_fb=1 option, applying the generic implicit
feedback sync mode.  OTOH, the bit 18 disables the implicit fb mode
forcibly.

Link: https://lore.kernel.org/r/20220421064101.12456-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/alsa-configuration.rst | 4 +++-
 sound/usb/implicit.c                       | 5 ++++-
 sound/usb/usbaudio.h                       | 6 ++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/sound/alsa-configuration.rst b/Documentation/sound/alsa-configuration.rst
index 65f61695f561..5d093fb4896b 100644
--- a/Documentation/sound/alsa-configuration.rst
+++ b/Documentation/sound/alsa-configuration.rst
@@ -2237,7 +2237,7 @@ implicit_fb
     Apply the generic implicit feedback sync mode.  When this is set
     and the playback stream sync mode is ASYNC, the driver tries to
     tie an adjacent ASYNC capture stream as the implicit feedback
-    source.
+    source.  This is equivalent with quirk_flags bit 17.
 use_vmalloc
     Use vmalloc() for allocations of the PCM buffers (default: yes).
     For architectures with non-coherent memory like ARM or MIPS, the
@@ -2279,6 +2279,8 @@ quirk_flags
         * bit 14: Ignore errors for mixer access
         * bit 15: Support generic DSD raw U32_BE format
         * bit 16: Set up the interface at first like UAC1
+        * bit 17: Apply the generic implicit feedback sync mode
+        * bit 18: Don't apply implicit feedback sync mode
 
 This module supports multiple devices, autoprobe and hotplugging.
 
diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index 2d444ec74202..1fd087128538 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -350,7 +350,8 @@ static int audioformat_implicit_fb_quirk(struct snd_usb_audio *chip,
 	}
 
 	/* Try the generic implicit fb if available */
-	if (chip->generic_implicit_fb)
+	if (chip->generic_implicit_fb ||
+	    (chip->quirk_flags & QUIRK_FLAG_GENERIC_IMPLICIT_FB))
 		return add_generic_implicit_fb(chip, fmt, alts);
 
 	/* No quirk */
@@ -387,6 +388,8 @@ int snd_usb_parse_implicit_fb_quirk(struct snd_usb_audio *chip,
 				    struct audioformat *fmt,
 				    struct usb_host_interface *alts)
 {
+	if (chip->quirk_flags & QUIRK_FLAG_SKIP_IMPLICIT_FB)
+		return 0;
 	if (fmt->endpoint & USB_DIR_IN)
 		return audioformat_capture_quirk(chip, fmt, alts);
 	else
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index b8359a0aa008..044cd7ab27cb 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -164,6 +164,10 @@ extern bool snd_usb_skip_validation;
  *  Support generic DSD raw U32_BE format
  * QUIRK_FLAG_SET_IFACE_FIRST:
  *  Set up the interface at first like UAC1
+ * QUIRK_FLAG_GENERIC_IMPLICIT_FB
+ *  Apply the generic implicit feedback sync mode (same as implicit_fb=1 option)
+ * QUIRK_FLAG_SKIP_IMPLICIT_FB
+ *  Don't apply implicit feedback sync mode
  */
 
 #define QUIRK_FLAG_GET_SAMPLE_RATE	(1U << 0)
@@ -183,5 +187,7 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_IGNORE_CTL_ERROR	(1U << 14)
 #define QUIRK_FLAG_DSD_RAW		(1U << 15)
 #define QUIRK_FLAG_SET_IFACE_FIRST	(1U << 16)
+#define QUIRK_FLAG_GENERIC_IMPLICIT_FB	(1U << 17)
+#define QUIRK_FLAG_SKIP_IMPLICIT_FB	(1U << 18)
 
 #endif /* __USBAUDIO_H */
-- 
2.35.1

