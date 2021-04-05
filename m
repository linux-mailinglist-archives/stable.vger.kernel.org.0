Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F5354004
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbhDEJPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240099AbhDEJOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC61B61002;
        Mon,  5 Apr 2021 09:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614078;
        bh=Wf5fiTYI8CUTKxQHc/AdUaXj3BEdDoSEDRJK0A2bmD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX+WuiRM2t2pvWyh00wODQ70rku8SMBZSbQaSqhpOkv1a5hDONmKJJHjoMlw3Dukg
         g+QCSxQK4WHBgZf0ktn3DFOENo10PLVIe1HMWkPg5DcCqvwLc+y8eqfba/mV829CcK
         xjWY2BobEL0WbDgE3qpbHIm+jy8NuG4wBXzUGAUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Szu <jeremy.szu@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 076/152] ALSA: hda/realtek: fix mute/micmute LEDs for HP 640 G8
Date:   Mon,  5 Apr 2021 10:53:45 +0200
Message-Id: <20210405085036.737179035@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Szu <jeremy.szu@canonical.com>

commit 417eadfdd9e25188465280edf3668ed163fda2d0 upstream.

The HP EliteBook 640 G8 Notebook PC is using ALC236 codec which is
using 0x02 to control mute LED and 0x01 to control micmute LED.
Therefore, add a quirk to make it works.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210330114428.40490-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8058,6 +8058,7 @@ static const struct snd_pci_quirk alc269
 		      ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f2, "HP ProBook 640 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),


