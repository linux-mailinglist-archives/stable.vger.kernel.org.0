Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CFD6578A9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiL1OxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiL1Owr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6A629B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B20FB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895BFC433EF;
        Wed, 28 Dec 2022 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239163;
        bh=jF7k2woVxKwoSoJD/hVQ/q62KY2Gd0WNONArFx3wDiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7C0AbtaNHZbsMCsBrlmsfARj174xw1wl32TMGNOklR11ORTDTL+0V52pTN8fJm8q
         pyMFMPqP/Cbk/bP6c6+46VCrZK4WKLfsaVKmmHE/NxpZNiuDV4+CzIjii+DY3iDAmR
         nCf70dKGDiicSTbVQ+HPoTFfBOhEGT/ZjzjRJLkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/731] media: v4l2-ctrls: Fix off-by-one error in integer menu control check
Date:   Wed, 28 Dec 2022 15:34:20 +0100
Message-Id: <20221228144300.988833282@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 45a76f40deeb..3798a57bbbd4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -1456,7 +1456,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		qmenu_int = v4l2_ctrl_get_int_menu(id, &qmenu_int_len);
 
-	if ((!qmenu && !qmenu_int) || (qmenu_int && max > qmenu_int_len)) {
+	if ((!qmenu && !qmenu_int) || (qmenu_int && max >= qmenu_int_len)) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
-- 
2.35.1



