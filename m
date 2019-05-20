Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1AD23647
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbfETMog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389537AbfETM1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93FAF20815;
        Mon, 20 May 2019 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355266;
        bh=zJB3qhGxPWCYH21AF6fd26PvFecnkLrlf4xqniCa3DA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntf7D0EJCgGpwk4+dtcoNiTfirc+EKo+ndSUI9NbuCvkmAXAsfoNIxEywRPad3USC
         jyzvJptdSZb1j9uTD6+UBHaWsGpKmi3xDEk4UAsO3QIbLCFjkzpUO6NBxwbmAkmrHk
         1dYw+fPi7LMS5xiz2QFthuP+RwH9G8ZoRSRk48Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Soller <jeremy@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.0 052/123] ALSA: hdea/realtek - Headset fixup for System76 Gazelle (gaze14)
Date:   Mon, 20 May 2019 14:13:52 +0200
Message-Id: <20190520115248.191475953@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
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
@@ -6930,6 +6930,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x1325, "System76 Darter Pro (darp5)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8550, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),


