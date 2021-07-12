Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08AE3C4448
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhGLGSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhGLGSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941A6610CD;
        Mon, 12 Jul 2021 06:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070525;
        bh=ZwBuCLBuQ4hwQqBPSjZn/uwNrqtmgkJSOI3VOeeNo74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQIKBsHkzZocrukiTr3abdrMJXD1YHIgzKVLIyI3eKVpjkuCzyWQWA787yf9/VE4P
         vRwLDGrf40VWee+yA2QlTH/GbqnHitJvg/Q2gbLEC1AMWVwF5wM4szzyn1QNLj9qXK
         8sIAsa0b5LyrV5whe0V7eZeXp8QFjqK8Cro53TdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 007/348] ALSA: hda/realtek: Fix bass speaker DAC mapping for Asus UM431D
Date:   Mon, 12 Jul 2021 08:06:31 +0200
Message-Id: <20210712060701.055535605@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit f8fbcdfb0665de60997d9746809e1704ed782bbc upstream.

Asus Zenbook 14 UM431D has two speaker pins and a headphone pin, and
the auto-parser ends up assigning the bass to the third DAC 0x06.
Although the tone comes out, it's inconvenient because this DAC has no
volume control unlike two other DACs.

For obtaining the volume control for the bass speaker, this patch
enforces the mapping to let both front and bass speaker pins sharing
the same DAC.  It's not ideal but a little bit of improvement.

Since we've already applied the same workaround for another ASUS
machine, we just need to hook the chain to the existing quirk.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212547
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210620065952.18948-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7681,6 +7681,8 @@ static const struct hda_fixup alc269_fix
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x4e4b },
 			{ }
 		},
+		.chained = true,
+		.chain_id = ALC289_FIXUP_ASUS_GA401,
 	},
 	[ALC285_FIXUP_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,


