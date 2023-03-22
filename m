Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883E86C5707
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjCVULx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjCVULO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:11:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8646B313;
        Wed, 22 Mar 2023 13:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F6B5622C4;
        Wed, 22 Mar 2023 20:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ECEC433D2;
        Wed, 22 Mar 2023 20:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515358;
        bh=JTe0xHkN5NnrhCWXW2Eb6l1XG+VkIj9iPS/H5Nvw5dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgmHK9KcwqdTH0kSl0gvgaLYI8UimEifKJ0nFt1ku2q758N5ZF1pa5IRty05rmqMf
         7V8i3Thw5l4u9kXJdZ7BS68RTH9rnaUk3g054aKprOjwm4BFpwoDQA3db1so9DgAWr
         5+6nXkr2UlUD26j/02hoBpMXphi4rsfE03O6PNolSNiKQx67JC9ZCPluWE2y3uTj0y
         K5qhmMuSxbQdkIqlCzCoHtXdbXj+qd3lByTnGVMBKT32uBNHjKKvxLzOOl5UAdYh3e
         lR/hB6yN0n0c0oaC6xlqInyJLfNu801jziCSgpLQS5V3TDqGvoFB6qZG+DtIbEU9Qj
         5JLxUwb9cvQvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 10/12] fbdev: au1200fb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:02:04 -0400
Message-Id: <20230322200207.1997367-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200207.1997367-1-sashal@kernel.org>
References: <20230322200207.1997367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c00e01a173685..a8a0a448cdb5e 100644
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

