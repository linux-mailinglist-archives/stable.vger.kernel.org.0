Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B87A60AA45
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiJXNb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbiJXNaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D17ACA1C;
        Mon, 24 Oct 2022 05:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F008D612B7;
        Mon, 24 Oct 2022 12:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A404C433C1;
        Mon, 24 Oct 2022 12:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614200;
        bh=bcTlmWggIuPQ8HO7zwA8/78P0DFAZJDywhOf4ZdCjKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t33qF3mGwEviFK6jDzmKW+lnq1xgL99vYkTYNQo4S1WffoqEchwhJxSN3a9gj5L5q
         JcO76opZx/t8SFR4ioJWxtQQxXhpnsWGpTtCfcKsdscUJM87eC6625XZTUgeu+cVzo
         rMwbEq9tDiSD8wwE4vCOg6hZq6YlhSCYcyYt9Fj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brent Lu <brent.lu@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/390] ALSA: hda/hdmi: Dont skip notification handling during PM operation
Date:   Mon, 24 Oct 2022 13:29:27 +0200
Message-Id: <20221024113029.943996740@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c3fcf478037f..b1c57c65f6cd 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2684,9 +2684,6 @@ static void generic_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	 */
 	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
 		return;
-	/* ditto during suspend/resume process itself */
-	if (snd_hdac_is_in_pm(&codec->core))
-		return;
 
 	check_presence_and_report(codec, pin_nid, dev_id);
 }
@@ -2870,9 +2867,6 @@ static void intel_pin_eld_notify(void *audio_ptr, int port, int pipe)
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



