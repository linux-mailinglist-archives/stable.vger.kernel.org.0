Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7FB55DC2F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbiF1Ca0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244786AbiF1C2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7100226113;
        Mon, 27 Jun 2022 19:26:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35783B81C00;
        Tue, 28 Jun 2022 02:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F112DC385A5;
        Tue, 28 Jun 2022 02:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383182;
        bh=ilvURhaxj9mgUg4uRt4O2KV1o5dU0YnE3UMEOl0buAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnkKtXh51UVZEpTkEv+7i2aB892a+iHBVksDjHU6HalaZzrR7Sf24zIIfOS9sfQt3
         Hqm6BAjqo5LxLifTKVtBjQjKOKWq6vHvArWtaoJlo1U+FSiG7Gm5D/0UvQ43il4zZo
         +QcALTJju95i+06ORx7McPZUjGlXbbmjrXtrHlUC+nmnbOHMGIxhjzaJlJea6Va2Nm
         a9CUnxYu27EZCPh6K/vYQ8OFZnk1lQvcFWZbSP3k8vmGbzsgwZouhAWiPOND5zdQF2
         74fyToGZjurbcL0q4qxJHtfbqwU+InXUfhzfu3hyaOWc/ggmf5Z4xabKvJoa9fuXhd
         LXM95Vo74i9Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniil Dementev <d.dementev@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 03/17] ALSA: usb-audio: US16x08: Move overflow check before array access
Date:   Mon, 27 Jun 2022 22:26:01 -0400
Message-Id: <20220628022615.596977-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022615.596977-1-sashal@kernel.org>
References: <20220628022615.596977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniil Dementev <d.dementev@ispras.ru>

[ Upstream commit 3ddbe35d9a2ebd4924d458e0246b4ba6c13bb456 ]

Buffer overflow could occur in the loop "while", due to accessing an
array element before checking the index.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Daniil Dementev <d.dementev@ispras.ru>
Reviewed-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/20220610165732.2904-1-d.dementev@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_us16x08.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index 7db3032e723a..5e3b7fd43fc2 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -647,10 +647,10 @@ static int snd_get_meter_comp_index(struct snd_us16x08_meter_store *store)
 		}
 	} else {
 		/* skip channels with no compressor active */
-		while (!store->comp_store->val[
+		while (store->comp_index <= SND_US16X08_MAX_CHANNELS
+			&& !store->comp_store->val[
 			COMP_STORE_IDX(SND_US16X08_ID_COMP_SWITCH)]
-			[store->comp_index - 1]
-			&& store->comp_index <= SND_US16X08_MAX_CHANNELS) {
+			[store->comp_index - 1]) {
 			store->comp_index++;
 		}
 		ret = store->comp_index++;
-- 
2.35.1

