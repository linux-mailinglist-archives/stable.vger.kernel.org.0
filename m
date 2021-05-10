Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F437888F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhEJLWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237247AbhEJLLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C0F461879;
        Mon, 10 May 2021 11:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644908;
        bh=2UG/nlHqSK72KX7mMr/KbK8F7icZvugEvKN7RYAV2l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T03+NiLb0pQGVbZNnXOhWgRdkCSU11Qc3bK+5q6Eon3BCNBcznGvt6nzNtYtLRG+4
         Gx8exLHJMzFu9wjBB7WfB+kBP1X2OCehRcjnedSv4iRmPI2qf1qQbCq9r6C5hTm+fr
         Db+//OxHVtfiZFnJobEGRvVhi9zJyKlNMBVCC2/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geraldo Nascimento <geraldogabriel@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 274/384] ALSA: usb-audio: Explicitly set up the clock selector
Date:   Mon, 10 May 2021 12:21:03 +0200
Message-Id: <20210510102023.869143211@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d2e8f641257d0d3af6e45d6ac2d6f9d56b8ea964 upstream.

In the current code, we have some assumption that the audio clock
selector has been set up implicitly and don't want to touch it unless
it's really needed for the fallback autoclock setup.  This works for
most devices but some seem having a problem.  Partially this was
covered for the devices with a single connector at the initialization
phase (commit 086b957cc17f "ALSA: usb-audio: Skip the clock selector
inquiry for single connections"), but also there are cases where the
wrong clock set up is kept silently.  The latter seems to be the cause
of the noises on Behringer devices.

In this patch, we explicitly set up the audio clock selector whenever
the appropriate node is found.

Reported-by: Geraldo Nascimento <geraldogabriel@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=199327
Link: https://lore.kernel.org/r/CAEsQvcvF7LnO8PxyyCxuRCx=7jNeSCvFAd-+dE0g_rd1rOxxdw@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210413084152.32325-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/clock.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -296,7 +296,7 @@ static int __uac_clock_find_source(struc
 
 	selector = snd_usb_find_clock_selector(chip->ctrl_intf, entity_id);
 	if (selector) {
-		int ret, i, cur;
+		int ret, i, cur, err;
 
 		if (selector->bNrInPins == 1) {
 			ret = 1;
@@ -324,13 +324,17 @@ static int __uac_clock_find_source(struc
 		ret = __uac_clock_find_source(chip, fmt,
 					      selector->baCSourceID[ret - 1],
 					      visited, validate);
+		if (ret > 0) {
+			err = uac_clock_selector_set_val(chip, entity_id, cur);
+			if (err < 0)
+				return err;
+		}
+
 		if (!validate || ret > 0 || !chip->autoclock)
 			return ret;
 
 		/* The current clock source is invalid, try others. */
 		for (i = 1; i <= selector->bNrInPins; i++) {
-			int err;
-
 			if (i == cur)
 				continue;
 
@@ -396,7 +400,7 @@ static int __uac3_clock_find_source(stru
 
 	selector = snd_usb_find_clock_selector_v3(chip->ctrl_intf, entity_id);
 	if (selector) {
-		int ret, i, cur;
+		int ret, i, cur, err;
 
 		/* the entity ID we are looking for is a selector.
 		 * find out what it currently selects */
@@ -418,6 +422,12 @@ static int __uac3_clock_find_source(stru
 		ret = __uac3_clock_find_source(chip, fmt,
 					       selector->baCSourceID[ret - 1],
 					       visited, validate);
+		if (ret > 0) {
+			err = uac_clock_selector_set_val(chip, entity_id, cur);
+			if (err < 0)
+				return err;
+		}
+
 		if (!validate || ret > 0 || !chip->autoclock)
 			return ret;
 


