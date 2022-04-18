Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D25150567D
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbiDRNg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243318AbiDRNdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:33:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C2923BEE;
        Mon, 18 Apr 2022 05:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6F80B80EC0;
        Mon, 18 Apr 2022 12:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5A3C385A1;
        Mon, 18 Apr 2022 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286674;
        bh=i+ke+0LyftTFAtgMY5X7MwRW8EZFbLFNvYR/L4nrTng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYf/meExEpBOiqouwIekXLZBKSzjTZ/s7klUF36+uTqxE1oQuZe/ja9sIawmYwYuJ
         1u/zkdlfUKD5ILtExuKpouMfIeuUkvLj8pa1FkueU/MGvveKaDFn44wNWxtslzILvq
         K45jzP5SxMTUYUZmcHXfISUplPlMDRH/arJRFpVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Jing Yao <yao.jing2@zte.com.cn>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/284] video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()
Date:   Mon, 18 Apr 2022 14:12:33 +0200
Message-Id: <20220418121216.633458998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jing Yao <yao.jing2@zte.com.cn>

[ Upstream commit c07a039cbb96748f54c02995bae8131cc9a73b0a ]

Use sysfs_emit instead of scnprintf, snprintf or sprintf.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
index ea8c79a42b41..3f1389bfba6f 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
@@ -173,7 +173,7 @@ static ssize_t tpo_td043_vmirror_show(struct device *dev,
 {
 	struct panel_drv_data *ddata = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ddata->vmirror);
+	return sysfs_emit(buf, "%d\n", ddata->vmirror);
 }
 
 static ssize_t tpo_td043_vmirror_store(struct device *dev,
@@ -203,7 +203,7 @@ static ssize_t tpo_td043_mode_show(struct device *dev,
 {
 	struct panel_drv_data *ddata = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ddata->mode);
+	return sysfs_emit(buf, "%d\n", ddata->mode);
 }
 
 static ssize_t tpo_td043_mode_store(struct device *dev,
-- 
2.34.1



