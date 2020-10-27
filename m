Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2529B7EC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798544AbgJ0P2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798156AbgJ0P0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EC2722202;
        Tue, 27 Oct 2020 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812376;
        bh=zxxk1RlUkayOgyzA1AzJFPbckdqjH5o8ahkcI3T1syA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErIllKf9THcIDnBinXRZNpB6E9XoKIfX721KfluZWIQ+NDrBxZH1UMpElY10piuCh
         o29t0DeVQMG+SXXnOSG0o+IWezCH6o6yUzsmDiXzzwHuJrfGDpjfl/4Kor7llLBIi/
         lPN/nyGsPiUzoVwkfZTtlBPf3Blsfq+yID554l3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 188/757] drm/vkms: add missing platform_device_unregister() in vkms_init()
Date:   Tue, 27 Oct 2020 14:47:18 +0100
Message-Id: <20201027135459.425783923@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 7995bd13296111d672d8c5959f5e81dbbbda5286 ]

When vkms_init() get into out_put, the unregister call of
vkms_device->platform is missing. So add it before return.

Fixes: ac19f140bc27 ("drm/vkms: Use drmm_add_final_kfree")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200810130011.187691-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index 57a8a397d5e84..83dd5567de8b5 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -190,8 +190,8 @@ static int __init vkms_init(void)
 
 out_put:
 	drm_dev_put(&vkms_device->drm);
+	platform_device_unregister(vkms_device->platform);
 	return ret;
-
 out_unregister:
 	platform_device_unregister(vkms_device->platform);
 out_free:
-- 
2.25.1



