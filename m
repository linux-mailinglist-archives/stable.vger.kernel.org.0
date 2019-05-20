Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF447235D8
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfETMkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390668AbfETMdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ABF0204FD;
        Mon, 20 May 2019 12:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355591;
        bh=Y5gLgaKUCRhk57m/UXAViF0p7JGbNm1P9I90M+EkMGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q388yqIigSHo/DiaNr6umyZ5vrE5UBae8xEF1xMof8CCtqRP3EcVCzpLpiZx/GVSY
         6CV4n82n9cZKigFc43j91vrJlAWjdLFbNApAjw+CUEnMvZX1NtycTJn1ukt514KfGo
         PPiUhbKSpoaTWHO74/VUxuM7q6nT7+PeXmxUpSF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 052/128] ALSA: hda/realtek - EAPD turn on later
Date:   Mon, 20 May 2019 14:13:59 +0200
Message-Id: <20190520115253.286236162@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
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
@@ -803,11 +803,10 @@ static int alc_init(struct hda_codec *co
 	if (spec->init_hook)
 		spec->init_hook(codec);
 
+	snd_hda_gen_init(codec);
 	alc_fix_pll(codec);
 	alc_auto_init_amp(codec, spec->init_amp);
 
-	snd_hda_gen_init(codec);
-
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 
 	return 0;


