Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C04657C0C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiL1P2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiL1P2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEBF140E8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28EB76152F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDAEC433EF;
        Wed, 28 Dec 2022 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241293;
        bh=P7pd974hiBCB1vAla5DqBGWjzr9aVuHFVaOpyD5UIp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnvksXx35iPdes2wlshSJLe6+hfafrXsdt5CFMc0tKE/ao2KkHRwlZ/uJ7EFNB8cn
         hH9jxS1gm9x6gipYTyZlAnurQJE9wVnCP6CNnpWyEGnEGxsfsT3twtTXIjmodY/BZN
         VA/2Exv64ns8vmecp70q4HI8Wq0OAlzt2pShexUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0229/1146] media: v4l2-ctrls: Fix off-by-one error in integer menu control check
Date:   Wed, 28 Dec 2022 15:29:28 +0100
Message-Id: <20221228144336.361707826@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit b6bcdf763db1f5ea602bf876cfe91debfb3c7773 ]

The V4L2 API defines the maximum value for an integer menu control as
the number of elements minus one. The v4l2_ctrl_new_std_menu() validates
this constraint with an off-by-one error. Fix it.

Fixes: d1e9b7c12b74 ("[media] V4L: Add support for integer menu controls with standard menu items")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-core.c b/drivers/media/v4l2-core/v4l2-ctrls-core.c
index 0dab1d7b90f0..29169170880a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -1827,7 +1827,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		qmenu_int = v4l2_ctrl_get_int_menu(id, &qmenu_int_len);
 
-	if ((!qmenu && !qmenu_int) || (qmenu_int && max > qmenu_int_len)) {
+	if ((!qmenu && !qmenu_int) || (qmenu_int && max >= qmenu_int_len)) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-- 
2.35.1



