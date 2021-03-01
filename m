Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC06328A2E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhCASNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239204AbhCASHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B4B60238;
        Mon,  1 Mar 2021 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620786;
        bh=kj0LCNZ9dvBr6P2uHlS7E3k8D0UQ7kYflu6xSJcYuDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3tYQEJjgjxNPLghzMk0sGJuu79aunHwiUSd2jx7K/uiU6G2iIi8G4SVRjfw08OQd
         3PdYCMR8kkFAp4kf9PuzSZS+/ErWFTOxaZf6nEKEt8gF5FY8Io2rl2fmYeWwMOFWgr
         uchnR6Fen8kS8oOJdY7SPXjEnIKPKYESuWl7Xwkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 280/775] drm/virtio: fix an error code in virtio_gpu_init()
Date:   Mon,  1 Mar 2021 17:07:28 +0100
Message-Id: <20210301161215.464377455@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8d0cb8860a4551fa5998acd67ca6d9ce3015b1e2 ]

If devm_request_mem_region() fails this code currently returns success
but it should return -EBUSY.

Fixes: 6076a9711dc5 ("drm/virtio: implement blob resources: probe for host visible region")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://patchwork.freedesktop.org/patch/msgid/YBpy0GS7GfmafMfe@mwanda
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
(cherry picked from commit eb988a2ee500d3297a1de048dc3c77b6c354e650)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index b4ec479c32cda..b375394193be8 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -163,6 +163,7 @@ int virtio_gpu_init(struct drm_device *dev)
 					     vgdev->host_visible_region.len,
 					     dev_name(&vgdev->vdev->dev))) {
 			DRM_ERROR("Could not reserve host visible region\n");
+			ret = -EBUSY;
 			goto err_vqs;
 		}
 
-- 
2.27.0



