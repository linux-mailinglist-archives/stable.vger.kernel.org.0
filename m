Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DE6538259
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiE3OXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242304AbiE3OSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D8911CA3A;
        Mon, 30 May 2022 06:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DA260EC3;
        Mon, 30 May 2022 13:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD7CC385B8;
        Mon, 30 May 2022 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918583;
        bh=nCcNByXWT/diSi/kX4pWjohsR1ESAZBLN/o8dTNP/Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jef57TBEHeqhpfx7toOpn8puAImfUAJIyWrEoCKkv0bo7PaBBFu44SHjTw3dqUPhT
         /Tskl12YqYDSiYHDyC1fWd53ZBS4SDeIq8vuvMbCQz25+IbWfp6E5uKoyom9bW6vqO
         I1POBY+dBEs0t+3LiGPK4csIpIvYFv7klSM20HzLSncd219HTf4nUnk0eLrQSt72le
         BlLjbBWsmepQpSxlTw3dsQpa8egL02j6STE5aJkBT57fffZsvw6455fdFnCDuTFOZI
         y7UHvBBqgIXJaYmpbIrAgqjOm0AniWHq8atSGRMHe30UJz0a4ghEi4EEjCtCMX0Jhp
         osy4ZhfhttVlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, Du Cheng <ducheng2@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Claudio Suarez <cssk@net-c.es>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>, deller@gmx.de,
        geert@linux-m68k.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 07/38] fbcon: Consistently protect deferred_takeover with console_lock()
Date:   Mon, 30 May 2022 09:48:53 -0400
Message-Id: <20220530134924.1936816-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 43553559121ca90965b572cf8a1d6d0fd618b449 ]

This shouldn't be a problem in practice since until we've actually
taken over the console there's nothing we've registered with the
console/vt subsystem, so the exit/unbind path that check this can't
do the wrong thing. But it's confusing, so fix it by moving it a tad
later.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Du Cheng <ducheng2@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220405210335.3434130-14-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index bf7959fdf9f4..7c2582892eab 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -3314,6 +3314,9 @@ static void fbcon_register_existing_fbs(struct work_struct *work)
 
 	console_lock();
 
+	deferred_takeover = false;
+	logo_shown = FBCON_LOGO_DONTSHOW;
+
 	for_each_registered_fb(i)
 		fbcon_fb_registered(registered_fb[i]);
 
@@ -3331,8 +3334,6 @@ static int fbcon_output_notifier(struct notifier_block *nb,
 	pr_info("fbcon: Taking over console\n");
 
 	dummycon_unregister_output_notifier(&fbcon_output_nb);
-	deferred_takeover = false;
-	logo_shown = FBCON_LOGO_DONTSHOW;
 
 	/* We may get called in atomic context */
 	schedule_work(&fbcon_deferred_takeover_work);
-- 
2.35.1

