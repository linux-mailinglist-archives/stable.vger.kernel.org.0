Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB00A630A21
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiKSCW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiKSCVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:21:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FDFC4B5E;
        Fri, 18 Nov 2022 18:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9502B82670;
        Sat, 19 Nov 2022 02:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F54FC433D6;
        Sat, 19 Nov 2022 02:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824087;
        bh=OSKBnjS0CLNwFCl54XfBSFAtollL0k1rDe7M1vayXpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bV2R90QR7lWuiQx88SZ2vVzJxx/m3EkloZJESC5OGkASocjUS8mBqtSPVuB59aiNw
         NrgoFBBrzvBbzeHwfQccxqvSrUmGXo76kqhgZd/6eOaCdeLwl2yBizKBCaz4R74im0
         JlevvOlJ3ZXJfBt0iMdB7YhODWKCHFTiMN1g6JNwHGJtPCsWjNMlqu8XhHFZwkBxqn
         dQt53hjv1BQK/m1q6iIJHq7yITd4/11Yx7IJXULgsDm0dbdXltxfi6jiLCMjQzP3iz
         v/WX+0AUQu9aK4V8wD59F9v/NH2TYfkazjSRAWmaJmjK5ZWt6WL1KwyyNv3ICvhKq5
         lEOPHDtrKPNvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ai Chao <aichao@kylinos.cn>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, ubizjak@gmail.com, wanjiabing@vivo.com,
        sdoregor@sdore.me, jussi@sonarnerd.net, john-linux@pelago.org.uk,
        cyrozap@gmail.com, connerknoxpublic@gmail.com, bp@suse.de,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 25/27] ALSA: usb-audio: add quirk to fix Hamedal C20 disconnect issue
Date:   Fri, 18 Nov 2022 21:13:50 -0500
Message-Id: <20221119021352.1774592-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ai Chao <aichao@kylinos.cn>

[ Upstream commit bf990c10231937c0f51e5da5558e08cf5adc6a78 ]

For Hamedal C20, the current rate is different from the runtime rate,
snd_usb_endpoint stop and close endpoint to resetting rate.
if snd_usb_endpoint close the endpoint, sometimes usb will
disconnect the device.

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Link: https://lore.kernel.org/r/20221110063452.295110-1-aichao@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 ++-
 sound/usb/quirks.c   | 2 ++
 sound/usb/usbaudio.h | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 3bbc227769d0..092350eb5f4e 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -887,7 +887,8 @@ void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 	usb_audio_dbg(chip, "Closing EP 0x%x (count %d)\n",
 		      ep->ep_num, ep->opened);
 
-	if (!--ep->iface_ref->opened)
+	if (!--ep->iface_ref->opened &&
+		!(chip->quirk_flags & QUIRK_FLAG_IFACE_SKIP_CLOSE))
 		endpoint_set_interface(chip, ep, false);
 
 	if (!--ep->opened) {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 879d8b1f301c..2ae9ad993ff4 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1884,6 +1884,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
+		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 39c3c61a7e49..ec06f441e890 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -169,6 +169,8 @@ extern bool snd_usb_skip_validation;
  *  Apply the generic implicit feedback sync mode (same as implicit_fb=1 option)
  * QUIRK_FLAG_SKIP_IMPLICIT_FB
  *  Don't apply implicit feedback sync mode
+ * QUIRK_FLAG_IFACE_SKIP_CLOSE
+ *  Don't closed interface during setting sample rate
  */
 
 #define QUIRK_FLAG_GET_SAMPLE_RATE	(1U << 0)
@@ -190,5 +192,6 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_SET_IFACE_FIRST	(1U << 16)
 #define QUIRK_FLAG_GENERIC_IMPLICIT_FB	(1U << 17)
 #define QUIRK_FLAG_SKIP_IMPLICIT_FB	(1U << 18)
+#define QUIRK_FLAG_IFACE_SKIP_CLOSE	(1U << 19)
 
 #endif /* __USBAUDIO_H */
-- 
2.35.1

