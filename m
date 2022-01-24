Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ADC4996AC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445939AbiAXVFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352878AbiAXU5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EF496091C;
        Mon, 24 Jan 2022 20:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B966CC340E5;
        Mon, 24 Jan 2022 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057862;
        bh=E+geO893sEofmPyZ87Zb0IqJCydCQDY6kQK2m97CFPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTtF/Xnq/Umzg7iN4e5n7jihg5WDVabZnQGKSJmB0ZmBPeyp/OztH8kDOsDg5+wBa
         WhSRgYoIXadctArkC1lIKOCMlf1eyljWOZ1AVqTvXGwBqxUlRlLcFR6wbQjuELvAWP
         egm/J8k/PCNw48yicyQcSmaiDKsIreZc7hPKgvag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0103/1039] drm/virtio: fix potential integer overflow on shift of a int
Date:   Mon, 24 Jan 2022 19:31:32 +0100
Message-Id: <20220124184128.620812085@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 8f4502fa284478a5264afa8a5a95511276fa9b80 ]

The left shift of unsigned int 32 bit integer constant 1 is evaluated
using 32 bit arithmetic and then assigned to a signed 64 bit integer.
In the case where i is 32 or more this can lead to an overflow. Fix
this by shifting the value 1ULL instead.

Addresses-Coverity: ("Uninitentional integer overflow")
Fixes: 8d6b006e1f51 ("drm/virtio: implement context init: handle VIRTGPU_CONTEXT_PARAM_POLL_RINGS_MASK")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210930101941.16546-1-colin.king@canonical.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 3607646d32295..5e8103a197a96 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -819,7 +819,7 @@ static int virtio_gpu_context_init_ioctl(struct drm_device *dev,
 	if (vfpriv->ring_idx_mask) {
 		valid_ring_mask = 0;
 		for (i = 0; i < vfpriv->num_rings; i++)
-			valid_ring_mask |= 1 << i;
+			valid_ring_mask |= 1ULL << i;
 
 		if (~valid_ring_mask & vfpriv->ring_idx_mask) {
 			ret = -EINVAL;
-- 
2.34.1



