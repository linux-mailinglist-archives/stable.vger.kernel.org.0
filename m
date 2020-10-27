Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B309D29C130
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818729AbgJ0RXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780636AbgJ0Oyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7703722281;
        Tue, 27 Oct 2020 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810491;
        bh=1X/jCoMbl/5xlyFG9JHlN0BAfLyG77Zfppy5G3tRG14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6nBbV1zicevEIS1ptn7UtMVPbXiAtdM7ucKB+TCX8WbjCs85UYUlZ92Jf6hD99os
         JsWtgzZsEHnjoeUvV4E64de0zvRGXTmrx6k58tEE35ftRznkwQ+dD7ih1t2vFdqysl
         mdvNXj/ukOI8Dp3Zgy6jFAlJctaiDgOfMguv2i04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 158/633] drm/vgem: add missing platform_device_unregister() in vgem_init()
Date:   Tue, 27 Oct 2020 14:48:21 +0100
Message-Id: <20201027135530.089449357@linuxfoundation.org>
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
index fa39d140adc6c..94825ec3a09d8 100644
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



