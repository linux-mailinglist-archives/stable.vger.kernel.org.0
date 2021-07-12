Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02B23C4764
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhGLGcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235516AbhGLGbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02288601FC;
        Mon, 12 Jul 2021 06:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071326;
        bh=cMxHLUYOMe+VUir2CowYaO7r5PLgIoq16qG8ZnHv5LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuXwFPVLwJpUILmmNeEfYJuHK704lMRzDURZyxqex+I75m3QfhVZ4GUcSOyt+kU07
         jTx/VaMNl0g40n9szKLiYAo3YqhVf5ZTFgpW4Sb6cbyYxQM8/sDOHjQJKw6mlYTQGW
         Wya3wVtRjr1xKsFPgFokuSmjDd21hKfN/aOV+75A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 005/593] ALSA: usb-audio: Fix OOB access at proc output
Date:   Mon, 12 Jul 2021 08:02:45 +0200
Message-Id: <20210712060843.769620222@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
@@ -3273,8 +3273,9 @@ static void snd_usb_mixer_dump_cval(stru
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


