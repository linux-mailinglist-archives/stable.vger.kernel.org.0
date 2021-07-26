Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7613D6245
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbhGZPfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236863AbhGZPeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B22C460240;
        Mon, 26 Jul 2021 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316093;
        bh=mRKPzH8VtE80PWTVuWhqBjiksBRHCfqDAMmp5TqAFxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4R7XHsDpmLZjai9YdniJ8Up7IaiQAHsifhyeTBO85pCshe5fO2cm7jg/lbQwYHl0
         5ZEGsejUTtNlBdW+2RhE1WTQ/HjFZ2UxAfgRDwywI/VFBZ2dq8Rzc2FzXR+f708M3D
         V2Zjv72pW0MRNYx21fmnFx+P2PxI5Sv27jdSSy+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jakub=20Fi=C5=A1er?= <jakub@ufiseru.cz>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 149/223] ALSA: usb-audio: Add registration quirk for JBL Quantum headsets
Date:   Mon, 26 Jul 2021 17:39:01 +0200
Message-Id: <20210726153851.104052531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
@@ -1897,6 +1897,9 @@ static const struct registration_quirk r
 	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
 	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
+	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */
 	{ 0 }					/* terminator */
 };
 


