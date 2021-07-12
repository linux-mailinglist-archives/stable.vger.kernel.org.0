Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F04B3C5068
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbhGLHcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346863AbhGLHbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90DCC60230;
        Mon, 12 Jul 2021 07:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074901;
        bh=nlXzkf3Bhx7wDPMDrIgEqHQE/Ay6ATUz6G8X7XMoQo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCFe5fqyuMe72m6+qUtd6H0DbSamuQELO5yvzGBdNuF5JP1aVPYUL045OkAJAZxao
         b/6N9HRJSxIj3gkY4kcNAfmzs2SU9UClzBggVT/ul9ZP61vL5P4kqoMLeOMrdWsV2n
         PlUgr5Qq2iaHkbEK6A6u4iq5eSuPTXjl1xqxD9E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 006/800] ALSA: usb-audio: Fix OOB access at proc output
Date:   Mon, 12 Jul 2021 08:00:29 +0200
Message-Id: <20210712060914.004088347@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 362372ceb6556f338e230f2d90af27b47f82365a upstream.

At extending the available mixer values for 32bit types, we forgot to
add the corresponding entries for the format dump in the proc output.
This may result in OOB access.  Here adds the missing entries.

Fixes: bc18e31c3042 ("ALSA: usb-audio: Fix parameter block size for UAC2 control requests")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210622090647.14021-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3294,8 +3294,9 @@ static void snd_usb_mixer_dump_cval(stru
 				    struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *cval = mixer_elem_list_to_info(list);
-	static const char * const val_types[] = {"BOOLEAN", "INV_BOOLEAN",
-				    "S8", "U8", "S16", "U16"};
+	static const char * const val_types[] = {
+		"BOOLEAN", "INV_BOOLEAN", "S8", "U8", "S16", "U16", "S32", "U32",
+	};
 	snd_iprintf(buffer, "    Info: id=%i, control=%i, cmask=0x%x, "
 			    "channels=%i, type=\"%s\"\n", cval->head.id,
 			    cval->control, cval->cmask, cval->channels,


