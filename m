Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7135D38EFC7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhEXP7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235580AbhEXP6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C47B61978;
        Mon, 24 May 2021 15:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871079;
        bh=7PxR9ovQEYCrhRqNfAM5PNlPcbvO8Qr4DQMXlflW7xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qx5jI2Wck5hCcXP6wUp4fgFN8mebBWVlEy5zV+dP60HY/l1gQtBIO3Rjy2FdrfFvv
         6hyrToJbCrRhFVcm13Y45bzl03Ux6CvkJ508Ka8C7e0OnEizYugDauEeiSSNR/VCbt
         jZwSoL0CXvNKZKvDsCFPrBsPnqY68gl3RjdAKG+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 051/127] Revert "ALSA: sb8: add a check for request_region"
Date:   Mon, 24 May 2021 17:26:08 +0200
Message-Id: <20210524152336.572385888@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 94f88309f201821073f57ae6005caefa61bf7b7e upstream.

This reverts commit dcd0feac9bab901d5739de51b3f69840851f8919.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit message for this change was incorrect as the code
path can never result in a NULL dereference, alluding to the fact that
whatever tool was used to "find this" is broken.  It's just an optional
resource reservation, so removing this check is fine.

Cc: Kangjie Lu <kjlu@umn.edu>
Acked-by: Takashi Iwai <tiwai@suse.de>
Fixes: dcd0feac9bab ("ALSA: sb8: add a check for request_region")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-35-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sb/sb8.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -95,10 +95,6 @@ static int snd_sb8_probe(struct device *
 
 	/* block the 0x388 port to avoid PnP conflicts */
 	acard->fm_res = request_region(0x388, 4, "SoundBlaster FM");
-	if (!acard->fm_res) {
-		err = -EBUSY;
-		goto _err;
-	}
 
 	if (port[dev] != SNDRV_AUTO_PORT) {
 		if ((err = snd_sbdsp_create(card, port[dev], irq[dev],


