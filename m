Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0C431D5F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhJRNuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhJRNsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E45461371;
        Mon, 18 Oct 2021 13:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564230;
        bh=dT687phatm1TJqek4ldCy6LsRiKHbqN3DirXEj2bSOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCVJmEI01K0G1oYUPi8YIP4CedG6oXv2TP/Hq9qwrEfkDCkiKBqaiLAlGDvfB1NJ6
         EZG4LPfBMQzmntgOjYD5MZBrZWPNP6gFIByb04yUKI+bFysG5FOVuFGimgTA1et9XG
         JV83iIjpi8GiCNHz4kFZksXIbDCNRVMWnaoDGu9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 011/151] ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo 13s Gen2
Date:   Mon, 18 Oct 2021 15:23:10 +0200
Message-Id: <20211018132341.045942296@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Berkenpas <cam@neo-zeon.de>

commit 023a062f238129e8a542b5163c4350ceb076283e upstream.

The previous patch's HDA verb initialization for the Lenovo 13s
sequence was slightly off. This updated verb sequence has been tested
and confirmed working.

Fixes: ad7cc2d41b7a ("ALSA: hda/realtek: Quirks to enable speaker output for Lenovo Legion 7i 15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 laptops.")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208555
Cc: <stable@vger.kernel.org>
Signed-off-by: Cameron Berkenpas <cam@neo-zeon.de>
Link: https://lore.kernel.org/r/20211010225410.23423-1-cam@neo-zeon.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8380,7 +8380,7 @@ static const struct hda_fixup alc269_fix
 		.v.verbs = (const struct hda_verb[]) {
 			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
-			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },


