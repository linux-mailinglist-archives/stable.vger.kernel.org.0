Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADC4603DF2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiJSJIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiJSJGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:06:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171C132BA0;
        Wed, 19 Oct 2022 01:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A608661851;
        Wed, 19 Oct 2022 08:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CF0C433D6;
        Wed, 19 Oct 2022 08:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169890;
        bh=KZLGDxq2b8YQuHM9xefCYyopnh+ZS8Ky+2C9f3m/ckE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zlka5w8nTdL8knV9ELHneZZ6Yecbm+MOnox3I5PT0x/KR+vbvxPyuxJmbm7hu2g3C
         G80b3bBOIbuYp8bW5QDJ5bzI6Xo9bHf+OCPasoTzwRmHfhHHwajgoeq/XaGQQeuX/2
         ggA1OUW5u61qO4wsoDlxFCagGUvyuFHtFgq14QUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brent Lu <brent.lu@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 414/862] ALSA: hda/hdmi: Dont skip notification handling during PM operation
Date:   Wed, 19 Oct 2022 10:28:21 +0200
Message-Id: <20221019083308.256727435@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5226c7b9784eee215e3914f440b3c2e1764f67a8 ]

The HDMI driver skips the notification handling from the graphics
driver when the codec driver is being in the PM operation.  This
behavior was introduced by the commit eb399d3c99d8 ("ALSA: hda - Skip
ELD notification during PM process").  This skip may cause a problem,
as we may miss the ELD update when the connection/disconnection
happens right at the runtime-PM operation of the audio codec.

Although this workaround was valid at that time, it's no longer true;
the fix was required just because the ELD update procedure needed to
wake up the audio codec, which had lead to a runtime-resume during a
runtime-suspend.  Meanwhile, the ELD update procedure doesn't need a
codec wake up any longer since the commit 788d441a164c ("ALSA: hda -
Use component ops for i915 HDMI/DP audio jack handling"); i.e. there
is no much reason for skipping the notification.

Let's drop those checks for addressing the missing notification.

Fixes: 788d441a164c ("ALSA: hda - Use component ops for i915 HDMI/DP audio jack handling")
Reported-by: Brent Lu <brent.lu@intel.com>
Link: https://lore.kernel.org/r/20220927135807.4097052-1-brent.lu@intel.com
Link: https://lore.kernel.org/r/20221001074809.7461-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index d463c968b3a4..287f4f78e7b1 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2751,9 +2751,6 @@ static void generic_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	 */
 	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
-	/* ditto during suspend/resume process itself */
-	if (snd_hdac_is_in_pm(&codec->core))
-		return;
 
 	check_presence_and_report(codec, pin_nid, dev_id);
 }
@@ -2937,9 +2934,6 @@ static void intel_pin_eld_notify(void *audio_ptr, int port, int pipe)
 	 */
 	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
-	/* ditto during suspend/resume process itself */
-	if (snd_hdac_is_in_pm(&codec->core))
-		return;
 
 	snd_hdac_i915_set_bclk(&codec->bus->core);
 	check_presence_and_report(codec, pin_nid, dev_id);
-- 
2.35.1



