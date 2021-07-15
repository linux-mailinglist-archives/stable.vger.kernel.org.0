Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F983CA5D3
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhGOSop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231395AbhGOSoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:44:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC951613CA;
        Thu, 15 Jul 2021 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374472;
        bh=TMzPzvQwFNp+5+SRLt8873mTQakIk68eo+B+7cG/M6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5stEusN1ihVDft9s43C9l8Gu78iDUuUiv7ToHQrLjj+Ige6asdgx+WMZ9NSk+erX
         bLiWRKvbyPrCr0bGotSRz53MfkrfqeWAUv9a/7St298msJ1XS/s2oqAoiqUQQ2nnD8
         XkKlkscs0NrrVUAVI2MdYYdnCmsbd0NgACCe6GRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/122] drm/virtio: Fix double free on probe failure
Date:   Thu, 15 Jul 2021 20:37:41 +0200
Message-Id: <20210715182452.927127869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit cec7f1774605a5ef47c134af62afe7c75c30b0ee ]

The virtio_gpu_init() will free vgdev and vgdev->vbufs on failure.
But such failure will be caught by virtio_gpu_probe() and then
virtio_gpu_release() will be called to do some cleanup which
will free vgdev and vgdev->vbufs again. So let's set dev->dev_private
to NULL to avoid double free.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210517084913.403-2-xieyongji@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 6dcc05ab31eb..4f855b242dfd 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -218,6 +218,7 @@ err_ttm:
 err_vbufs:
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 err_vqs:
+	dev->dev_private = NULL;
 	kfree(vgdev);
 	return ret;
 }
-- 
2.30.2



