Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C35E38EB2F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhEXPBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234081AbhEXO5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1A461454;
        Mon, 24 May 2021 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867761;
        bh=YMUIRBqPsKnP1v3cJ/Dw9pNi02k97cYZ5bin7a9UhRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l950xGGA2GpFye5Jxh/0mDLOISZsits3vZ/FAarrSAC5h4wEap+cfOxWweUbpW2ur
         Vg/jPPMSozb5sTffvgeUtqmoUew7ZGTyiJ8ORkBuURKDhZYzoBq35tgXuK/4b0RRK9
         P3Y0JaxmOwcJISpEEr57GZz0ZuBrsTDRGSqGaCYLxJ4HkpUn/vlI0+4hrcLFupjAjB
         qCxrIvxE0jnAjrMO9h6NglaFJRAOOxhsaIAPvjfFynUJ8DfLIIjAHQZHPiFN/MdA1+
         HyUdsNH4cH26/OfuEodTFOeZCQFOJV2o6e51uxZBd8so93Uayy37ejO36kZJD77N13
         WK6/FpURdpQ2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 15/52] Revert "ALSA: usx2y: Fix potential NULL pointer dereference"
Date:   Mon, 24 May 2021 10:48:25 -0400
Message-Id: <20210524144903.2498518-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4667a6fc1777ce071504bab570d3599107f4790f ]

This reverts commit a2c6433ee5a35a8de6d563f6512a26f87835ea0f.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original patch was incorrect, and would leak memory if the error
path the patch added was hit.

Cc: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20210503115736.2104747-37-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usb_stream.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stream.c
index 091c071b270a..6bba17bf689a 100644
--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -91,12 +91,7 @@ static int init_urbs(struct usb_stream_kernel *sk, unsigned use_packsize,
 
 	for (u = 0; u < USB_STREAM_NURBS; ++u) {
 		sk->inurb[u] = usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);
-		if (!sk->inurb[u])
-			return -ENOMEM;
-
 		sk->outurb[u] = usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);
-		if (!sk->outurb[u])
-			return -ENOMEM;
 	}
 
 	if (init_pipe_urbs(sk, use_packsize, sk->inurb, indata, dev, in_pipe) ||
-- 
2.30.2

