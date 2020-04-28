Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D281BC97D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgD1SmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730502AbgD1SmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:42:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08AA72076A;
        Tue, 28 Apr 2020 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099334;
        bh=ntRI2d4t5d8LgNQWaIoeisCkG2w01XL6Yg21Sgy5huY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scOHvS1wyV6cwvj7+6LiiOzqVm9pOj0B3+REZWSlIg+eattStCmMo3Wk9CSlDs5x8
         a0wEkJWu5zE9PupwwV1xIElz3sjHsvx3/2anITVJiVZ8sp/VK6H6b9gMeTBcao1uAp
         +8YMRSxJwcXRL9mO2QM8p1OKoWK4jB6rjGzvyHfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 109/168] ALSA: hda/realtek - Fix unexpected init_amp override
Date:   Tue, 28 Apr 2020 20:24:43 +0200
Message-Id: <20200428182246.288982582@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 67791202c5e069cf2ba51db0718d56c634709e78 upstream.

The commit 1c76aa5fb48d ("ALSA: hda/realtek - Allow skipping
spec->init_amp detection") changed the way to assign spec->init_amp
field that specifies the way to initialize the amp.  Along with the
change, the commit also replaced a few fixups that set spec->init_amp
in HDA_FIXUP_ACT_PROBE with HDA_FIXUP_ACT_PRE_PROBE.  This was rather
aligning to the other fixups, and not supposed to change the actual
behavior.

However, this change turned out to cause a regression on FSC S7020,
which hit exactly the above.  The reason was that there is still one
place that overrides spec->init_amp after HDA_FIXUP_ACT_PRE_PROBE
call, namely in alc_ssid_check().

This patch fixes the regression by adding the proper spec->init_amp
override check, i.e. verifying whether it's still ALC_INIT_UNDEFINED.

Fixes: 1c76aa5fb48d ("ALSA: hda/realtek - Allow skipping spec->init_amp detection")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207329
Link: https://lore.kernel.org/r/20200418190639.10082-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -789,9 +789,11 @@ static void alc_ssid_check(struct hda_co
 {
 	if (!alc_subsystem_id(codec, ports)) {
 		struct alc_spec *spec = codec->spec;
-		codec_dbg(codec,
-			  "realtek: Enable default setup for auto mode as fallback\n");
-		spec->init_amp = ALC_INIT_DEFAULT;
+		if (spec->init_amp == ALC_INIT_UNDEFINED) {
+			codec_dbg(codec,
+				  "realtek: Enable default setup for auto mode as fallback\n");
+			spec->init_amp = ALC_INIT_DEFAULT;
+		}
 	}
 }
 


