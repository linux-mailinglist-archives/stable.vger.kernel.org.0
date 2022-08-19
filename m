Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8046A59A031
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351153AbiHSQD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351643AbiHSQCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1FCD34FF;
        Fri, 19 Aug 2022 08:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B42D8B82816;
        Fri, 19 Aug 2022 15:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC43C433C1;
        Fri, 19 Aug 2022 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924441;
        bh=23YCPuFIHeZ1p8ilG4guZVDo1C84SgFeajMVaE7FK1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBK3gmv4Y424XILo4HEmvUJ3cSgR2G8lBmwIV5QMEUame6vixiahwSKqH9cNPUZOu
         1XvUUBEgTQC/d/epMjd/BdGD5pi7lo/n1PweChCTGnFNTh96AsEsrpYTO7BJuNpM1n
         rLqaxfHB+GT+YOXKCE7DqJumqqA8zPbUSK2p9DHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Chia-I Wu <olvaffe@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/545] virtio-gpu: fix a missing check to avoid NULL dereference
Date:   Fri, 19 Aug 2022 17:39:01 +0200
Message-Id: <20220819153837.003735650@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index c8da7adc6b30..33b8ebab178a 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -470,8 +470,10 @@ static int virtio_gpu_get_caps_ioctl(struct drm_device *dev,
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



