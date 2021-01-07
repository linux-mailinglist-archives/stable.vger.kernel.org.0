Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7892ED195
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbhAGOQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbhAGOQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12AA023142;
        Thu,  7 Jan 2021 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028939;
        bh=a9rUNy9qPKc1Rld5bocYLHcExVy+pMHDzg4JRBQEOdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ynd/15EmjuqzkTu6z8brr1lrFF+DfW3KZu8i6+JEZqzqPJlpwTIOjtYDq3Rlnebu+
         u06c4TaScnWcrPmXGi90wMAwPbZ67XJswp+6xYrPUwhdzhOyxl10x5j3IxoDxy2aas
         Vg/eH90ZRX2oZu8L926G4kvp6VbxWI+BxeXJy63A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 05/19] ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines
Date:   Thu,  7 Jan 2021 15:16:30 +0100
Message-Id: <20210107140827.843679998@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit d5078193e56bb24f4593f00102a3b5e07bb84ee0 upstream

With the alc289, the Pin 0x1b is Headphone-Mic, so we should assign
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE rather than
ALC225_FIXUP_DELL1_MIC_NO_PRESENCE to it. And this change is suggested
by Kailang of Realtek and is verified on the machine.

Fixes: 3f2f7c553d07 ("ALSA: hda - Fix headset mic detection problem for two Dell machines")
Cc: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6121,7 +6121,7 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60120},
 		{0x14, 0x90170110},
 		{0x21, 0x0321101f}),
-	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE,
+	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x12, 0xb7a60130},
 		{0x14, 0x90170110},
 		{0x21, 0x04211020}),


