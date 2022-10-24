Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C0860A6D0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJXMkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiJXMhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:37:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895FF5DF3F;
        Mon, 24 Oct 2022 05:06:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44FB6612D6;
        Mon, 24 Oct 2022 12:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533D6C433C1;
        Mon, 24 Oct 2022 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613150;
        bh=bZAdixgBkkbayO/PfynI242MpL8KYNSVLdsgYC5AH/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLvQ36vrrIBDt1lgyQZn89KWJhDq1eRl4RF9n3rzSaXE0FjnkjhSo1dlf092s6uM9
         SD+FnqFko1InSivOPZwpPV58ZnOS4YevmF5LfOkZsXP/xAC3+109kyxuBb2i2DC681
         /e1Cg0q2YlCl+iSUsmX/srj2z94oYzL1Tmd7Q4u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 007/255] ALSA: hda/realtek: Add quirk for ASUS GV601R laptop
Date:   Mon, 24 Oct 2022 13:28:37 +0200
Message-Id: <20221024113002.700278375@linuxfoundation.org>
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

commit 2ea8e1297801f7b0220ebf6ae61a5b74ca83981e upstream.

The ASUS ROG X16 (GV601R) series laptop has the same node-to-DAC pairs
as early models and the G14, this includes bass speakers which are by
default mapped incorrectly to the 0x06 node.

Add a quirk to use the same DAC pairs as the G14.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221010070347.36883-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8280,6 +8280,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),


