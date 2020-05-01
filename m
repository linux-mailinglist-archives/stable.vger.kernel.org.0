Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2271C12D8
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgEANY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgEANYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:24:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9751E24953;
        Fri,  1 May 2020 13:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339495;
        bh=oQ7B0AkpzBHnU7WHZ3slnVmqyOaWkKR6y1mZf8UXi78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVh85VqiKKfmoQLL4b/XXpbjsYzzxNmBC8hHicOzAh2n5EXm7aSox7yBcnDprTDi3
         3ngSqHrlFNSKGMuvLuSoITucHKflqCI6l9CJ7ua1VF9+9P0K9KQTAYqVuYIsYeDUCJ
         ezxAgEzu6KAebuQuvOrqfxWV974vFrs7v0BCoczA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 02/70] ALSA: hda - Fix incorrect usage of IS_REACHABLE()
Date:   Fri,  1 May 2020 15:20:50 +0200
Message-Id: <20200501131513.978773721@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 6a30abaa40b62aed46ef12ea4c16c48565bdb376 upstream.

The commit c469652bb5e8 ("ALSA: hda - Use IS_REACHABLE() for
dependency on input") simplified the dependencies with IS_REACHABLE()
macro, but it broke due to its incorrect usage: it should have been
IS_REACHABLE(CONFIG_INPUT) instead of IS_REACHABLE(INPUT).

Fixes: c469652bb5e8 ("ALSA: hda - Use IS_REACHABLE() for dependency on input")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3500,7 +3500,7 @@ static void alc280_fixup_hp_gpio4(struct
 	}
 }
 
-#if IS_REACHABLE(INPUT)
+#if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
 {


