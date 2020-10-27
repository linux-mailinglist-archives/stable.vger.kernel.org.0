Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82F29C11B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811838AbgJ0RWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368502AbgJ0Oyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63A6820679;
        Tue, 27 Oct 2020 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810494;
        bh=4PkUEfHxS/KjCdvgfPEmgpJdvkPJH7IJYVCMeuanvwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCbuLEjYcyTVVR5NmK29gHk3TwWlSdq78T4B1KDXJG1ETklya37CPuwiVERKtbuNg
         qbTPwlCT0DV72VHPiGCIZe8iOFz7fMyWTbrfCDIDCRR+L1uRecBO6T1rDwxJjvKoBs
         LjJpJt/rYWtPKsREJ87CePZtpeDNJmTkCVTlgeg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 159/633] drm/vkms: add missing platform_device_unregister() in vkms_init()
Date:   Tue, 27 Oct 2020 14:48:22 +0100
Message-Id: <20201027135530.138615218@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 1e8b2169d8341..e6a3ea1b399a7 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -188,8 +188,8 @@ static int __init vkms_init(void)
 
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



