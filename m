Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1EF2E3BDA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405276AbgL1Nzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405266AbgL1Nzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4C320715;
        Mon, 28 Dec 2020 13:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163697;
        bh=NecWOzjnZUiftZew2B7dyjBERYLrGFApJjP+NCByVC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKUuKEmnK7TkS8fUdYaN+as92ITh9Zx40GmY0u+hme+7fUpb/ZRy+D/eS0ETWbERb
         n7d/VCORxASeAl4ArH79bTeCNXx/2qnoeJGemrVKMYbm/z2REvcvWJUQDCTILDkqkQ
         jWTc6QvFB3O7AmnnZ8TDYYHK8CRcFWipFf6e2WWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 335/453] ALSA: hda/ca0132 - Fix AE-5 rear headphone pincfg.
Date:   Mon, 28 Dec 2020 13:49:31 +0100
Message-Id: <20201228124953.343674398@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor McAdams <conmanx360@gmail.com>

commit c697ba85a94b8f65bf90dec5ef9af5c39c3e73b2 upstream.

The Windows driver sets the pincfg for the AE-5's rear-headphone to
report as a microphone. This causes issues with Pulseaudio mistakenly
believing there is no headphone plugged in. In Linux, we should instead
set it to be a headphone.

Fixes: a6b0961b39896 ("ALSA: hda/ca0132 - fix AE-5 pincfg")
Cc: <stable@kernel.org>
Signed-off-by: Connor McAdams <conmanx360@gmail.com>
Link: https://lore.kernel.org/r/20201208195223.424753-1-conmanx360@gmail.com
Link: https://lore.kernel.org/r/20201210173550.2968-1-conmanx360@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1147,7 +1147,7 @@ static const struct hda_pintbl ae5_pincf
 	{ 0x0e, 0x01c510f0 }, /* SPDIF In */
 	{ 0x0f, 0x01017114 }, /* Port A -- Rear L/R. */
 	{ 0x10, 0x01017012 }, /* Port D -- Center/LFE or FP Hp */
-	{ 0x11, 0x01a170ff }, /* Port B -- LineMicIn2 / Rear Headphone */
+	{ 0x11, 0x012170ff }, /* Port B -- LineMicIn2 / Rear Headphone */
 	{ 0x12, 0x01a170f0 }, /* Port C -- LineIn1 */
 	{ 0x13, 0x908700f0 }, /* What U Hear In*/
 	{ 0x18, 0x50d000f0 }, /* N/A */


