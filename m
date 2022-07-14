Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F4574372
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiGNEes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237547AbiGNEdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB9C3A4A0;
        Wed, 13 Jul 2022 21:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C637DB82381;
        Thu, 14 Jul 2022 04:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7057DC34115;
        Thu, 14 Jul 2022 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772753;
        bh=NS6Ip8n5acsijBVdlEeG+w91FXwLAGrzmxhdKFH/fpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7JN/mzCy6gI9G+pT8Ud2AjqQztqCYCgoUU9wZ5ZMeLD5ZqLQ9Dry7GfuxNdvGFjP
         YPsoJ4/nGzCOpXqRz9yxtiCD2mHs3P3bzm6nkm7THU6hRz6ZLviL+DjfSRIUFywupY
         rq2BQ9VzJ31332np9GYHbnmP4vvn2JHzumlyXHCvl5W89Ta+MQxn/Cv4eTb5VNGwU4
         F+X415QDuqUIY8+TgLv+IFz/6663GWR3TXU3ItmC8r/+bnjeStUmbE9DXbe/nTRu/q
         93BWn+G4xEv8ohdEycGuFsWlRYegZVx28QErhz4Wj4JTsyO1O/f2j3/UvgsMEoD2nO
         UdZz8EqqZgI0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 05/15] ASoC: dapm: Initialise kcontrol data for mux/demux controls
Date:   Thu, 14 Jul 2022 00:25:30 -0400
Message-Id: <20220714042541.282175-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042541.282175-1-sashal@kernel.org>
References: <20220714042541.282175-1-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 11d7a12f7f50baa5af9090b131c9b03af59503e7 ]

DAPM keeps a copy of the current value of mux/demux controls,
however this value is only initialised in the case of autodisable
controls. This leads to false notification events when first
modifying a DAPM kcontrol that has a non-zero default.

Autodisable controls are left as they are, since they already
initialise the value, and there would be more work required to
support autodisable muxes where the first option isn't disabled
and/or that isn't the default.

Technically this issue could affect mixer/switch elements as well,
although not on any of the devices I am currently running. There
is also a little more work to do to address the issue there due to
that side supporting stereo controls, so that has not been tackled
in this patch.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index f2f7f2dde93c..754c1f16ee83 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -62,6 +62,8 @@ struct snd_soc_dapm_widget *
 snd_soc_dapm_new_control_unlocked(struct snd_soc_dapm_context *dapm,
 			 const struct snd_soc_dapm_widget *widget);
 
+static unsigned int soc_dapm_read(struct snd_soc_dapm_context *dapm, int reg);
+
 /* dapm power sequences - make this per codec in the future */
 static int dapm_up_seq[] = {
 	[snd_soc_dapm_pre] = 1,
@@ -442,6 +444,9 @@ static int dapm_kcontrol_data_alloc(struct snd_soc_dapm_widget *widget,
 
 			snd_soc_dapm_add_path(widget->dapm, data->widget,
 					      widget, NULL, NULL);
+		} else if (e->reg != SND_SOC_NOPM) {
+			data->value = soc_dapm_read(widget->dapm, e->reg) &
+				      (e->mask << e->shift_l);
 		}
 		break;
 	default:
-- 
2.35.1

