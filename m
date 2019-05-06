Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62EFB14E9B
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfEFOjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfEFOjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889B920449;
        Mon,  6 May 2019 14:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153556;
        bh=zS1sSyYUibxrxplZamQ4JhvQ7iEZ8zXWwc89tqr9Fyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFxOW8pktn6STfh5o/ifwlM/EcdPBbWHieMT4CzUBk/n5plFNB8tif5bf1uGBHilK
         Sbr++usiqv646AFDXFoQjqIO7z6uJr8kam4mCjBaLx0XuNZegsCdSZSjrdNykjtZxY
         w+RnXFcuvG2056lM1qmXJznht3XulrQVQgEcuQms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 11/99] ALSA: hda/realtek - Fixed Dell AIO speaker noise
Date:   Mon,  6 May 2019 16:31:44 +0200
Message-Id: <20190506143054.878700080@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 0700d3d117a7f110ddddbd83873e13652f69c54b upstream.

Fixed Dell AIO speaker noise.
spec->gen.auto_mute_via_amp = 1, this option was solved speaker white
noise at boot.
codec->power_save_node = 0, this option was solved speaker noise at
resume back.

Fixes: 9226665159f0 ("ALSA: hda/realtek - Fix Dell AIO LineOut issue")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5448,6 +5448,8 @@ static void alc274_fixup_bind_dacs(struc
 		return;
 
 	spec->gen.preferred_dacs = preferred_pairs;
+	spec->gen.auto_mute_via_amp = 1;
+	codec->power_save_node = 0;
 }
 
 /* The DAC of NID 0x3 will introduce click/pop noise on headphones, so invalidate it */


