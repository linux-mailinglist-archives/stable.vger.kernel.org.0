Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E84F2583
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiDEHuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiDEHrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B3C13F97;
        Tue,  5 Apr 2022 00:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54CEACE1BF0;
        Tue,  5 Apr 2022 07:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BC9C340EE;
        Tue,  5 Apr 2022 07:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144631;
        bh=n+BFEzwOApYau1OiRTnqO3M1ncuHVMLsMx7/cfFVaHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5k68wUKq/np2ZH1R+XOOYT9FoESx6/ebvzBEwlxZqsDG+PvjHQVt/CnV9q4NzZor
         THzTefW2kVJv4zgjDZw4Na1y3z72CabqIUOF5c7nWMN/d52wRKmFOhO5+2u7HcLZ6z
         IIoF0AnTSzUjbKQg69Bs7CGSbafoMb79ULcuKYTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mohan Kumar <mkumard@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 0097/1126] ALSA: hda: Avoid unsol event during RPM suspending
Date:   Tue,  5 Apr 2022 09:14:04 +0200
Message-Id: <20220405070410.416023633@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mohan Kumar <mkumard@nvidia.com>

commit 6ddc2f749621d5d45ca03edc9f0616bcda136d29 upstream.

There is a corner case with unsol event handling during codec runtime
suspending state. When the codec runtime suspend call initiated, the
codec->in_pm atomic variable would be 0, currently the codec runtime
suspend function calls snd_hdac_enter_pm() which will just increments
the codec->in_pm atomic variable. Consider unsol event happened just
after this step and before snd_hdac_leave_pm() in the codec runtime
suspend function. The snd_hdac_power_up_pm() in the unsol event
flow in hdmi_present_sense_via_verbs() function would just increment
the codec->in_pm atomic variable without calling pm_runtime_get_sync
function.

As codec runtime suspend flow is already in progress and in parallel
unsol event is also accessing the codec verbs, as soon as codec
suspend flow completes and clocks are  switched off before completing
the unsol event handling as both functions doesn't wait for each other.
This will result in below errors

[  589.428020] tegra-hda 3510000.hda: azx_get_response timeout, switching
to polling mode: last cmd=0x505f2f57
[  589.428344] tegra-hda 3510000.hda: spurious response 0x80000074:0x5,
last cmd=0x505f2f57
[  589.428547] tegra-hda 3510000.hda: spurious response 0x80000065:0x5,
last cmd=0x505f2f57

To avoid this, the unsol event flow should not perform any codec verb
related operations during RPM_SUSPENDING state.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220329155940.26331-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1617,6 +1617,7 @@ static void hdmi_present_sense_via_verbs
 	struct hda_codec *codec = per_pin->codec;
 	struct hdmi_spec *spec = codec->spec;
 	struct hdmi_eld *eld = &spec->temp_eld;
+	struct device *dev = hda_codec_dev(codec);
 	hda_nid_t pin_nid = per_pin->pin_nid;
 	int dev_id = per_pin->dev_id;
 	/*
@@ -1630,8 +1631,13 @@ static void hdmi_present_sense_via_verbs
 	int present;
 	int ret;
 
+#ifdef	CONFIG_PM
+	if (dev->power.runtime_status == RPM_SUSPENDING)
+		return;
+#endif
+
 	ret = snd_hda_power_up_pm(codec);
-	if (ret < 0 && pm_runtime_suspended(hda_codec_dev(codec)))
+	if (ret < 0 && pm_runtime_suspended(dev))
 		goto out;
 
 	present = snd_hda_jack_pin_sense(codec, pin_nid, dev_id);


