Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5183714FB
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhECMDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhECMCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0D5F6052B;
        Mon,  3 May 2021 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043297;
        bh=zrOtkaLm/l9X1+AuJwyMlhA0lTPTEdWoV8nT0VsgEzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWMd+beix5N8MNUJXo9Zs50LqX6wiCevwUfFXSbyPu8Q1m7A3ySg1qo1NTN+cISTq
         UDkT2L1JMTgUXOlUDO3BmTPwgQNuax0q+34ZUPajWsjsFOkQVXD96Tl3hMdrk02dT9
         K1qwd8hkDZEcTOdGIl7ERFufs7vdyB+wepANQQV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Takashi Iwai <tiwai@suse.de>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 34/69] Revert "ALSA: sb8: add a check for request_region"
Date:   Mon,  3 May 2021 13:57:01 +0200
Message-Id: <20210503115736.2104747-35-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sb/sb8.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 6c9d534ce8b6..95290ffe5c6e 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -95,10 +95,6 @@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)
 
 	/* block the 0x388 port to avoid PnP conflicts */
 	acard->fm_res = request_region(0x388, 4, "SoundBlaster FM");
-	if (!acard->fm_res) {
-		err = -EBUSY;
-		goto _err;
-	}
 
 	if (port[dev] != SNDRV_AUTO_PORT) {
 		if ((err = snd_sbdsp_create(card, port[dev], irq[dev],
-- 
2.31.1

