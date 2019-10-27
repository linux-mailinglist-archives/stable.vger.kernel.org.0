Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D56E677F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbfJ0VVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbfJ0VV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:28 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FACE208C0;
        Sun, 27 Oct 2019 21:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211287;
        bh=zOf6QBfl7HHOIgvm0cyDG+mhCRuEGWYUeiUlNmlofOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyYDb0bqXMJFwrh4MZ/qpPsEqX/cX/RJvJ7MpAMbwB9rregMaFN3Zf3FGMQFMpsXc
         qommLexIpBT1X7gw/3ffcNUbQ2NEAB3erLxv7201Hipri63hmy2ToS1jbpXnwNmFwT
         vyF8/RFB7CS/lI5U64Hoxl3YDbIke2VVj9dhVkzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Szabolcs=20Sz=C5=91ke?= <szszoke.code@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 099/197] ALSA: usb-audio: Disable quirks for BOSS Katana amplifiers
Date:   Sun, 27 Oct 2019 22:00:17 +0100
Message-Id: <20191027203357.104434455@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szabolcs Szőke <szszoke.code@gmail.com>

commit 7571b6a17fcc5e4f6903f065a82d0e38011346ed upstream.

BOSS Katana amplifiers cannot be used for recording or playback if quirks
are applied

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=195223
Signed-off-by: Szabolcs Szőke <szszoke.code@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191011171937.8013-1-szszoke.code@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -348,6 +348,9 @@ static int set_sync_ep_implicit_fb_quirk
 		ep = 0x84;
 		ifnum = 0;
 		goto add_sync_ep_from_ifnum;
+	case USB_ID(0x0582, 0x01d8): /* BOSS Katana */
+		/* BOSS Katana amplifiers do not need quirks */
+		return 0;
 	}
 
 	if (attr == USB_ENDPOINT_SYNC_ASYNC &&


