Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ACD3D5F99
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbhGZPSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236785AbhGZPPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B5AE60FBF;
        Mon, 26 Jul 2021 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314788;
        bh=bu1yZ98dFokjnao6w6txQTLXHe5S9C4PF/zjs5b+1EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FexZn0f5nSWuKKn+NxcyVApfIHA5ThBFsKV/+XjDcB04DZqb4+YSEtD+deg9L4RQ1
         FeKtvyQZBYDhF5VT2kMQGvThdW4csxB6qpv9L1FnjzZ6Fn6irgPwNcTsi9FR6dyB5t
         Py2abfAcoi7K2LMV/fQcvSOjHm5Y6rO9RfPvwRCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jakub=20Fi=C5=A1er?= <jakub@ufiseru.cz>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 092/120] ALSA: usb-audio: Add registration quirk for JBL Quantum headsets
Date:   Mon, 26 Jul 2021 17:39:04 +0200
Message-Id: <20210726153835.347646747@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
@@ -1553,6 +1553,9 @@ static const struct registration_quirk r
 	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
 	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
 	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
+	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
+	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */
 	{ 0 }					/* terminator */
 };
 


