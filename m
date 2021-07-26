Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CBC3D5FB6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbhGZPS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236774AbhGZPRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:17:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18D3B6056C;
        Mon, 26 Jul 2021 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315078;
        bh=x+PUCBJxmnk3e05PAnVy5nB5k+m4fLcOSwsQJSGP+7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if2tV2PhPfInIyUobylaE2AWzHYM3hTm0tGCd1M5FLfspNl7j8ERgaeqfjkmhlTB2
         1OBMlq/s0g4W8ZhamsueTLE5wYS5JgZNuyCMvh9ZUXKUnfXZG6EZdXZfS9KVKzrYjR
         tspb8qavSB4n4BTgKfRzd8329dd4xniiTBE5jRgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jakub=20Fi=C5=A1er?= <jakub@ufiseru.cz>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 073/108] ALSA: usb-audio: Add registration quirk for JBL Quantum headsets
Date:   Mon, 26 Jul 2021 17:39:14 +0200
Message-Id: <20210726153834.025169625@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Tsoy <alexander@tsoy.me>

commit b0084afde27fe8a504377dee65f55bc6aa776937 upstream.

These devices has two interfaces, but only the second interface
contains the capture endpoint, thus quirk is required to delay the
registration until the second interface appears.

Tested-by: Jakub Fišer <jakub@ufiseru.cz>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210721235605.53741-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1840,6 +1840,9 @@ static const struct registration_quirk r
 	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
 	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
+	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */
 	{ 0 }					/* terminator */
 };
 


