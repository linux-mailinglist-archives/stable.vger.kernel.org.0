Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CAB6159CB
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKBDSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKBDSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:18:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29AC24BD4
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D64617BC
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43E1C433D6;
        Wed,  2 Nov 2022 03:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359098;
        bh=lt4ODK7q561exU9L7glSBJMdspMOqRXaoq3qZoLUqps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpZ4/Mnoztcb+4FEg0GYide7rMgDIZFQwIqE5HmiLwV67WNjULHAbAY0S4XTwHnRA
         p/v94NmS70A19b517n+UJVp/xn72+hkYOEruw9buBMEvc5J7XqXQCRsvuMDjMYWqwK
         BcKuvJAlxwynalg4eUfoD0Xty5jwMSU76cWt8FSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 76/91] ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
Date:   Wed,  2 Nov 2022 03:33:59 +0100
Message-Id: <20221102022057.206822635@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4a4c8482e370d697738a78dcd7bf2780832cb712 ]

dev_set_name() in soundbus_add_one() allocates memory for name, it need be
freed when of_device_register() fails, call soundbus_dev_put() to give up
the reference that hold in device_initialize(), so that it can be freed in
kobject_cleanup() when the refcount hit to 0. And other resources are also
freed in i2sbus_release_dev(), so it can return 0 directly.

Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221027013438.991920-1-yangyingliang@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/aoa/soundbus/i2sbus/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index faf6b03131ee..f6841daf9e3b 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -302,6 +302,10 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	if (soundbus_add_one(&dev->sound)) {
 		printk(KERN_DEBUG "i2sbus: device registration error!\n");
+		if (dev->sound.ofdev.dev.kobj.state_initialized) {
+			soundbus_dev_put(&dev->sound);
+			return 0;
+		}
 		goto err;
 	}
 
-- 
2.35.1



