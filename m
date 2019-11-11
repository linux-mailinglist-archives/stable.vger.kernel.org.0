Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D41F7C21
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfKKSnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:43:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfKKSnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:43:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE32204FD;
        Mon, 11 Nov 2019 18:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497811;
        bh=VIQSG7glfoUTAKYUaH51Z9lnqPzkGWvFKJyxBPJD8pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVHbToHAriwdsnLc2A+MMhnOBSGPkYWUjwJwY+sDz2nGGeiL+VkjEVjShTym4uJlt
         3HkWi41sNT1CfxHL54YhzVIwrirFLQsXt+VEPvr870+a9O3MrHFHHvLXCEI7fa6gNh
         tRseXDsryQQFwGjpj/lC78sKw76IIKiR0HU/NJhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0620f79a1978b1133fd7@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 064/125] ALSA: usb-audio: Fix copy&paste error in the validator
Date:   Mon, 11 Nov 2019 19:28:23 +0100
Message-Id: <20191111181448.793514433@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ba8bf0967a154796be15c4983603aad0b05c3138 upstream.

The recently introduced USB-audio descriptor validator had a stupid
copy&paste error that may lead to an unexpected overlook of too short
descriptors for processing and extension units.  It's likely the cause
of the report triggered by syzkaller fuzzer.  Let's fix it.

Fixes: 57f8770620e9 ("ALSA: usb-audio: More validations of descriptor units")
Reported-by: syzbot+0620f79a1978b1133fd7@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/s5hsgnkdbsl.wl-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/validate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -75,7 +75,7 @@ static bool validate_processing_unit(con
 
 	if (d->bLength < sizeof(*d))
 		return false;
-	len = d->bLength < sizeof(*d) + d->bNrInPins;
+	len = sizeof(*d) + d->bNrInPins;
 	if (d->bLength < len)
 		return false;
 	switch (v->protocol) {


