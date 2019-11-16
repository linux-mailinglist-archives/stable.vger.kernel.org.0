Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C469FECF7
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfKPPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbfKPPlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:14 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F191320718;
        Sat, 16 Nov 2019 15:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918874;
        bh=8bxpyTayDO1IguOcBDdmMf7HebvpmIjmrxBF6bdJCP0=;
        h=From:To:Cc:Subject:Date:From;
        b=YHOUJwzorfLw24mP6SidXkWtgdFaY2rXYWahL5v2AMLebtLbsJjtZmCu8e7WU0XKI
         9qqLjQHLyH5e4/KRiRKwbDAVAZo7vNg3gWdGW4G8x6bikHllFbj9ppHv1WBWi615OA
         +5ZrLZ52h7tgqAwgDsLnDUX7dcCMWTVPz9BPd0eA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 001/237] ALSA: isight: fix leak of reference to firewire unit in error path of .probe callback
Date:   Sat, 16 Nov 2019 10:37:16 -0500
Message-Id: <20191116154113.7417-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 51e68fb0929c29e47e9074ca3e99ffd6021a1c5a ]

In some error paths, reference count of firewire unit is not decreased.
This commit fixes the bug.

Fixes: 5b14ec25a79b('ALSA: firewire: release reference count of firewire unit in .remove callback of bus driver')
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/isight.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/isight.c b/sound/firewire/isight.c
index 30957477e005e..0717ab9e48e3b 100644
--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -640,7 +640,7 @@ static int isight_probe(struct fw_unit *unit,
 	if (!isight->audio_base) {
 		dev_err(&unit->device, "audio unit base not found\n");
 		err = -ENXIO;
-		goto err_unit;
+		goto error;
 	}
 	fw_iso_resources_init(&isight->resources, unit);
 
@@ -669,12 +669,12 @@ static int isight_probe(struct fw_unit *unit,
 	dev_set_drvdata(&unit->device, isight);
 
 	return 0;
-
-err_unit:
-	fw_unit_put(isight->unit);
-	mutex_destroy(&isight->mutex);
 error:
 	snd_card_free(card);
+
+	mutex_destroy(&isight->mutex);
+	fw_unit_put(isight->unit);
+
 	return err;
 }
 
-- 
2.20.1

