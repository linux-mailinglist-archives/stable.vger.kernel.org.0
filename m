Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362B029B708
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798540AbgJ0P2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798150AbgJ0P0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0AE20657;
        Tue, 27 Oct 2020 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812373;
        bh=ml0WXOPEPyk5UVVFixp6s8DuJPKjVpg0UlZkG48Mp2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmT3Y89LukxUTlwJE4UfPtsHASJ8bSnAA7kQErFbBNWRFlFZUX01Y5oAFFP5BFXke
         7J6Hy6nC4nsqWUFDbjyKOL0BsUDQw88PxSnmS6AbZmx0ep9nRdDx6DejOQNZNp7eIa
         bvp9R0COv7yAi7GbKxQ3B3ZV4W4eE8rsUZIrryRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 187/757] drm/vgem: add missing platform_device_unregister() in vgem_init()
Date:   Tue, 27 Oct 2020 14:47:17 +0100
Message-Id: <20201027135459.377597678@linuxfoundation.org>
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

[ Upstream commit 57fb54082d5d14512dfd21bc39d91945d3ad1ee9 ]

When vgem_init() get into out_put, the unregister call of
vgem_device->platform is missing. So add it before return.

Fixes: 363de9e7d4f6 ("drm/vgem: Use drmm_add_final_kfree")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200810125942.186637-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vgem/vgem_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index a775feda1cc73..313339bbff901 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -471,8 +471,8 @@ static int __init vgem_init(void)
 
 out_put:
 	drm_dev_put(&vgem_device->drm);
+	platform_device_unregister(vgem_device->platform);
 	return ret;
-
 out_unregister:
 	platform_device_unregister(vgem_device->platform);
 out_free:
-- 
2.25.1



