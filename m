Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0B4F31B7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355753AbiDEKVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344824AbiDEJVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:21:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C99825EB4;
        Tue,  5 Apr 2022 02:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA8DB61571;
        Tue,  5 Apr 2022 09:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAEAC385A0;
        Tue,  5 Apr 2022 09:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149727;
        bh=TfW7T4LLiZbMAJKWnDbyoXtY7mFp1MuFCsVtbGpkdmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6FfJHaxe3fWRQBmfqvojtOlgBNEqiqJguY6ryANG9WixgA9VxBbY3BK23tsL6R78
         RIGgt+ZSH88Qmvwi7b84dSvgP7bYiwWFia728JHufLFrEdDHnMZe0HpueYBTk2py4s
         4lWu8fnR5bzktF9V/z3cRuUuyHdVa7esTdydgqRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0819/1017] video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit
Date:   Tue,  5 Apr 2022 09:28:52 +0200
Message-Id: <20220405070418.558876589@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit 24565bc4115961db7ee64fcc7ad2a7437c0d0a49 ]

coccinelle report:
./drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:
479:9-17: WARNING: use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
index 8d8b5ff7d43c..3696eb09b69b 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
@@ -476,7 +476,7 @@ static ssize_t show_cabc_available_modes(struct device *dev,
 	int i;
 
 	if (!ddata->has_cabc)
-		return snprintf(buf, PAGE_SIZE, "%s\n", cabc_modes[0]);
+		return sysfs_emit(buf, "%s\n", cabc_modes[0]);
 
 	for (i = 0, len = 0;
 	     len < PAGE_SIZE && i < ARRAY_SIZE(cabc_modes); i++)
-- 
2.34.1



