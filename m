Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28054603E74
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiJSJPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiJSJNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503A4CA8A5;
        Wed, 19 Oct 2022 02:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3AE617F1;
        Wed, 19 Oct 2022 08:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FC2C433C1;
        Wed, 19 Oct 2022 08:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169676;
        bh=a9QnuAj57d0g4YM0AcqhAV4WtYyzOmeBc0b2HC4WlRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lunRCWzLYVB2vT0runN1HkG0XOkFa7cLhfkdN3VT7ZkNrNjPEecNhuWMEcdjXcHwt
         eweu3aPiYJBrrJ3lbnaubLu+iGth2Z3WN+gchiOfLpfsz1R377lj1HUhd45h4BzXBt
         xK3eeaJzHDluXM2v1DJtd/WPllGdmZIKTzxWjXFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 366/862] drm/virtio: Fix same-context optimization
Date:   Wed, 19 Oct 2022 10:27:33 +0200
Message-Id: <20221019083306.183088706@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 3007dc2af6e86ac00b4daf7414142637fdf50bfa ]

When VIRTGPU_EXECBUF_RING_IDX is used, we should be considering the
timeline that the EB if running on rather than the global driver fence
context.

Fixes: 85c83ea915ed ("drm/virtio: implement context init: allocate an array of fence contexts")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: http://patchwork.freedesktop.org/patch/msgid/20220812224001.2806463-1-robdclark@gmail.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 9b2702116f93..3b1701607aae 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -168,7 +168,7 @@ static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
 		 * array contains any fence from a foreign context.
 		 */
 		ret = 0;
-		if (!dma_fence_match_context(in_fence, vgdev->fence_drv.context))
+		if (!dma_fence_match_context(in_fence, fence_ctx + ring_idx))
 			ret = dma_fence_wait(in_fence, true);
 
 		dma_fence_put(in_fence);
-- 
2.35.1



