Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09710BFC6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfK0UeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:34:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbfK0UeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:34:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3585207DD;
        Wed, 27 Nov 2019 20:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886862;
        bh=yaJoh/7AyG+itmJ2dxC94svgjgemr1sqw9xtDGBeWVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZLwl5wKwO38aczPKnRe1Hj4nFu++lz2OACLMgAjqCnfy2c8lANJvU084RHN0p2rZ
         xoDMXU+ohHHg+e3n/ATRhDW5jRQQJPpxZEopOUZf4oo4/aKHfY6VHQDpAxAN1FEhRa
         3wOh4vxpQq8aQDvoka6DM4WaY1GOHzrYdjrWYT0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 021/132] ALSA: isight: fix leak of reference to firewire unit in error path of .probe callback
Date:   Wed, 27 Nov 2019 21:30:12 +0100
Message-Id: <20191127202918.358266259@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 48d6dca471c6b..6c8daf5b391ff 100644
--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -639,7 +639,7 @@ static int isight_probe(struct fw_unit *unit,
 	if (!isight->audio_base) {
 		dev_err(&unit->device, "audio unit base not found\n");
 		err = -ENXIO;
-		goto err_unit;
+		goto error;
 	}
 	fw_iso_resources_init(&isight->resources, unit);
 
@@ -668,12 +668,12 @@ static int isight_probe(struct fw_unit *unit,
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



