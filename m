Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0375381A7
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbiE3OUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbiE3ORh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DD852B3D;
        Mon, 30 May 2022 06:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56A2CB80DAB;
        Mon, 30 May 2022 13:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5DCC36AE5;
        Mon, 30 May 2022 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918441;
        bh=3bAxwqz+PrEB3N97Cb5NFJS0jvNMxicYpIO/3MlF7Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkAZCaC1/epChvXTlixr09k3rK5VthSiO1L+80lZZK3B3nYhp21Sgy4oZObR7fC8J
         B1Bw70T2/qeyTRtV8Bj6g2BAISWzW9ZeYgOJ7+Qh+cFRqgZklrQvAUQWMcyYszfeAj
         vBIrDkjtjYqQcpo6YUOde4DpawZzeSCDyu9lYRxv3rYaeuz6rozheMDXdLRp1yhwrF
         MnGFUjmyVhaOoQOCqk5jIzDq/lR9HaaXmzRIEjQsQnERMkva734cJO+3gM2s+KOUL+
         l7NsSRhhcGl+CTMkuQumQ7rS8tzjG9nP+YUFGjDvbI5da4cwohUbEwCFtX+AbzFpC7
         DEpVOs/S+CGoA==
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
Subject: [PATCH AUTOSEL 5.4 07/55] fbcon: Consistently protect deferred_takeover with console_lock()
Date:   Mon, 30 May 2022 09:46:13 -0400
Message-Id: <20220530134701.1935933-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
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
index 75b770514067..1decded4845f 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -3286,6 +3286,9 @@ static void fbcon_register_existing_fbs(struct work_struct *work)
 
 	console_lock();
 
+	deferred_takeover = false;
+	logo_shown = FBCON_LOGO_DONTSHOW;
+
 	for_each_registered_fb(i)
 		fbcon_fb_registered(registered_fb[i]);
 
@@ -3303,8 +3306,6 @@ static int fbcon_output_notifier(struct notifier_block *nb,
 	pr_info("fbcon: Taking over console\n");
 
 	dummycon_unregister_output_notifier(&fbcon_output_nb);
-	deferred_takeover = false;
-	logo_shown = FBCON_LOGO_DONTSHOW;
 
 	/* We may get called in atomic context */
 	schedule_work(&fbcon_deferred_takeover_work);
-- 
2.35.1

