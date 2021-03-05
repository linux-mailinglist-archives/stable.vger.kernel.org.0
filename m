Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809BA32EA79
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhCEMip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233017AbhCEMi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:38:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13AA765012;
        Fri,  5 Mar 2021 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947901;
        bh=rOUtgUTjiS8Cpv8w/97/J1aK1y3RYe0MItjlEuFg7nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Dm/XphUhAWqUDmfFuqlEC+b/Nodh0eA84YyjWveJmt4XhCpQKRwcMlVEVlsaVIxr
         AxsGWa0WVKevF/bPwBD2XN/DPuk9yIodywQwVUOEeMyxMOxRAHFMtB7O3fyMatuxw1
         HIaj7Zo9pnJaRskC7DINCalylM6bnGGuu53zUL88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 52/52] ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board
Date:   Fri,  5 Mar 2021 13:22:23 +0100
Message-Id: <20210305120856.202776778@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 26af17722a07597d3e556eda92c6fce8d528bc9f upstream.

There is another MSI board (1462:cc34) that has dual Realtek codecs,
and we need to apply the existing quirk for fixing the conflicts of
Master control.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211743
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303142346.28182-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2507,6 +2507,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1462, 0x1276, "MSI-GL73", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x1293, "MSI-GP65", ALC1220_FIXUP_CLEVO_P950),
 	SND_PCI_QUIRK(0x1462, 0x7350, "MSI-7350", ALC889_FIXUP_CD),
+	SND_PCI_QUIRK(0x1462, 0xcc34, "MSI Godlike X570", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),


