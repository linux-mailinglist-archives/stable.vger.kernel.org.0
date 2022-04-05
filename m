Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F474F44CA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353228AbiDEMW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344418AbiDEKjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C64926AFB;
        Tue,  5 Apr 2022 03:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD156141D;
        Tue,  5 Apr 2022 10:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D15C385A0;
        Tue,  5 Apr 2022 10:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154306;
        bh=+wq173W039LLwt49okhsC1cU/Yg0EMixvemiQqA7vmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWtP/X5h8zjMQagFoUKseIiNvCaEuX6rUADjTZn8i2VJcE99e26JB3mMAOKDm+XaG
         LS0DzGQAk/TDXhO1ABDtVubx99QtP388J8DoDul8G0S6IagQdPGm9RS7gFWiaU2aL0
         YFHGF+Takub6w0LIeSNrR+i6652tXuOAsU+yLwkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Jing Yao <yao.jing2@zte.com.cn>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/599] video: fbdev: omapfb: panel-dsi-cm: Use sysfs_emit() instead of snprintf()
Date:   Tue,  5 Apr 2022 09:33:09 +0200
Message-Id: <20220405070313.559022323@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jing Yao <yao.jing2@zte.com.cn>

[ Upstream commit f63658a59c3d439c8ad7b290f8ec270980e0f384 ]

Use sysfs_emit instead of scnprintf, snprintf or sprintf.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
index 4b0793abdd84..a2c7c5cb1523 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
@@ -409,7 +409,7 @@ static ssize_t dsicm_num_errors_show(struct device *dev,
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", errors);
+	return sysfs_emit(buf, "%d\n", errors);
 }
 
 static ssize_t dsicm_hw_revision_show(struct device *dev,
@@ -439,7 +439,7 @@ static ssize_t dsicm_hw_revision_show(struct device *dev,
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x\n", id1, id2, id3);
+	return sysfs_emit(buf, "%02x.%02x.%02x\n", id1, id2, id3);
 }
 
 static ssize_t dsicm_store_ulps(struct device *dev,
@@ -487,7 +487,7 @@ static ssize_t dsicm_show_ulps(struct device *dev,
 	t = ddata->ulps_enabled;
 	mutex_unlock(&ddata->lock);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", t);
+	return sysfs_emit(buf, "%u\n", t);
 }
 
 static ssize_t dsicm_store_ulps_timeout(struct device *dev,
@@ -532,7 +532,7 @@ static ssize_t dsicm_show_ulps_timeout(struct device *dev,
 	t = ddata->ulps_timeout;
 	mutex_unlock(&ddata->lock);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", t);
+	return sysfs_emit(buf, "%u\n", t);
 }
 
 static DEVICE_ATTR(num_dsi_errors, S_IRUGO, dsicm_num_errors_show, NULL);
-- 
2.34.1



