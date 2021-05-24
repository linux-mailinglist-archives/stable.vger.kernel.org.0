Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAA638EA48
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhEXOx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233268AbhEXOvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58F3361404;
        Mon, 24 May 2021 14:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867685;
        bh=KEQ/0Ebqgjat4KLoABYYVGqImSKblpiWCGpsPNRAMMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI+FArxpR2A5uT+0WDGTAz28e1pIrX1mIZCJ6Q/YgphSDUD57LTz3p9wWabnNvSW3
         G2en4Y70QXMSxlUXqqpuf9LjuLOepInzqa/JiyLwRbOrii4re41DlFzTe+lHC0jpMP
         JyKEpPKm0cLGijDamph/XJQbKfKTL35WaK/nrRJCSruIY8O3RnNHACQ7dvkgnQiRRD
         J4PT6Jp6nzvzCygWPRfbE75mCA9/mTT1Sb//7aEfvZ5O98SY30dATogvuhQJnVkbey
         wG3ktyCC59gYGJyFilXz3BweAPgtC7GwMH92ScxdKOEh7mNFGqUSxQs+PBR1uxtaUF
         QW3XXl1vSMCgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 17/62] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 24 May 2021 10:46:58 -0400
Message-Id: <20210524144744.2497894-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

[ Upstream commit a28591f61b60fac820c6de59826ffa710e5e314e ]

The field "fm_res" of "struct snd_sb8" is never used/dereferenced
throughout the sb8.c code. Therefore there is no need for any null value
check after the "request_region()".

Add a comment note to make developers know about this and prevent any
"NULL check" patches on this part of code.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-36-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb8.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 438109f167d6..fc1ba3d43265 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -94,7 +94,11 @@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)
 	acard = card->private_data;
 	card->private_free = snd_sb8_free;
 
-	/* block the 0x388 port to avoid PnP conflicts */
+	/*
+	 * Block the 0x388 port to avoid PnP conflicts.
+	 * No need to check this value after request_region,
+	 * as we never do anything with it.
+	 */
 	acard->fm_res = request_region(0x388, 4, "SoundBlaster FM");
 	if (!acard->fm_res) {
 		err = -EBUSY;
-- 
2.30.2

