Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F626214B2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiKHOEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbiKHOEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4CB21B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:04:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B3B16158F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE7DC433D6;
        Tue,  8 Nov 2022 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916247;
        bh=82EMhrKD2k3Vq0UgIqRPxIdSREuBfT+AGF/x/ED5Ek8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1dXH1U4IlDv1HOJLawqZTw2ufz8+GeowwOU1MFAXVI+24BJJF/zuBVgG/BBpXapw
         kk0IO+HYVpEc+2k/bYkIaNP0UBE08NazEs+rpI9hd1zgur17EiprGXoZodLKNcQRjx
         p2gWqvRUroAtKsX0GswUw44EYiWVQda0BuGBzjKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/144] media: v4l: subdev: Fail graciously when getting try data for NULL state
Date:   Tue,  8 Nov 2022 14:39:14 +0100
Message-Id: <20221108133348.552365291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2ba3e38517f5a4ebf9c997168079dca01b7f9fc6 ]

The state argument for the functions for obtaining various parts of the
state is NULL if it is called by drivers for active state. Fail graciously
in that case instead of dereferencing a NULL pointer.

Suggested-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/v4l2-subdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 95ec18c2f49c..9a476f902c42 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -995,6 +995,8 @@ v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_state *state,
 			   unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_fmt;
@@ -1013,6 +1015,8 @@ v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
 			 struct v4l2_subdev_state *state,
 			 unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_crop;
@@ -1031,6 +1035,8 @@ v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_state *state,
 			    unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_compose;
-- 
2.35.1



