Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554B6796FC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390804AbfG2TzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404141AbfG2TzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CDFB204EC;
        Mon, 29 Jul 2019 19:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430101;
        bh=Su9El4zE9CqFO7ZFLiW6WLgYA1RJp2b/hBWoEB5mFpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMXQKqETQqfnuVhEA/Vct58m0+VVhN7m0BdhL974lCSDPiWZo7X9/CsA2dKym5Kh8
         lZdfUaJPB2/t3jucpDk/FW8GeSuCEaBmb02+OPyLDqJGHtkhvhD153P4qrSs0LkMod
         Cx9PK4DvRsFUjq4NBv8Ub9WjGNS7e5HTWEapJS0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 195/215] ALSA: hda - Add a conexant codec entry to let mute led work
Date:   Mon, 29 Jul 2019 21:23:11 +0200
Message-Id: <20190729190813.709357569@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 3f8809499bf02ef7874254c5e23fc764a47a21a0 upstream.

This conexant codec isn't in the supported codec list yet, the hda
generic driver can drive this codec well, but on a Lenovo machine
with mute/mic-mute leds, we need to apply CXT_FIXUP_THINKPAD_ACPI
to make the leds work. After adding this codec to the list, the
driver patch_conexant.c will apply THINKPAD_ACPI to this machine.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1083,6 +1083,7 @@ static int patch_conexant_auto(struct hd
  */
 
 static const struct hda_device_id snd_hda_id_conexant[] = {
+	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),


