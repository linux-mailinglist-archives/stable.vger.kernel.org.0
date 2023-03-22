Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970386C56B5
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjCVUIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjCVUIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C226B95A;
        Wed, 22 Mar 2023 13:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE03622C8;
        Wed, 22 Mar 2023 20:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6454C433A1;
        Wed, 22 Mar 2023 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515269;
        bh=ptpGmAS8u/6+zxN4lYnWnUq3KGp2DFwMEbw0d+MA0lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFeP3j8HaSD1bCvFBfHrLvAfNnMD9PXLZ2GvruQeuybfDNcjjdmRnL/M0/t/4R0Z3
         glvjiQ4L/3IHMtDSgUiUwZJp1F5gTh26MH/ekU79lx4K25VQuHOyhLY0NuCXurx+Bv
         dch8LibTAzP+etj52LOsdbNTApeOk70M0xNrqPgjUlU3m/T+U6gDBa5v9OD9dEyczD
         PIQoRe/70573zZXhbiMY5vdc+H4LS6l1aB7QIhgkOCezbYbZmz5YXCOriMBw79wvkX
         crN2+BNamHhCBVpTkcvSvgdJA+Fe3+ELOtTN5SMxWOfozasRHDcBXy5tNpTxiryrMH
         UffSBsXfhR1bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, adaplas@gmail.com,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 28/34] fbdev: nvidia: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 15:59:20 -0400
Message-Id: <20230322195926.1996699-28-sashal@kernel.org>
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

[ Upstream commit 92e2a00f2987483e1f9253625828622edd442e61 ]

variable var->pixclock can be set by user. In case it
equals to zero, divide by zero would occur in nvidiafb_set_par.

Similar crashes have happened in other fbdev drivers. There
is no check and modification on var->pixclock along the call
chain to nvidia_check_var and nvidiafb_set_par. We believe it
could also be triggered in driver nvidia from user site.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index a6c3bc2222463..1b8904824ad83 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -764,6 +764,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
-- 
2.39.2

