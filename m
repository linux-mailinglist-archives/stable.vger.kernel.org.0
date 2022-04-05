Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992034F2775
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiDEIGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiDEH6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4F729C9E;
        Tue,  5 Apr 2022 00:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 622D8B81A32;
        Tue,  5 Apr 2022 07:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC266C3410F;
        Tue,  5 Apr 2022 07:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145179;
        bh=zTGxfhkK5wluCdAjhpp4Ym61n6JhTc9Lz1TCOvhc6Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy2TErkG6qkaKitgJ1RnvFbkaYKRwu7InmALxgbgcjTFZVoEgel5Iq7q44L4hqy+J
         Uj6nfxu/a3O3SzSZH6Ep6qAA/7ecFkzCumb6mdtkHrp9HzhDsp3CFiYoKs+LojlPx+
         +7aWtCIaLUj0V6PicAt8GsItm31OF8mFpu1xtdv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0314/1126] media: ov5648: Dont pack controls struct
Date:   Tue,  5 Apr 2022 09:17:41 +0200
Message-Id: <20220405070416.832916923@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



