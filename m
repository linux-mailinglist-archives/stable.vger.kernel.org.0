Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEBC5A6A3A
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiH3R07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiH3R03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A881D1286DE;
        Tue, 30 Aug 2022 10:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11005617AD;
        Tue, 30 Aug 2022 17:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA20C433C1;
        Tue, 30 Aug 2022 17:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880182;
        bh=0u026pqT58oZ4sONs/gvlH4NvnoS731D0/6bWyVkQHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWHRsU7H7D+0sz6Lphzcqzy5cL91tzBv2tttGNKbB3wZxABsqMGIkphdPuXnLFaJT
         MgdO6kEKKz3fbMYxFpgrn/q6P50oWyVVYCRxzASa+7uyJzObRVm3v1NNXr+EqrQS6H
         LpMEhv12CUB4pc1W1EoMD/RwkEyjz1fDEKoLP5KTMKzcolCKqRcYMjuinAenvaY4S9
         ojGweagA91xzclNzavjM0hki9TNHHm9o4tzOZRRBNPiLSYa4CjK0ZdW+WHK4BeV14a
         McIsC2lDke8oUeEd16tRZn43RNovCKQcxZf0GVrsTasbeleNLo64O2Xu+GlNxsD8Zf
         8gN4u9/exMr7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        daniel@ffwll.ch, tzimmermann@suse.de, sam@ravnborg.org,
        javierm@redhat.com, wangqing@vivo.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 21/23] fbdev: fbcon: Destroy mutex on freeing struct fb_info
Date:   Tue, 30 Aug 2022 13:21:38 -0400
Message-Id: <20220830172141.581086-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172141.581086-1-sashal@kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 58559dfc1ebba2ae0c7627dc8f8991ae1984c6e3 ]

It's needed to destroy bl_curve_mutex on freeing struct fb_info since
the mutex is embedded in the structure and initialized when it's
allocated.

Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index ce699396d6bad..09ee27e7fc25f 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -84,6 +84,10 @@ void framebuffer_release(struct fb_info *info)
 	if (WARN_ON(refcount_read(&info->count)))
 		return;
 
+#if IS_ENABLED(CONFIG_FB_BACKLIGHT)
+	mutex_destroy(&info->bl_curve_mutex);
+#endif
+
 	kfree(info->apertures);
 	kfree(info);
 }
-- 
2.35.1

