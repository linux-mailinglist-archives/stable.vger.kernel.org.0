Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA89D676F5F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjAVPUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjAVPUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B41F222E8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDDE2B80B1E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A76DC433EF;
        Sun, 22 Jan 2023 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400841;
        bh=whKp7gij3QHZddFec7Q4FIopMBHXFDZYc0l6+QGN8jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De8//jgRHU10FU5/IqrUvyvvCYzMGBR5Jr1SqF/yg7aW9v7G0F+jVefBqo5HGMrCs
         6SFobRd87tNPOz2UJleZJHpz9RP9YSaY9AMulgrCAVvpp++a04zKs2wgfPjyz6+MKw
         /6zXiQSo5llPCIxXlgG+I1PciHtoupdFYc2BDaiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/193] vduse: Validate vq_num in vduse_validate_config()
Date:   Sun, 22 Jan 2023 16:02:21 +0100
Message-Id: <20230122150246.928949190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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
index 35dceee3ed56..31017ebc4d7c 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1440,6 +1440,9 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 	if (config->config_size > PAGE_SIZE)
 		return false;
 
+	if (config->vq_num > 0xffff)
+		return false;
+
 	if (!device_is_allowed(config->device_id))
 		return false;
 
-- 
2.35.1



