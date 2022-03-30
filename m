Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BFB4EC080
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343996AbiC3LvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343964AbiC3LuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C1326F222;
        Wed, 30 Mar 2022 04:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52155B81C25;
        Wed, 30 Mar 2022 11:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEEC340F2;
        Wed, 30 Mar 2022 11:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640862;
        bh=14VW2dm/D52DxBIO4T4GRlDqW5MH7hZuDbtQnnwcWvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuOfHYpBbeYcp/I4TKzglIkqG73PcP/oe4eursp5Wr/2VIumfz/rwjy1bHdFdWu1r
         9Y7J4XZoQoAMrm4uEMs20bTsESXcA22USABO9AA9lxW+KhtdPzvXJvQSBPldhZDJF5
         xr6yI7fzBgued4bNEa+Hvm5MMNbZs4T2Wl2UWSkV51GT3pjegZ8Ha9FjXz4sagFGNb
         tZvWPVc5iZAQDBUth2TZ2NLXcTTZk/U6PkerJUyOU6cldjmsQnBbKobBZm6vt2X8uh
         i2iCQ15aTanqeBuWAiLXa4qlFxwFNVXWOOdMPFs5AZs0Dm95vhHD+EzKE1dRZbRwuK
         MpT08QRvp3fRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 37/66] media: imx-jpeg: fix a bug of accessing array out of bounds
Date:   Wed, 30 Mar 2022 07:46:16 -0400
Message-Id: <20220330114646.1669334-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 97558d170a1236280407e8d29a7d095d2c2ed554 ]

When error occurs in parsing jpeg, the slot isn't acquired yet, it may
be the default value MXC_MAX_SLOTS.
If the driver access the slot using the incorrect slot number, it will
access array out of bounds.
The result is the driver will change num_domains, which follows
slot_data in struct mxc_jpeg_dev.
Then the driver won't detach the pm domain at rmmod, which will lead to
kernel panic when trying to insmod again.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index b249c1bbfac8..83a2b4d13bad 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -954,7 +954,6 @@ static void mxc_jpeg_device_run(void *priv)
 		jpeg_src_buf->jpeg_parse_error = true;
 	}
 	if (jpeg_src_buf->jpeg_parse_error) {
-		jpeg->slot_data[ctx->slot].used = false;
 		v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
-- 
2.34.1

