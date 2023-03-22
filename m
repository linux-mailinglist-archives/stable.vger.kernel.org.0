Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2C6C56B7
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjCVUIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjCVUIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:08:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB00C6B95E;
        Wed, 22 Mar 2023 13:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19E1D622CA;
        Wed, 22 Mar 2023 20:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE279C433D2;
        Wed, 22 Mar 2023 20:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515275;
        bh=eMWDS+3wZyH867vHh4eJhuV+Y41uSSa2FKh5pK+WX4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcKFqSnc3k7sxgRGaz9e32zVyZIg9WGlNSXqTBfVvVAhchJDDc0OnB+ukKcVD7/hR
         l9OIyvX0EQPBLw23nkUuxPdzwDlDotF/Jlsao6R99JdH1cSg7Q1ydEqjTXt1Xrto90
         qhEcJs0qyaVgCsuvyDi2CefgMVQfpDqetRAH1SCCVF+OBPMj8/9w+xnhnqF/2JvDIX
         iwj/SE6qcjn5uRSoedY6GPsJHULUmdzx96VoseLndjD6rDtX9tZ4DPva07ClFJFarP
         VqFe064fO43QAEA9iuklo0JQGb4ecoboz8cJDbhrJetyzr8/h0F99HGDAwISjHN/ON
         vQ96crw/5GA1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 31/34] fbdev: au1200fb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 15:59:23 -0400
Message-Id: <20230322195926.1996699-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 44a3b36b42acfc433aaaf526191dd12fbb919fdb ]

var->pixclock can be assigned to zero by user. Without
proper check, divide by zero would occur when invoking
macro PICOS2KHZ in au1200fb_fb_check_var.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1200fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 81c3154544287..b6b22fa4a8a01 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1040,6 +1040,9 @@ static int au1200fb_fb_check_var(struct fb_var_screeninfo *var,
 	u32 pixclock;
 	int screen_size, plane;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	plane = fbdev->plane;
 
 	/* Make sure that the mode respect all LCD controller and
-- 
2.39.2

