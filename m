Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0001070CA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfKVKjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbfKVKjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:39:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD962071F;
        Fri, 22 Nov 2019 10:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419171;
        bh=MxvYop6KxN7zmWGcLOnc+kZIwsZl/Wqugobl0MKGPS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLxp3e01kvTIAILh2n48CklYq9LybSMnR6hbOmbuV8yja8QegoNSPneik9Dq3ZL3v
         Hd2IjzVXlzJ5qKJQu+o/1qzVKcBqaFODgft7JccywhmM+Mf9ohXadB6mmMKgLjUeoo
         7+PjYRRDvFWbAwTV1zsG1fu74gT4382VVqQEgdt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        syzbot+abe1ab7afc62c6bb6377@syzkaller.appspotmail.com
Subject: [PATCH 4.9 003/222] ALSA: usb-audio: Fix missing error check at mixer resolution test
Date:   Fri, 22 Nov 2019 11:25:43 +0100
Message-Id: <20191122100831.262976361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 167beb1756791e0806365a3f86a0da10d7a327ee upstream.

A check of the return value from get_cur_mix_raw() is missing at the
resolution test code in get_min_max_with_quirks(), which may leave the
variable untouched, leading to a random uninitialized value, as
detected by syzkaller fuzzer.

Add the missing return error check for fixing that.

Reported-and-tested-by: syzbot+abe1ab7afc62c6bb6377@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191109181658.30368-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1046,7 +1046,8 @@ static int get_min_max_with_quirks(struc
 		if (cval->min + cval->res < cval->max) {
 			int last_valid_res = cval->res;
 			int saved, test, check;
-			get_cur_mix_raw(cval, minchn, &saved);
+			if (get_cur_mix_raw(cval, minchn, &saved) < 0)
+				goto no_res_check;
 			for (;;) {
 				test = saved;
 				if (test < cval->max)
@@ -1066,6 +1067,7 @@ static int get_min_max_with_quirks(struc
 			snd_usb_set_cur_mix_value(cval, minchn, 0, saved);
 		}
 
+no_res_check:
 		cval->initialized = 1;
 	}
 


