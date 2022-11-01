Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1096148A1
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiKAL2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiKAL2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396D8192AE;
        Tue,  1 Nov 2022 04:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D80D9B81CC6;
        Tue,  1 Nov 2022 11:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B3BC433C1;
        Tue,  1 Nov 2022 11:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302076;
        bh=aWWKt+ul8OJyODn7hJWxMis7sxtGLPT1ptklxe2XRB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTpEV75bOoriK477S73KlZPt2tlhgQAZjmFRs8Vf1ol//W1F8+NyGrLA7oIS8NXPk
         gsqsYoUqTaXGYfmk7bmiyq1atDQKIbqRbgi8rmc/EpUXJgllLq2rhNetLpnN4eQ4Ia
         ARkTCwlobxRy0rkDwc+v+I7wkalxKkGdeD/bzmU5/yaC0OovV8uBL9XLjyQlcL6rZK
         YlYPsmuKHkamHyhg5vcOAffO8N9Gw2xYpKKYI9xPD0dE3J1QLnusiIUT47jYJfyctZ
         FzNmddgLimRaQAUm6MJKPTvyuMyhuL+eCwlpveBUAB/oE5SzxiQpFUhYV1k3cj9/tv
         sniq9QXODflCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 14/34] media: v4l: subdev: Fail graciously when getting try data for NULL state
Date:   Tue,  1 Nov 2022 07:27:06 -0400
Message-Id: <20221101112726.799368-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 9689f38a0af1..ec1896886dbd 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1046,6 +1046,8 @@ v4l2_subdev_get_pad_format(struct v4l2_subdev *sd,
 			   struct v4l2_subdev_state *state,
 			   unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_fmt;
@@ -1064,6 +1066,8 @@ v4l2_subdev_get_pad_crop(struct v4l2_subdev *sd,
 			 struct v4l2_subdev_state *state,
 			 unsigned int pad)
 {
+	if (WARN_ON(!state))
+		return NULL;
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &state->pads[pad].try_crop;
@@ -1082,6 +1086,8 @@ v4l2_subdev_get_pad_compose(struct v4l2_subdev *sd,
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

