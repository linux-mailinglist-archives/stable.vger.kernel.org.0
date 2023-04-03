Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D726D48DF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjDCOcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjDCOck (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:32:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B323E5A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3698E61642
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6DCC433EF;
        Mon,  3 Apr 2023 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532351;
        bh=LaxIYNbHqf7qY6iMl1u/QsdgKbWswnQNq7WEczQzRQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9ok4HXHaSGtDaG5GzZ9FvKZ1HGZX7+PocxlA8wiEM9gHwxsdsIRtM9LKhe9RUyq/
         KgruuBSwt4rqQO1RbcMNVHsmxZG7gCevQXK9uYvn3uu1NDN5tQZih89mqEVD5l6HOb
         9dGzMvNV7dJwJvl2MMCzq4Z6GkWUHw/oPM+RBVzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/99] fbdev: lxfb: Fix potential divide by zero
Date:   Mon,  3 Apr 2023 16:08:42 +0200
Message-Id: <20230403140401.030302777@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 61ac4b86a4c047c20d5cb423ddd87496f14d9868 ]

var->pixclock can be assigned to zero by user. Without proper
check, divide by zero would occur in lx_set_clock.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/geode/lxfb_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index 66c81262d18f8..6c6b6efb49f69 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -234,6 +234,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
-- 
2.39.2



