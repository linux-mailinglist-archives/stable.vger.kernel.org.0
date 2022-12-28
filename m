Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78452658288
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiL1Qhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiL1Qgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:36:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422F51D339
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3EA461572
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49E2C433F2;
        Wed, 28 Dec 2022 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245186;
        bh=mQbIv2qUL3Aql7ZHtr06ti+jxyPhAdZ9vVYJMTrCTSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riw2Xo1vEBLrQ4BLCYH7YhJcYg5DcEfFWGo9tnYmadk/6Yoh1V+DptLGNyYWEhqN9
         /cASjAVGGyQHGe2dmaE+6XgIfisG5G/h9PCCxztM17nyqFttULaY/8quNqRkO2nRoC
         /RDC8usPiwRj5kCKQZzGZ2rusuIevqTk5EaYc6AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alice Yuan <alice.yuan@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0847/1073] media: v4l2-ctrls-api.c: add back dropped ctrl->is_new = 1
Date:   Wed, 28 Dec 2022 15:40:35 +0100
Message-Id: <20221228144351.026655624@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 73278d483378cf850ade923a1107a70297b2602a ]

The patch adding support for dynamically allocated arrays accidentally
dropped the line setting ctrl->is_new to 1, thus new string values were
always ignored.

Fixes: fb582cba4492 ("media: v4l2-ctrls: add support for dynamically allocated arrays.")
Reported-by: Alice Yuan <alice.yuan@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-api.c b/drivers/media/v4l2-core/v4l2-ctrls-api.c
index 50d012ba3c02..7781ebd7ee95 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
@@ -155,6 +155,7 @@ static int user_to_new(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
 			 * then return an error.
 			 */
 			if (strlen(ctrl->p_new.p_char) == ctrl->maximum && last)
+			ctrl->is_new = 1;
 				return -ERANGE;
 		}
 		return ret;
-- 
2.35.1



