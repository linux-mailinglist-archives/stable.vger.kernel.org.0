Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB481C80
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfHENY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731014AbfHENY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1827D20651;
        Mon,  5 Aug 2019 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011468;
        bh=kDASm8+AuMPNY/cREAHlH2bRIsXBL4K8DG62KX5A/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlMRCpHGgGdSJjOGuTZCstlI+yAnznsEcvao72KYDk/2WYyUsPGRDtubcKDZjTWNp
         DLvSTLCrH7nVWUq8LG0SSE5I8KYjuwjLc69i4LdiOvLPytTDqMT2V9YokmFpXLkhyN
         iKEp7NvqrViDyjFwp7S18y4XvZqidtENTWFC2oVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 099/131] ALSA: hda: Fix 1-minute detection delay when i915 module is not available
Date:   Mon,  5 Aug 2019 15:03:06 +0200
Message-Id: <20190805124958.585858607@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 74bf71ed792ab0f64631cc65ccdb54c356c36d45 upstream.

Distribution installation images such as Debian include different sets
of modules which can be downloaded dynamically.  Such images may notably
include the hda sound modules but not the i915 DRM module, even if the
latter was enabled at build time, as reported on
https://bugs.debian.org/931507

In such a case hdac_i915 would be linked in and try to load the i915
module, fail since it is not there, but still wait for a whole minute
before giving up binding with it.

This fixes such as case by only waiting for the binding if the module
was properly loaded (or module support is disabled, in which case i915
is already compiled-in anyway).

Fixes: f9b54e1961c7 ("ALSA: hda/i915: Allow delayed i915 audio component binding")
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/hda/hdac_i915.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/hda/hdac_i915.c
+++ b/sound/hda/hdac_i915.c
@@ -136,10 +136,12 @@ int snd_hdac_i915_init(struct hdac_bus *
 	if (!acomp)
 		return -ENODEV;
 	if (!acomp->ops) {
-		request_module("i915");
-		/* 60s timeout */
-		wait_for_completion_timeout(&bind_complete,
-					    msecs_to_jiffies(60 * 1000));
+		if (!IS_ENABLED(CONFIG_MODULES) ||
+		    !request_module("i915")) {
+			/* 60s timeout */
+			wait_for_completion_timeout(&bind_complete,
+						   msecs_to_jiffies(60 * 1000));
+		}
 	}
 	if (!acomp->ops) {
 		dev_info(bus->dev, "couldn't bind with audio component\n");


