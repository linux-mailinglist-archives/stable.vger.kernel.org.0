Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8191215BB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbfLPSTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731637AbfLPSTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C8620717;
        Mon, 16 Dec 2019 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520359;
        bh=ebxA31I8kpABX25jJlShKO7mHPTQ5Ng3ActI00OltWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyIncVm3+qqbyhTwRODQglZOQBfQVYSo3VmosAgtY5suMLJVAEWuajxgmtpdz+9Br
         Tk8VI/HeZpIQRyIlRlRbn7vWi4s4lHhmolVHrosIsCKUQvXmLDZKLBl7c5Sq6y+AcV
         5TmZz5oBrQH/t9AhmwmqjVM6LFnQo7WXPBHBNgVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 121/177] ALSA: hda/realtek - Line-out jack doesnt work on a Dell AIO
Date:   Mon, 16 Dec 2019 18:49:37 +0100
Message-Id: <20191216174843.307870676@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 5815bdfd7f54739be9abed1301d55f5e74d7ad1f upstream.

After applying the fixup ALC274_FIXUP_DELL_AIO_LINEOUT_VERB, the
Line-out jack works well. And instead of adding a new set of pin
definition in the pin_fixup_tbl, we put a more generic matching entry
in the fallback_pin_fixup_tbl.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20191211051321.5883-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7672,11 +7672,6 @@ static const struct snd_hda_pin_quirk al
 		{0x1a, 0x90a70130},
 		{0x1b, 0x90170110},
 		{0x21, 0x03211020}),
-	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
-		{0x12, 0xb7a60130},
-		{0x13, 0xb8a61140},
-		{0x16, 0x90170110},
-		{0x21, 0x04211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0280, 0x103c, "HP", ALC280_FIXUP_HP_GPIO4,
 		{0x12, 0x90a60130},
 		{0x14, 0x90170110},
@@ -7864,6 +7859,9 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1b, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
+		{0x19, 0x40000000},
+		{0x1a, 0x40000000}),
 	{}
 };
 


