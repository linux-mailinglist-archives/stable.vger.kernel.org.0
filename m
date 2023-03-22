Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EA56C5633
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCVUDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjCVUC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:02:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D943A6B306;
        Wed, 22 Mar 2023 12:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C8D7B81DE9;
        Wed, 22 Mar 2023 19:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F786C433EF;
        Wed, 22 Mar 2023 19:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515162;
        bh=eMWDS+3wZyH867vHh4eJhuV+Y41uSSa2FKh5pK+WX4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Idu+DSZK1GWJGIdpbBu16lSYGKRzoySlUAQPHO/M4/DNg+v1GnbpMKd2jsTA7mqYA
         7hVrIBWo+2DSJuhtWyxQe4sw3KAIl9lK3sjpk1qfF8Vea4/t8vT3r1D+kfd4TfWVq8
         ositWFwiPeSLTl4EjJHFFjKZx3i9n/O2lUmesg1QMuM3lc/7yBcGGTyzoba5jgNgU1
         kmR6AM+urim3uXDhTp6SioUgeg2ghBimcwfngNQ8zrspwZQ8DsxQGknLuhF4L70Oes
         1lFMCD0Zh900UOsqgcfC9B5xiixbRb2ES7AQhh0dbvUz2CIWogl8Ablm9U5Lj/gR6U
         qTnL23qlA1ZwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 42/45] fbdev: au1200fb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 15:56:36 -0400
Message-Id: <20230322195639.1995821-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
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

