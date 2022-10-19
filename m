Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D58603E35
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiJSJL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiJSJKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:10:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4EBBA91E;
        Wed, 19 Oct 2022 02:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E7A3617D1;
        Wed, 19 Oct 2022 09:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52D2C433D7;
        Wed, 19 Oct 2022 09:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170004;
        bh=SPlFG2GdKVscxA6rjQ8dsy9EO2LGv3Cxg7UH6JBhp68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDl9e9q4n2ZLTIIIMqdE/2riJ4hFjyQ/IvjU5mj6i0vqH8X2QQrFl/YeRuYnhiKU+
         abViJrqum6Vi9ZDdcWRL2Hv+L/7JF3trW4Txu84/5y7w9rD1kp2Tp9tJx2e9fBGqFP
         1vCbbK1z5pO32HiGWfNlyrpqB7cqwAkeM8Q6qH2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 491/862] media: amphion: adjust the encoders value range of gop size
Date:   Wed, 19 Oct 2022 10:29:38 +0200
Message-Id: <20221019083311.690094528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 996f4e89fabe44ab9ac0aabb0697aeecbe717eca ]

adjust the value range of gop size from [0, 65535] to [1, 8000].
when the gop size is set to a too large value,
it may affect the encoded picture quality.
so constrain it to a reasonable range.

Fixes: 0401e659c1f92 ("media: amphion: add v4l2 m2m vpu encoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/venc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/venc.c b/drivers/media/platform/amphion/venc.c
index 461524dd1e44..37212f087fdd 100644
--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -644,7 +644,7 @@ static int venc_ctrl_init(struct vpu_inst *inst)
 			  BITRATE_DEFAULT_PEAK);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
-			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, (1 << 16) - 1, 1, 30);
+			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 8000, 1, 30);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
 			  V4L2_CID_MPEG_VIDEO_B_FRAMES, 0, 4, 1, 0);
-- 
2.35.1



