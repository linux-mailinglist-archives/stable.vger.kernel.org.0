Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC0615A25
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiKBDZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiKBDZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F6925C63
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C60CB82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09ECDC433C1;
        Wed,  2 Nov 2022 03:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359540;
        bh=+b6VJPonBh3qqb0jVY+f5reKcq2Rb6fNzWOkZMt2STk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vAH62RDAVvouSGn90QQMHbYCtmpeIGN1GnRTer70F2XwEaDOybnE5FXiL+7n69fK
         rXxHpHgwoG1K0OuEzfPlYkMN22xv4NjmCKNmHJcfeNHfJv7zbKBmJlvcAaPhONVymr
         oMbM5VYaAEh5enQBPiCjzGqkuEvqZEWIwLbev9tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/64] ALSA: aoa: Fix I2S device accounting
Date:   Wed,  2 Nov 2022 03:34:23 +0100
Message-Id: <20221102022053.661244664@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f1fae475f10a26b7e34da4ff2e2f19b7feb3548e ]

i2sbus_add_dev() is supposed to return the number of probed devices,
i.e. either 1 or 0.  However, i2sbus_add_dev() has one error handling
that returns -ENODEV; this will screw up the accumulation number
counted in the caller, i2sbus_probe().

Fix the return value to 0 and add the comment for better understanding
for readers.

Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Link: https://lore.kernel.org/r/20221027065233.13292-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/aoa/soundbus/i2sbus/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 4b01c51fbd33..3f5ee9f96ef1 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -147,6 +147,7 @@ static int i2sbus_get_and_fixup_rsrc(struct device_node *np, int index,
 	return rc;
 }
 
+/* Returns 1 if added, 0 for otherwise; don't return a negative value! */
 /* FIXME: look at device node refcounting */
 static int i2sbus_add_dev(struct macio_dev *macio,
 			  struct i2sbus_control *control,
@@ -213,7 +214,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 	 * either as the second one in that case is just a modem. */
 	if (!ok) {
 		kfree(dev);
-		return -ENODEV;
+		return 0;
 	}
 
 	mutex_init(&dev->lock);
-- 
2.35.1



