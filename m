Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A923C431C6A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhJRNkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhJRNjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D7F561355;
        Mon, 18 Oct 2021 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563961;
        bh=F1se4l2ondFFN+LWbTyX+5OvDU7EUOe4VR5XwJ/u6pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KFuUBO/coYMVG2mPu1FaBUk13aT8DU0RruR8N1TsU+fT+SwcGCwL8IoUTg6On+IM
         PtrGSXK2iNk83cqPyNWWGATcpT36XuEOOtp+g0yU8rnDP7E3ixiYh+cfdEQU679O+X
         4E6cY8NxdHTWg/DEP/iDigV1+L13rrSIZh4Ey7kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 005/103] ALSA: hda - Enable headphone mic on Dell Latitude laptops with ALC3254
Date:   Mon, 18 Oct 2021 15:23:41 +0200
Message-Id: <20211018132334.876976792@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

commit 2b987fe84429361c7f189568c476d1bd00d2ff7e upstream.

The headphone mic is not working on Dell Latitude laptops with ALC3254.
The codec vendor id is 0x10ec0295 and share the same pincfg as defined
in ALC295_STANDARD_PINS. So the ALC269_FIXUP_DELL1_MIC_NO_PRESENCE will
be applied per alc269_pin_fixup_tbl[] but actually the headphone mic is
using NID 0x1b instead of 0x1a. The ALC269_FIXUP_DELL4_MIC_NO_PRESENCE
need to be applied instead.

Use ALC269_FIXUP_DELL4_MIC_NO_PRESENCE for particular models before
a generic fixup comes out.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211001062856.1037901-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8392,6 +8392,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a61, "Dell XPS 15 9510", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a62, "Dell Precision 5560", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0a9d, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


