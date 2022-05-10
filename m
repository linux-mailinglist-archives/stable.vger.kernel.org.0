Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D875C521AA9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiEJODH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245281AbiEJN5Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CBF2CCD09;
        Tue, 10 May 2022 06:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9DCB81DC2;
        Tue, 10 May 2022 13:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1A6C385C2;
        Tue, 10 May 2022 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189942;
        bh=ja0ijxZvm9OzHxdtl9DZF2+y3dpt4d6NdYljy+53o+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWbEHJ03GTOzja3lGEZSz2lkJq34tDHCpAR27U+q9jtcPIOPdYytgS36CNF+0OdCK
         do5A1ZkQOTXp8urPKlB0kV/TVdh002WPi8yEYE+/UeHe1/ReVxW3XADSHgnpA/zwB5
         YJYJ2LjV5BRP54myWh4PbArg1ZEMM9n44UXgnsgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 077/140] ALSA: hda/realtek: Fix mute led issue on thinkpad with cs35l41 s-codec
Date:   Tue, 10 May 2022 15:07:47 +0200
Message-Id: <20220510130743.816837722@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit a6ac60b36dade525c13c5bb0838589619533efb7 upstream.

The quirk ALC287_FIXUP_CS35L41_I2C_2 needs to chain the quirk
ALC269_FIXUP_THINKPAD_ACPI, otherwise the mute led will not work if a
thinkpad machine applies that quirk.

And it will be safe if non-thinkpad machines apply that quirk since
hda_fixup_thinkpad_acpi() will check and return in this case.

Fixes: ae7abe36e352e ("ALSA: hda/realtek: Add CS35L41 support for Thinkpad laptops")
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20220422073937.10073-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8759,6 +8759,8 @@ static const struct hda_fixup alc269_fix
 	[ALC287_FIXUP_CS35L41_I2C_2] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
 	},
 	[ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED] = {
 		.type = HDA_FIXUP_VERBS,


