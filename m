Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B154909B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiFMKcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiFMKad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:30:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7458621E07;
        Mon, 13 Jun 2022 03:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8E70B80E94;
        Mon, 13 Jun 2022 10:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357F3C34114;
        Mon, 13 Jun 2022 10:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115676;
        bh=//b4YhDz4deef/VaPhG43OVx0wkPvH71VetrAukn15o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzyiiTKYdQEHOD6Z3teUdq9KUtcCP8EZCyBaN2HYd7wAJyiRb5uxLRfokFx5T4pLX
         QYWvBAQCZoNiAnXdlM8rglxd28JPv2yOotMEFk2vkPN5u8fUPgGqdERgMUnb9ov/Wa
         GiQyPDOAkwKv8cCFsQNmNjeaxAmc65bOu7kxb+0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huangwenhui <huangwenhuia@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 158/167] ALSA: hda/conexant - Fix loopback issue with CX20632
Date:   Mon, 13 Jun 2022 12:10:32 +0200
Message-Id: <20220613094918.000549194@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

From: huangwenhui <huangwenhuia@uniontech.com>

commit d5ea7544c32ba27c2c5826248e4ff58bd50a2518 upstream.

On a machine with CX20632, Alsamixer doesn't have 'Loopback
Mixing' and 'Line'.

Signed-off-by: huangwenhui <huangwenhuia@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220607065631.10708-1-huangwenhuia@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -942,6 +942,13 @@ static int patch_conexant_auto(struct hd
 		snd_hda_pick_fixup(codec, cxt5051_fixup_models,
 				   cxt5051_fixups, cxt_fixups);
 		break;
+	case 0x14f15098:
+		codec->pin_amp_workaround = 1;
+		spec->gen.mixer_nid = 0x22;
+		spec->gen.add_stereo_mix_input = HDA_HINT_STEREO_MIX_AUTO;
+		snd_hda_pick_fixup(codec, cxt5066_fixup_models,
+				   cxt5066_fixups, cxt_fixups);
+		break;
 	case 0x14f150f2:
 		codec->power_save_node = 1;
 		/* Fall through */


