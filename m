Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479864ABB64
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384567AbiBGL2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382556AbiBGLTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:19:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9135C043188;
        Mon,  7 Feb 2022 03:19:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69BB961380;
        Mon,  7 Feb 2022 11:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D99FC340EB;
        Mon,  7 Feb 2022 11:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232782;
        bh=PAuiHtXzfk347fL1QmZgs7OeKP/ZsguDOxlOMYZNuj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/5EYfv7YTRrsSPoE/dAcenAZAOxq9tfnXZYjq2VVuj+GbmNZNYSr6KfBIHW5/5oK
         Uw+u4pUpsaYdrDUmE2hDXwHkrZFeKvcGp7SePbPSvwIi+iBI1j7T0azhobDJ6O1gHD
         EzqtonZkatPr5Rh6dQslVZhJyZLxYbA5rSqOm1Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Albert=20Geant=C4=83?= <albertgeanta@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 06/44] ALSA: hda/realtek: Add quirk for ASUS GU603
Date:   Mon,  7 Feb 2022 12:06:22 +0100
Message-Id: <20220207103753.365886628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
References: <20220207103753.155627314@linuxfoundation.org>
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

From: Albert Geantă <albertgeanta@gmail.com>

commit 94db9cc8f8fa2d5426ce79ec4ca16028f7084224 upstream.

The ASUS GU603 (Zephyrus M16 - SSID 1043:16b2) requires a quirk similar to
other ASUS devices for correctly routing the 4 integrated speakers. This
fixes it by adding a corresponding quirk entry, which connects the bass
speakers to the proper DAC.

Signed-off-by: Albert Geantă <albertgeanta@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220131010523.546386-1-albertgeanta@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8180,6 +8180,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),


