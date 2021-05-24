Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C62B38EBD6
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhEXPHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234500AbhEXPEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4830A613B6;
        Mon, 24 May 2021 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867848;
        bh=03uit3HcRgBQorQUpuon9ip1oRKD6umUP7MMKYqtLKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIGa5UnZ0V/aQj4egiAIJ/aIdWY5wbAXBhTGK+9pPUTN1jgKBe70Hw3dUO5r9yk4j
         3f/xub0b4FZU7yd0B3qZPMQT5Y2l/Rkrm0Z/vDp85tdmcCNpWosBHa5iD1SltwMuey
         VvZMhkS/Xk/GgAv2YJBcWYh+lyl5POdnpb/06vdH0jEEHq7o4kbg67tMUYVTGnc2Yl
         qk9G5KrYSftvyhSfMba+jxsQKbZdn0u5OVB7kNA8EwS7Zwq3U+mH0W2biE9cm2NH1E
         2tK2hvDu1bBCJU/obAt8LojxjMZ4GmPccR8V7VrvyhfabxLmNz7QllycLUiGtW7Kap
         9rkuOd7Jb/BdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 06/21] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 24 May 2021 10:50:25 -0400
Message-Id: <20210524145040.2499322-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
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
index 1eb8b61a185b..fb59e5179075 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -109,7 +109,11 @@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)
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

