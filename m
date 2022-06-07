Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0685407FA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbiFGRxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350135AbiFGRvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4571406EB;
        Tue,  7 Jun 2022 10:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0408CCE23F1;
        Tue,  7 Jun 2022 17:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128E9C34115;
        Tue,  7 Jun 2022 17:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623560;
        bh=VUTDVhsr+CiHLojZAIrjKsa6Zs/IwwA1FvSziSK2u7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fE7NdR8YHB76TQSO6hFIOihKFQl2UgVukjpoiRdCUhnb+zi8ZZXYSq4mDljGrD9Ex
         isPMZQHP7L61hok0b6y7s+tHI/kzS42kFlBWTPLx+AmnFdlU/7aKqwNDPR6JirOYQ/
         v/25WAjKQbXY3ugSpB92M8qSbxBhLMIKOps/bHMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 010/667] ALSA: hda/realtek - Add new type for ALC245
Date:   Tue,  7 Jun 2022 18:54:35 +0200
Message-Id: <20220607164935.096813287@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 60571929d06b028800f27b51a7c81de1144944cf upstream.

Add new type for ALC245.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/cef26a7cd3d146eb96a3994ce79e34d2@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3126,6 +3126,7 @@ enum {
 	ALC269_TYPE_ALC257,
 	ALC269_TYPE_ALC215,
 	ALC269_TYPE_ALC225,
+	ALC269_TYPE_ALC245,
 	ALC269_TYPE_ALC287,
 	ALC269_TYPE_ALC294,
 	ALC269_TYPE_ALC300,
@@ -3163,6 +3164,7 @@ static int alc269_parse_auto_config(stru
 	case ALC269_TYPE_ALC257:
 	case ALC269_TYPE_ALC215:
 	case ALC269_TYPE_ALC225:
+	case ALC269_TYPE_ALC245:
 	case ALC269_TYPE_ALC287:
 	case ALC269_TYPE_ALC294:
 	case ALC269_TYPE_ALC300:
@@ -3690,7 +3692,8 @@ static void alc225_init(struct hda_codec
 	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	bool hp1_pin_sense, hp2_pin_sense;
 
-	if (spec->codec_variant != ALC269_TYPE_ALC287)
+	if (spec->codec_variant != ALC269_TYPE_ALC287 &&
+		spec->codec_variant != ALC269_TYPE_ALC245)
 		/* required only at boot or S3 and S4 resume time */
 		if (!spec->done_hp_init ||
 			is_s3_resume(codec) ||
@@ -9879,7 +9882,10 @@ static int patch_alc269(struct hda_codec
 	case 0x10ec0245:
 	case 0x10ec0285:
 	case 0x10ec0289:
-		spec->codec_variant = ALC269_TYPE_ALC215;
+		if (alc_get_coef0(codec) & 0x0010)
+			spec->codec_variant = ALC269_TYPE_ALC245;
+		else
+			spec->codec_variant = ALC269_TYPE_ALC215;
 		spec->shutup = alc225_shutup;
 		spec->init_hook = alc225_init;
 		spec->gen.mixer_nid = 0;


