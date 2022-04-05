Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF5A4F3610
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiDEK6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346701AbiDEJpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBD8316;
        Tue,  5 Apr 2022 02:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C970616C1;
        Tue,  5 Apr 2022 09:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67247C385A0;
        Tue,  5 Apr 2022 09:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151083;
        bh=zTGxfhkK5wluCdAjhpp4Ym61n6JhTc9Lz1TCOvhc6Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFVLaoE1KfX/sWJwJDFtaBr4aCAJIZRMlkZMowBpjqsYuzsHqwSrOl6b/8igfnO6x
         ILy8tQkJU+O8s0BPVQ6IHfvWgZkj4TI0GE/GHS5WATmnDXHUkL0y/la6ZL/lte5U1O
         Woyehf6hv6bhp/p7IlctEdw79B4rPYAXV73TNCro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/913] media: ov5648: Dont pack controls struct
Date:   Tue,  5 Apr 2022 09:22:28 +0200
Message-Id: <20220405070348.431001363@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit edd4fbff5378a8103470304809195dc8f4b1d42a ]

Don't pack the driver specific struct containing control pointers. This
lead to potential alignment issues when working with the pointers.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e43ccb0a045f ("media: i2c: Add support for the OV5648 image sensor")
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5648.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5648.c b/drivers/media/i2c/ov5648.c
index 947d437ed0ef..78040f0ac02f 100644
--- a/drivers/media/i2c/ov5648.c
+++ b/drivers/media/i2c/ov5648.c
@@ -639,7 +639,7 @@ struct ov5648_ctrls {
 	struct v4l2_ctrl *pixel_rate;
 
 	struct v4l2_ctrl_handler handler;
-} __packed;
+};
 
 struct ov5648_sensor {
 	struct device *dev;
-- 
2.34.1



