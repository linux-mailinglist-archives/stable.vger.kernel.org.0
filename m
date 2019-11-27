Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D9810BD9F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfK0Va2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfK0Uzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49AFE2068E;
        Wed, 27 Nov 2019 20:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888144;
        bh=8bxpyTayDO1IguOcBDdmMf7HebvpmIjmrxBF6bdJCP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cF4IhWUULlHgwpl5FBkkpoqRytMNs0IUu7K+LK994cJItm5nT0uAxTCh2IW0fa0Ul
         CCDQ2BGMZL9PkwzDf3neapVD3QaeWI4Rc6uupf2TuTWjJRLbFf8Nsn8vzok/Ij4TqH
         mJBqa+zcvw0Xb9GVesrGXLCBFQZxH3vjMURMfmqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/306] ALSA: isight: fix leak of reference to firewire unit in error path of .probe callback
Date:   Wed, 27 Nov 2019 21:27:52 +0100
Message-Id: <20191127203116.313964901@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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



