Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E55593679
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243382AbiHOSoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiHOSmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1824B2F3AF;
        Mon, 15 Aug 2022 11:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6304B8106C;
        Mon, 15 Aug 2022 18:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4E1C433D6;
        Mon, 15 Aug 2022 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587971;
        bh=zYhBqrRVQv4M1lLZWwjM0jKDb57E/fRn1jxdc7X1x5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO7jFiEWZdLNuaIpcQGp9AxVFm1dATMr+dec9t8C611xscKRdFm4GFEdjv8IHEduA
         VLrjKdIq/y7v+cGZ0u0Su7qT2ixeKc5PPM1qgwJrib8nXN6Z8AillcjVBqUD1Wto+a
         HNRVo7pE8JdTDy10fGz9hbBED5+AtBdaiqrX/IcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Chia-I Wu <olvaffe@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/779] virtio-gpu: fix a missing check to avoid NULL dereference
Date:   Mon, 15 Aug 2022 19:58:17 +0200
Message-Id: <20220815180348.147837223@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 5c1ad1596889..15c3e63db396 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -512,8 +512,10 @@ static int virtio_gpu_get_caps_ioctl(struct drm_device *dev,
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



