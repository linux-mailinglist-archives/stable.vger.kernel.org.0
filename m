Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DBF658385
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbiL1Qs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiL1QsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CE31EACB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C5A9B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE2AC433D2;
        Wed, 28 Dec 2022 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245805;
        bh=5yayHGXZKCtbh55eVQ/yzAYvOCklKzsaeHQnR5tzAdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERifjSf7wC8zC98bHHSM7bh6L+6MlLROOq/xwlTjJTJTutEZB/l2P0vBDd2fc66je
         M8L3WVqlDY6uoOQXqQ/a+EyGBx7YK4czQgPwvPXoG6p9pc0Lxv2OKn/NA7J/gdBr+u
         5ivOufAhIEE4eISqt8lPAZoSkYLEBgRB03RupinY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0925/1146] mailbox: arm_mhuv2: Fix return value check in mhuv2_probe()
Date:   Wed, 28 Dec 2022 15:41:04 +0100
Message-Id: <20221228144355.398309528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 165b7643f2df890066b1b4e8a387888a600ca9bf ]

If devm_of_iomap() fails, it returns ERR_PTR() and never
return NULL, so replace NULL pointer check with IS_ERR()
to fix this problem.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhuv2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index a47aef8df52f..c6d4957c4da8 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -1062,8 +1062,8 @@ static int mhuv2_probe(struct amba_device *adev, const struct amba_id *id)
 	int ret = -EINVAL;
 
 	reg = devm_of_iomap(dev, dev->of_node, 0, NULL);
-	if (!reg)
-		return -ENOMEM;
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
 
 	mhu = devm_kzalloc(dev, sizeof(*mhu), GFP_KERNEL);
 	if (!mhu)
-- 
2.35.1



)
 
 	state = ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE;
 	if (!IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch) ||
-	    ctx->current_codec == V4L2_PIX_FMT_VP8_FRAME || ret) {
+	    ctx->current_codec == V4L2_PIX_FMT_VP8_FRAME) {
 		v4l2_m2m_buf_done_and_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx, state);
 		if (src_buf_req)
 			v4l2_ctrl_request_complete(src_buf_req, &ctx->ctrl_hdl);
-- 
2.35.1



