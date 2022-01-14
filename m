Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F183B48E63F
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiANIZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:25:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33374 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237904AbiANIXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:23:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C16D61E47;
        Fri, 14 Jan 2022 08:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42531C36AE9;
        Fri, 14 Jan 2022 08:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148582;
        bh=NnOyuba6l82M94bGQAATXauFmTaOA9YOgogUdTNMgw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYcpY0WQVoAzkfUtvmzNKvVXOLf8PB8fy5FwY8BPsA/Aeefc0FnOgVMciADqUQWcg
         KN1df6nJ4C7rJm7ZFkd80FKYoPl2WDr+RfubT75h2J/w03A5vBRGgc/UlP9wR5N3+C
         B2Aw4dAPkS+gVldYm3EeaLekI6D+qboSx4tmMJDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.16 36/37] staging: greybus: fix stack size warning with UBSAN
Date:   Fri, 14 Jan 2022 09:16:50 +0100
Message-Id: <20220114081546.027956854@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 144779edf598e0896302c35a0926ef0b68f17c4b upstream.

clang warns about excessive stack usage in this driver when
UBSAN is enabled:

drivers/staging/greybus/audio_topology.c:977:12: error: stack frame size of 1836 bytes in function 'gbaudio_tplg_create_widget' [-Werror,-Wframe-larger-than=]

Rework this code to no longer use compound literals for
initializing the structure in each case, but instead keep
the common bits in a preallocated constant array and copy
them as needed.

Link: https://github.com/ClangBuiltLinux/linux/issues/1535
Link: https://lore.kernel.org/r/20210103223541.2790855-1-arnd@kernel.org/
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[nathan: Address review comments from v1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20211209195141.1165233-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/audio_topology.c |   92 +++++++++++++++----------------
 1 file changed, 45 insertions(+), 47 deletions(-)

--- a/drivers/staging/greybus/audio_topology.c
+++ b/drivers/staging/greybus/audio_topology.c
@@ -974,6 +974,44 @@ static int gbaudio_widget_event(struct s
 	return ret;
 }
 
+static const struct snd_soc_dapm_widget gbaudio_widgets[] = {
+	[snd_soc_dapm_spk]	= SND_SOC_DAPM_SPK(NULL, gbcodec_event_spk),
+	[snd_soc_dapm_hp]	= SND_SOC_DAPM_HP(NULL, gbcodec_event_hp),
+	[snd_soc_dapm_mic]	= SND_SOC_DAPM_MIC(NULL, gbcodec_event_int_mic),
+	[snd_soc_dapm_output]	= SND_SOC_DAPM_OUTPUT(NULL),
+	[snd_soc_dapm_input]	= SND_SOC_DAPM_INPUT(NULL),
+	[snd_soc_dapm_switch]	= SND_SOC_DAPM_SWITCH_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_pga]	= SND_SOC_DAPM_PGA_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_mixer]	= SND_SOC_DAPM_MIXER_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_mux]	= SND_SOC_DAPM_MUX_E(NULL, SND_SOC_NOPM,
+					0, 0, NULL,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_aif_in]	= SND_SOC_DAPM_AIF_IN_E(NULL, NULL, 0,
+					SND_SOC_NOPM, 0, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+	[snd_soc_dapm_aif_out]	= SND_SOC_DAPM_AIF_OUT_E(NULL, NULL, 0,
+					SND_SOC_NOPM, 0, 0,
+					gbaudio_widget_event,
+					SND_SOC_DAPM_PRE_PMU |
+					SND_SOC_DAPM_POST_PMD),
+};
+
 static int gbaudio_tplg_create_widget(struct gbaudio_module_info *module,
 				      struct snd_soc_dapm_widget *dw,
 				      struct gb_audio_widget *w, int *w_size)
@@ -1052,77 +1090,37 @@ static int gbaudio_tplg_create_widget(st
 
 	switch (w->type) {
 	case snd_soc_dapm_spk:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_SPK(w->name, gbcodec_event_spk);
+		*dw = gbaudio_widgets[w->type];
 		module->op_devices |= GBAUDIO_DEVICE_OUT_SPEAKER;
 		break;
 	case snd_soc_dapm_hp:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_HP(w->name, gbcodec_event_hp);
+		*dw = gbaudio_widgets[w->type];
 		module->op_devices |= (GBAUDIO_DEVICE_OUT_WIRED_HEADSET
 					| GBAUDIO_DEVICE_OUT_WIRED_HEADPHONE);
 		module->ip_devices |= GBAUDIO_DEVICE_IN_WIRED_HEADSET;
 		break;
 	case snd_soc_dapm_mic:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_MIC(w->name, gbcodec_event_int_mic);
+		*dw = gbaudio_widgets[w->type];
 		module->ip_devices |= GBAUDIO_DEVICE_IN_BUILTIN_MIC;
 		break;
 	case snd_soc_dapm_output:
-		*dw = (struct snd_soc_dapm_widget)SND_SOC_DAPM_OUTPUT(w->name);
-		break;
 	case snd_soc_dapm_input:
-		*dw = (struct snd_soc_dapm_widget)SND_SOC_DAPM_INPUT(w->name);
-		break;
 	case snd_soc_dapm_switch:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_SWITCH_E(w->name, SND_SOC_NOPM, 0, 0,
-					      widget_kctls,
-					      gbaudio_widget_event,
-					      SND_SOC_DAPM_PRE_PMU |
-					      SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_pga:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_PGA_E(w->name, SND_SOC_NOPM, 0, 0, NULL, 0,
-					   gbaudio_widget_event,
-					   SND_SOC_DAPM_PRE_PMU |
-					   SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_mixer:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_MIXER_E(w->name, SND_SOC_NOPM, 0, 0, NULL,
-					     0, gbaudio_widget_event,
-					     SND_SOC_DAPM_PRE_PMU |
-					     SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_mux:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_MUX_E(w->name, SND_SOC_NOPM, 0, 0,
-					   widget_kctls, gbaudio_widget_event,
-					   SND_SOC_DAPM_PRE_PMU |
-					   SND_SOC_DAPM_POST_PMD);
+		*dw = gbaudio_widgets[w->type];
 		break;
 	case snd_soc_dapm_aif_in:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_AIF_IN_E(w->name, w->sname, 0,
-					      SND_SOC_NOPM,
-					      0, 0, gbaudio_widget_event,
-					      SND_SOC_DAPM_PRE_PMU |
-					      SND_SOC_DAPM_POST_PMD);
-		break;
 	case snd_soc_dapm_aif_out:
-		*dw = (struct snd_soc_dapm_widget)
-			SND_SOC_DAPM_AIF_OUT_E(w->name, w->sname, 0,
-					       SND_SOC_NOPM,
-					       0, 0, gbaudio_widget_event,
-					       SND_SOC_DAPM_PRE_PMU |
-					       SND_SOC_DAPM_POST_PMD);
+		*dw = gbaudio_widgets[w->type];
+		dw->sname = w->sname;
 		break;
 	default:
 		ret = -EINVAL;
 		goto error;
 	}
+	dw->name = w->name;
 
 	dev_dbg(module->dev, "%s: widget of type %d created\n", dw->name,
 		dw->id);


