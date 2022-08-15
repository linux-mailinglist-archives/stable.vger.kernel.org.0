Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44C1594120
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbiHOU4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347018AbiHOU4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1472DA8E;
        Mon, 15 Aug 2022 12:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3757A60BC2;
        Mon, 15 Aug 2022 19:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41571C433C1;
        Mon, 15 Aug 2022 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590714;
        bh=qd7DGm7gGOW9kfEJ46D2NiTS3ftZuyV6LqQZH+9ayTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IN/vwRZReM78KSPc4Nqn6idmUscBBNNR5TMiWhK/KRLHrlZTKb1AHLMz+jUGy+P0V
         1zTj2kpY6Ptgc42v8yLi9l7br5gAuYUVY4MyvSH0z0xTc6bn00pAiMT3o5RmlDpMYR
         UyqLmsFSM4rCwD+v04UpxRtvz2+U9KmvW36Bvamw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Chia-I Wu <olvaffe@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0330/1095] virtio-gpu: fix a missing check to avoid NULL dereference
Date:   Mon, 15 Aug 2022 19:55:29 +0200
Message-Id: <20220815180443.434668603@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit bd63f11f4c3c46afec07d821f74736161ff6e526 ]

'cache_ent' could be set NULL inside virtio_gpu_cmd_get_capset()
and it will lead to a NULL dereference by a lately use of it
(i.e., ptr = cache_ent->caps_cache). Fix it with a NULL check.

Fixes: 62fb7a5e10962 ("virtio-gpu: add 3d/virgl support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220327050945.1614-1-xiam0nd.tong@gmail.com

[ kraxel: minor codestyle fixup ]

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index c708bab555c6..10f080060923 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -579,8 +579,10 @@ static int virtio_gpu_get_caps_ioctl(struct drm_device *dev,
 	spin_unlock(&vgdev->display_info_lock);
 
 	/* not in cache - need to talk to hw */
-	virtio_gpu_cmd_get_capset(vgdev, found_valid, args->cap_set_ver,
-				  &cache_ent);
+	ret = virtio_gpu_cmd_get_capset(vgdev, found_valid, args->cap_set_ver,
+					&cache_ent);
+	if (ret)
+		return ret;
 	virtio_gpu_notify(vgdev);
 
 copy_exit:
-- 
2.35.1



