Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236BF69496C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjBMO64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjBMO6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48301DBBC
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E39BFB81261
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358EBC433D2;
        Mon, 13 Feb 2023 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300261;
        bh=QNMksrNKLYiQPW1L4vfbMWQonxHqhjY3tYMB8uB52Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0C2o+5nCFH81Gm8wvSUFWWk4wBfZsW7RqozXdS7vcgZE9gdHirop9Vflmhi9i/z3+
         8tiak4cdPc8jzFdQX1K0RNouLihBLcCrwViOPojOsPmw3n+/c9qTClw7PA2qR7uBs5
         yWlz+o58/jNxKsDlGI+rgAzeWlGvsZ/tuf83T3DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Elvis Angelaccio <elvis.angelaccio@kde.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 11/67] ALSA: hda/realtek: Enable mute/micmute LEDs on HP Elitebook, 645 G9
Date:   Mon, 13 Feb 2023 15:48:52 +0100
Message-Id: <20230213144732.851070096@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

From: Elvis Angelaccio <elvis.angelaccio@kde.org>

commit 9a6804aa1c92cd28e89e746ace44d5ba101db76c upstream.

The HP Elitebook 645 G9 laptop (with motherboard model 89D2) uses the
ALC236 codec and requires the alc236_fixup_hp_mute_led_micmute_vref
fixup in order to enable mute/micmute LEDs.

Note: the alc236_fixup_hp_gpio_led fixup, which is used by the Elitebook
640 G9, does not work with the 645 G9.

[ rearranged the entry in SSID order -- tiwai ]

Signed-off-by: Elvis Angelaccio <elvis.angelaccio@kde.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4055cb48-e228-8a13-524d-afbb7aaafebe@kde.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9072,6 +9072,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),


