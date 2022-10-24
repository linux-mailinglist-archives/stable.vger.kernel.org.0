Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EB660B2C5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiJXQvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbiJXQtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31541F2D4;
        Mon, 24 Oct 2022 08:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F27B811F3;
        Mon, 24 Oct 2022 12:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45D1C433C1;
        Mon, 24 Oct 2022 12:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613148;
        bh=SBowlJ1c0DUb3hOW8qotgHtHvdNGZkTT+DKRGLY4YmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yP0tTAaxq4UaIaX3YHNaLC8c2b8e74uYwX6PiebHbcy5aC/98JLARY/ggY8o5QKNz
         YeTj5jQOz0/KKtzKqKCi9J5H5wpXFN3dRiuvVV4tjtiZ2NLUYMXc2i9UPbRkeEU1om
         lQFK36owMyixG7gS/xaK+A+XBxHh1rXoXPrd9MMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 006/255] ALSA: hda/realtek: Correct pin configs for ASUS G533Z
Date:   Mon, 24 Oct 2022 13:28:36 +0200
Message-Id: <20221024113002.672004278@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

commit 66ba7c88507344dee68ad1acbdb630473ab36114 upstream.

The initial fix for ASUS G533Z was based on faulty information. This
fixes the pincfg to values that have been verified with no existing
module options or other hacks enabled.

Enables headphone jack, and 5.1 surround.

[ corrected the indent level by tiwai ]

Fixes: bc2c23549ccd ("ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack")
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221010065702.35190-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7775,11 +7775,13 @@ static const struct hda_fixup alc269_fix
 	[ALC285_FIXUP_ASUS_G533Z_PINS] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x14, 0x90170120 },
+			{ 0x14, 0x90170152 }, /* Speaker Surround Playback Switch */
+			{ 0x19, 0x03a19020 }, /* Mic Boost Volume */
+			{ 0x1a, 0x03a11c30 }, /* Mic Boost Volume */
+			{ 0x1e, 0x90170151 }, /* Rear jack, IN OUT EAPD Detect */
+			{ 0x21, 0x03211420 },
 			{ }
 		},
-		.chained = true,
-		.chain_id = ALC294_FIXUP_ASUS_G513_PINS,
 	},
 	[ALC294_FIXUP_ASUS_COEF_1B] = {
 		.type = HDA_FIXUP_VERBS,


