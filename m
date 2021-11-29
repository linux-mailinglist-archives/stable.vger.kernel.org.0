Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8288446279A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhK2XIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbhK2XHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1115C1404CC;
        Mon, 29 Nov 2021 10:30:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66A33B815D2;
        Mon, 29 Nov 2021 18:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C19C53FCF;
        Mon, 29 Nov 2021 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210600;
        bh=3aD1UUbKV4P6k2liMQUeRkFehdFvYZpEV+URwZZ6lS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+0B3dw8z2C3OjUijuW4dpRCcmt6jONmRKF1zG5nJz42QOn/RQeFB8tr0UynSJfGK
         UOdJi3tzvpm2mMoEApgnX2A1Zm2mDzXsN7Y+PXFTmqTfCZ8gEBJDVmVL97l6cpevRk
         KN9V1dVm+S46GFT9Ne+NJuyNweviB5X+j1wEXZXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 018/121] ALSA: hda/realtek: Fix LED on HP ProBook 435 G7
Date:   Mon, 29 Nov 2021 19:17:29 +0100
Message-Id: <20211129181712.269010185@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 05ec7161084565365ecf267e9909a897a95f243a upstream.

HP ProBook 435 G7 (SSID 103c:8735) needs the similar quirk as another
HP ProBook for enabling the mute and the mic-mute LEDs.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215021
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211118071636.14738-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8604,6 +8604,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8728, "HP EliteBook 840 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),


