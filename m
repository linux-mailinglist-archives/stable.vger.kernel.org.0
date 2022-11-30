Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184E763DF2E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiK3Soy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiK3So2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:44:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4066B1B9C0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:44:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D98B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AD4C433D6;
        Wed, 30 Nov 2022 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833859;
        bh=r+B8sPmi2G10vvNEWxZDdJ5PUAzVT8B8GDLh1goIo6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSF8cKpjWeUsQBYyjSq04kXR7cgaPvxwdIB/6SUyuZbEMXiso5QC+IACwJCATLmPb
         JlgVcHhJH5JDyfv5vT5Un9r0QZaZTnK6ZkvcsUEJfvMwDdbGD67g7axPyto9rmNymR
         Q12D4TShjnYsAMIutGVs23ufjPMVGzrr3jPcSv80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ai Chao <aichao@kylinos.cn>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 040/289] ALSA: usb-audio: add quirk to fix Hamedal C20 disconnect issue
Date:   Wed, 30 Nov 2022 19:20:25 +0100
Message-Id: <20221130180545.040864471@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index 2420dc994632..4c9ea13f72d4 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -923,7 +923,8 @@ void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 	usb_audio_dbg(chip, "Closing EP 0x%x (count %d)\n",
 		      ep->ep_num, ep->opened);
 
-	if (!--ep->iface_ref->opened)
+	if (!--ep->iface_ref->opened &&
+		!(chip->quirk_flags & QUIRK_FLAG_IFACE_SKIP_CLOSE))
 		endpoint_set_interface(chip, ep, false);
 
 	if (!--ep->opened) {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 250bda7cda07..4f914dce6bbf 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2186,6 +2186,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
+		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 2c6575029b1c..e97141ef730a 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -170,6 +170,8 @@ extern bool snd_usb_skip_validation;
  *  Apply the generic implicit feedback sync mode (same as implicit_fb=1 option)
  * QUIRK_FLAG_SKIP_IMPLICIT_FB
  *  Don't apply implicit feedback sync mode
+ * QUIRK_FLAG_IFACE_SKIP_CLOSE
+ *  Don't closed interface during setting sample rate
  */
 
 #define QUIRK_FLAG_GET_SAMPLE_RATE	(1U << 0)
@@ -191,5 +193,6 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_SET_IFACE_FIRST	(1U << 16)
 #define QUIRK_FLAG_GENERIC_IMPLICIT_FB	(1U << 17)
 #define QUIRK_FLAG_SKIP_IMPLICIT_FB	(1U << 18)
+#define QUIRK_FLAG_IFACE_SKIP_CLOSE	(1U << 19)
 
 #endif /* __USBAUDIO_H */
-- 
2.35.1



