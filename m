Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB2A431CB5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhJRNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhJRNmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A443261504;
        Mon, 18 Oct 2021 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564043;
        bh=Tf5f15sNLMIIbV/rhCQL45in1rX+UtwgPEvckpvOIH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dESbvEz9n873hAu+/lyY8+b0HHMiFSMBsfJotdRxbxZ134nndRAyeNtdWNLPXXY3I
         IulqdDfqCUms3BOaCIoUp+SbS3pd0Zz8dQcy4JfLHtkZ/NowvjTsfGwQ38E9n9AXIU
         v0FClg86wEmPtaYSwqB7k/SW4Hiv82nDqg186Vfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 010/103] ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo 13s Gen2
Date:   Mon, 18 Oct 2021 15:23:46 +0200
Message-Id: <20211018132335.041872226@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
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
@@ -8306,7 +8306,7 @@ static const struct hda_fixup alc269_fix
 		.v.verbs = (const struct hda_verb[]) {
 			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
-			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
 			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },


