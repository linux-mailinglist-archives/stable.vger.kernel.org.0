Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9AA6C5717
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjCVUMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjCVUMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:12:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA7B7E8AE;
        Wed, 22 Mar 2023 13:04:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5183FB81DE2;
        Wed, 22 Mar 2023 20:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1CFC433A1;
        Wed, 22 Mar 2023 20:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515409;
        bh=K0x3SRRa4HXHn+EKwSF6/erKOQgcKi+VGbc7NR6slpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZciWCCcQyE9Ueoepcl8Jmm3m3zhIlW6waxD8sYKz5anWRQjcbCQwfg+pmt5uD25Lo
         ksadbrbxl1HmE+sLdzL2Ev1ot5+pZOdlV8o84ZQvV+vFjdHhu9zO38MExqvK6B/BYO
         MlBN33md8IE5iGgREm38PreXAmm3hd0U5vHuVr1b5rl1U9PwbTcd+vAxHW083gvKVE
         XDHs8Oao/7KpKwBGKI3r5egZbXh2n+4NEzfSIv9FnuVDhX3KKRw+CZdoJiN6jW2mIb
         pnSW8iT8H9c4d4/sORbj6ugRtzcgbDdf7KvbC08BIR9zb55SuuhGCpC1xfJAzxlUqC
         8T03P9KxGJFQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Chen <harperchen1110@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, adaplas@gmail.com,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 6/9] fbdev: nvidia: Fix potential divide by zero
Date:   Wed, 22 Mar 2023 16:03:06 -0400
Message-Id: <20230322200309.1997651-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200309.1997651-1-sashal@kernel.org>
References: <20230322200309.1997651-1-sashal@kernel.org>
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
index fbeeed5afe350..aa502b3ba25ae 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -766,6 +766,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
-- 
2.39.2

