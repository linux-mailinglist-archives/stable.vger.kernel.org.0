Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA88676EFD
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjAVPQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjAVPQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45332202D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8017F60C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C72C433D2;
        Sun, 22 Jan 2023 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400592;
        bh=i7YgZEHNOEfdxOZfcvuStYdxdD/pZxpw9HpgcfKCc/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKA406w1vhE3tGYDY/SFCNZLW44K6tJoj7mzaOSyZoFa6fc3dh25eD5iGzeAi1A3r
         3ZdNJArJTOscZSCFoJn57MSHuP8ovPkSqko4K4fE5YhUo+Orbh/IfJo+ZhDfnGzGLd
         Wq8oPvF9GPBtdGll+eeVIDDrfT0V4rYubFzkBSYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/117] vduse: Validate vq_num in vduse_validate_config()
Date:   Sun, 22 Jan 2023 16:03:16 +0100
Message-Id: <20230122150232.999018300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 937c783aa3d8d77963ec91918d3298edb45b9161 ]

Add a limit to 'config->vq_num' which is user controlled data which
comes from an vduse_ioctl to prevent large memory allocations.

Micheal says  - This limit is somewhat arbitrary.
However, currently virtio pci and ccw are limited to a 16 bit vq number.
While MMIO isn't it is also isn't used with lots of VQs due to
current lack of support for per-vq interrupts.
Thus, the 0xffff limit on number of VQs corresponding
to a 16-bit VQ number seems sufficient for now.

This is found using static analysis with smatch.

Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Message-Id: <20221128155717.2579992-1-harshit.m.mogalapalli@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index e7d2d5b7e125..3467c75f310a 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1251,6 +1251,9 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 	if (config->config_size > PAGE_SIZE)
 		return false;
 
+	if (config->vq_num > 0xffff)
+		return false;
+
 	if (!device_is_allowed(config->device_id))
 		return false;
 
-- 
2.35.1



