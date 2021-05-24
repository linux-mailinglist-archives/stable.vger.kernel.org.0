Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6767938EB1C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhEXPAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234062AbhEXO5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D35861451;
        Mon, 24 May 2021 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867760;
        bh=yjZF0J6TfZHj07f4MxBb7n/kwPtSE0y/Ah6EfN95PPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=It1/+O4MmZGkoGlCRulVLYLm0cgUWWEHsUEubU55ESa9uUG92DV2js6T+gqdxtEqq
         rdjZKF97FvjZndZ8ZYjMdnV+OdCkBjl4HwI3IHfJHPY2W0DS6yuoS0NJFXDygYw9ZY
         U5unuuwf6EoXQ9+tz9AQNZLCGgRuPHFfWBOQXE67LoatHEiJ91e2Ilnh0x78mUpW3t
         tpggi7v/CQf0GWfnSD5tS/NTqijuGUJUn2llnLpkW/i8hu1mjGRkCBqAs/Zj2l4MGF
         xu7EzPCGr5WnFzMUVwzoLINsWWNltnXfzyv4m73bhiwAcNeCo+/1vAt8+7ir0qkNiv
         qHU3ATohstOyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 14/52] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 24 May 2021 10:48:24 -0400
Message-Id: <20210524144903.2498518-14-sashal@kernel.org>
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
index d67eae3988bd..77bedfe33eea 100644
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

