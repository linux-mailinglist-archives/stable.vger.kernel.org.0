Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F0D615A24
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKBDZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiKBDZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:25:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF81025C71
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A875B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531F9C433D6;
        Wed,  2 Nov 2022 03:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359534;
        bh=BWEPFbJlvIupAqbOjujeWjkOkQz2VMqd1Hdh9IHx98E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSzJGyXXPaud02lGE4t4kwCjoYf7ZC3h8+Y4GbmMvcnYfGHVFgBq0l9T3Olg/us7d
         sgKaNjkeqtq6U2ubxlevTu9VgQjpIutlspv8bz9yyVSi7oWirFWe1ryiTkKq+Vi5a9
         BCJzyYTiSjhDG3Zbj8Ldgr9RzWYVlWwFUsIi+cWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 56/64] ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
Date:   Wed,  2 Nov 2022 03:34:22 +0100
Message-Id: <20221102022053.628613496@linuxfoundation.org>
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
index 17df288fbe98..4b01c51fbd33 100644
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



