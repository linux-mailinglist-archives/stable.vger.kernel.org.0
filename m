Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6B23520
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390014AbfETMdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733069AbfETMdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E91AE20645;
        Mon, 20 May 2019 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355594;
        bh=r932CAIzrxKcyMXHbNYtwSh4ds4op5ZJLCuQeblnZYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOgIpT2+UiRNIW2ghQ7SUkyQ3YIgOtB/eB1loVAd9FDd0U3p02QH2oTx07vjJM72S
         gAxgqG84MVU8qQ4yZIdz7iy4NUTIA2NPi4iPsVDXJU0qA2RLMFp12eF6mDqmI0WFpv
         h3xevIW9e7XZqzTUEETfU1bvsNz6EZW279KJG6zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Soller <jeremy@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 053/128] ALSA: hdea/realtek - Headset fixup for System76 Gazelle (gaze14)
Date:   Mon, 20 May 2019 14:14:00 +0200
Message-Id: <20190520115253.375944530@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Soller <jeremy@system76.com>

commit 80a5052db75131423b67f38b21958555d7d970e4 upstream.

On the System76 Gazelle (gaze14), there is a headset microphone input
attached to 0x1a that does not have a jack detect. In order to get it
working, the pin configuration needs to be set correctly, and the
ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC fixup needs to be applied. This is
identical to the patch already applied for the System76 Darter Pro
(darp5).

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6932,6 +6932,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x1325, "System76 Darter Pro (darp5)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8550, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),


