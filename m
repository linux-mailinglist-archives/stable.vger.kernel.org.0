Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45B94EC0F9
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245269AbiC3Lz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344768AbiC3Lxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA21126C2D8;
        Wed, 30 Mar 2022 04:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A30C2B81C25;
        Wed, 30 Mar 2022 11:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA5C340EE;
        Wed, 30 Mar 2022 11:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640969;
        bh=14VW2dm/D52DxBIO4T4GRlDqW5MH7hZuDbtQnnwcWvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzxyshauhoRBosIVvy8ymINBe2ZatLmS2cFjJqGCdOb4MK4QiG2elwkTuHBAuDfxQ
         3uHErzNwNg+hiFx7zM7SVRIi9cY0EW6pZDw8AyWPijpts9QqwbdLZA/j2FB91V1lQu
         YD9/xoufT/Y0NP7fdfJzGyATMXBakcM2pEagaTN2tPfMEKVHypEMVH29HV6LUcibQe
         /A8/O8qlPFE1hfEK9j34M/BDIRW/4KJzAVczGLi+e4kRWlQcGlHta05pGdxo4lUiJD
         +drZilpN/gwMZYNeRQQA3uhTAjYh0SCXBtZpDLNDx70V3EbnH25oe/iXIJ2OIyHBT/
         sKyTLuv6siwZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 37/59] media: imx-jpeg: fix a bug of accessing array out of bounds
Date:   Wed, 30 Mar 2022 07:48:09 -0400
Message-Id: <20220330114831.1670235-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

