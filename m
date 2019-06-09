Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1574B3A9E8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfFIROF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733182AbfFIQ52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E1F7205ED;
        Sun,  9 Jun 2019 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099447;
        bh=IXkIlCqkCaRjuYvfMMsgCVOb7+uyMRZbWTQdJx58+r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCyD+7HdndDCZi2lUfds2CtyWNnMb8EuQ9cBtDP3rjI+8Pd0ffF5NWwg8FTnCqAuq
         AQtVbmN3f9/NYpZkZ//35jCPxiFlSZGzKNrQ7L0meABOgVXjeVH4psHXrINzcHIwFe
         r1AY40sM6hDXeJtccZIUUs+YzcZjxPP2cxFRvRu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 009/241] ALSA: hda/realtek - EAPD turn on later
Date:   Sun,  9 Jun 2019 18:39:11 +0200
Message-Id: <20190609164148.056165787@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 607ca3bd220f4022e6f5356026b19dafc363863a upstream.

Let EAPD turn on after set pin output.

[ NOTE: This change is supposed to reduce the possible click noises at
  (runtime) PM resume.  The functionality should be same (i.e. the
  verbs are executed correctly) no matter which order is, so this
  should be safe to apply for all codecs -- tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -772,11 +772,10 @@ static int alc_init(struct hda_codec *co
 	if (spec->init_hook)
 		spec->init_hook(codec);
 
+	snd_hda_gen_init(codec);
 	alc_fix_pll(codec);
 	alc_auto_init_amp(codec, spec->init_amp);
 
-	snd_hda_gen_init(codec);
-
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 
 	return 0;


