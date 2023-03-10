Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D536B48BC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjCJPGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbjCJPFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:05:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D05B5C6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7960B6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B7AC4339B;
        Fri, 10 Mar 2023 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460252;
        bh=H4+k/Z480BeGrJ8zw94AkGB9w6fmYN3hzRNi2vfHswc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0QfQx7mX/TP6MdYvt1bAovEafQBamhlfmqnoNzmAILiAq6gdYaGQ2qEdTBmkaFI9
         8J/rMn8DPqP74mJxJcwKDIbfyM6OOVgZGqieiCwRLxy1FtA+VkGLbPqtrm1eGGl4L6
         wfkaXsEpGrSDesi5cUMpsWT2MK8UyYd5AScF0CL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sameer Puri <purisame@spuri.io>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/529] media: i2c: imx219: remove redundant writes
Date:   Fri, 10 Mar 2023 14:36:56 +0100
Message-Id: <20230310133817.615104780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Puri <purisame@spuri.io>

[ Upstream commit fbef89886da6d7735d20fdde16a1ee6ed6c6ab56 ]

These writes to 0x162, 0x163 already appear earlier in the struct for
the 1920x1080 mode and do not need to be repeated.

Signed-off-by: Sameer Puri <purisame@spuri.io>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: ef86447e775f ("media: i2c: imx219: Fix binning for RAW8 capture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 4771d0ef2c46f..cad0a8df203ed 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -262,8 +262,6 @@ static const struct imx219_reg mode_1920_1080_regs[] = {
 	{0x4793, 0x10},
 	{0x4797, 0x0e},
 	{0x479b, 0x0e},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 };
 
 static const struct imx219_reg mode_1640_1232_regs[] = {
-- 
2.39.2



