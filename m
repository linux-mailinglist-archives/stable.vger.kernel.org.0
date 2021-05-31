Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA13395C14
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhEaN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhEaNZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 580B6613A9;
        Mon, 31 May 2021 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467267;
        bh=mjI5jnIhJf4B9tVcRxD5jIfP6JUfonP6mxS7E1kp0ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeOccULvnvW/jZvSyaa3H77V81pgAWrdQ2yEBSEqmDBvPht1weWabo+Du2M2YIpTL
         orxuEEfNnUP9oAZbJtS9dBhuOL6+vGayyHtH13moo03BmxU7EpoJ/sRSHN4W1SMjy5
         2zai0gWXYKeXkYELJZcKmnDvu6U9L/bJlFrF20Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 43/66] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 31 May 2021 15:14:16 +0200
Message-Id: <20210531130637.619014864@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ad42d2364199..ca4350bd24d1 100644
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
 
 	if (port[dev] != SNDRV_AUTO_PORT) {
-- 
2.30.2



