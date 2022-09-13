Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F5D5B70E1
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiIMOdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiIMOcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D45E662;
        Tue, 13 Sep 2022 07:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA9CDB80F62;
        Tue, 13 Sep 2022 14:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A86C433C1;
        Tue, 13 Sep 2022 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078633;
        bh=0u026pqT58oZ4sONs/gvlH4NvnoS731D0/6bWyVkQHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxrJQ1Sz3mgFExpV7MqV3WQAvtVkMXkFwo0T4xV9ZH5HMd6cGwNaX8GeDldo+d6j9
         qc+pqfMjekiF84IcvNzb8vvZYnZ4oA2A2Ck0NumbyZYgoEq7lTyQ1PVHQh8CDk9U2T
         RwegtH/dqAM0STiroXHPdxAQpr5iHOSEgvGaZfuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shigeru Yoshida <syoshida@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/121] fbdev: fbcon: Destroy mutex on freeing struct fb_info
Date:   Tue, 13 Sep 2022 16:03:35 +0200
Message-Id: <20220913140358.382709793@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



