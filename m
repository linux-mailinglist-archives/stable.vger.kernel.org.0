Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2992D4F2ACC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiDEIjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiDEIZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E7213CF4;
        Tue,  5 Apr 2022 01:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC92AB81BB0;
        Tue,  5 Apr 2022 08:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36642C385A0;
        Tue,  5 Apr 2022 08:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146833;
        bh=TfW7T4LLiZbMAJKWnDbyoXtY7mFp1MuFCsVtbGpkdmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTLDnsH+y+O+GqIZCeuTTtl687sTa+TMGk6XW0y1Fd0uBWm+ATpYyH+JVddNvapKr
         KZVOT1nIiDipSuZPM9HkR8lo9I476nlNPqF+aGVwdvqsUH5EdAcADhkpN9kazerQXy
         LaLLqnDtWLdRt/0dV5FOFjUWxXtvzaAhfIkqS2zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0905/1126] video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit
Date:   Tue,  5 Apr 2022 09:27:32 +0200
Message-Id: <20220405070434.093050568@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



