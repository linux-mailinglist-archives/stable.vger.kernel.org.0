Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D26C570D
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbjCVUMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjCVULf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:11:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C957E79C;
        Wed, 22 Mar 2023 13:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25FE4622C5;
        Wed, 22 Mar 2023 20:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD611C433A4;
        Wed, 22 Mar 2023 20:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515437;
        bh=95OnjUFgts2qjKb/jFfpXjpPJsfmbkMLtlubSbuSs1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZhNtlNaVXORtAuIlQ1GBGDB1cWbiMqXwp8uj6+js39jOs/zvCXiwaSucpPT6Y+R6
         8EbZ1LvPiQ7zBPZCRb4rEQb2Zxy4XTyQr+wf3pAAFreDZOg28oU9rG6RiJlbk9v34m
         JTGpILDXiDVCGsIZ3irG+W2BDCbNIMWPHME4X3sqhnTzo43yhWcSq27zIZLtqVOJQb
         sT8B08hlhG95A4XGo44NQDsHdluoKVOIj6vIk97gCIDAYNJo549xAF7ntBkoWnuRBj
         l6tlzcPN/gJ9PebZk25s7fpN8wVnxZ0FcGnh8wOa87oJdLWyzE+BBnIMV8l1g1Jc/r
         UN98YXjlysiCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, mbroemme@libmpq.org,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 7/9] fbdev: intelfb: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:03:34 -0400
Message-Id: <20230322200337.1997810-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200337.1997810-1-sashal@kernel.org>
References: <20230322200337.1997810-1-sashal@kernel.org>
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

[ Upstream commit d823685486a3446d061fed7c7d2f80af984f119a ]

Variable var->pixclock is controlled by user and can be assigned
to zero. Without proper check, divide by zero would occur in
intelfbhw_validate_mode and intelfbhw_mode_to_hw.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/intelfb/intelfbdrv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index d7463a2a5d83f..c97c0c8514809 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -1215,6 +1215,9 @@ static int intelfb_check_var(struct fb_var_screeninfo *var,
 
 	dinfo = GET_DINFO(info);
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* update the pitch */
 	if (intelfbhw_validate_mode(dinfo, var) != 0)
 		return -EINVAL;
-- 
2.39.2

