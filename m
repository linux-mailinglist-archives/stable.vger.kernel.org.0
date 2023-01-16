Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA7166CC39
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbjAPRXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbjAPRWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604FB34C01
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F24E060F61
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C2BC433EF;
        Mon, 16 Jan 2023 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888442;
        bh=aH5aMiOGIvKiFKFVBnHG7PkKwNOXIrNF7djq0OY/eKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oGHkLhXWCacP7Etc8Gc5SlxEy1uL19Ec4ruefCQr868F//haDNyq62Nr3GYvRS/G/
         +WcgP1idw3xR/u1jhnHpS6wPiI5taqMnlYo9rEgRcg5htPBvGvSwInwN1HezL2mfmt
         dJp+pwSCXUmmmITxDroQNGGvgn+xzqmomJJpY5Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 519/521] ALSA: hda/realtek - Fixed one of HP ALC671 platform Headset Mic supported
Date:   Mon, 16 Jan 2023 16:53:01 +0100
Message-Id: <20230116154910.413684119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

commit f2adbae0cb20c8eaf06914b2187043ea944b0aff upstream.

HP want to keep BIOS verb table for release platform.
So, it need to add 0x19 pin for quirk.

Fixes: 5af29028fd6d ("ALSA: hda/realtek - Add Headset Mic supported for HP cPC")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/74636ccb700a4cbda24c58a99dc430ce@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9304,6 +9304,7 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
 		{0x14, 0x01014010},
 		{0x17, 0x90170150},
+		{0x19, 0x02a11060},
 		{0x1b, 0x01813030},
 		{0x21, 0x02211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,


