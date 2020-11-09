Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8442ABAB9
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387827AbgKINVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388113AbgKINVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F7B720731;
        Mon,  9 Nov 2020 13:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928107;
        bh=oXlw0sds8OBpAbuRT1r3BD4nyWUh0fJiKDc4ixL3VTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8+T0F/cJlV4hNJZL9sR5D2WImo0I30zBjY7Kgeck4Js9wLfbqx90a+5+tVxGWXZG
         TyWVDWy7wPMTxGhfDu18u7bQ0mZ7t5ReEXzR4FSxkn0gZkjHU14kURnoyQd+j1ExNN
         piSd+5CKAguWcIs8jT/H11DDjA7I9t6BNQQwhPvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 099/133] drm/vc4: drv: Add error handding for bind
Date:   Mon,  9 Nov 2020 13:56:01 +0100
Message-Id: <20201109125035.451624827@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoegeun Kwon <hoegeun.kwon@samsung.com>

[ Upstream commit 9ce0af3e9573fb84c4c807183d13ea2a68271e4b ]

There is a problem that if vc4_drm bind fails, a memory leak occurs on
the drm_property_create side. Add error handding for drm_mode_config.

Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201027041442.30352-2-hoegeun.kwon@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 38343d2fb4fb4..f6995e7f6eb6e 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -310,6 +310,7 @@ static int vc4_drm_bind(struct device *dev)
 	component_unbind_all(dev, drm);
 gem_destroy:
 	vc4_gem_destroy(drm);
+	drm_mode_config_cleanup(drm);
 	vc4_bo_cache_destroy(drm);
 dev_put:
 	drm_dev_put(drm);
-- 
2.27.0



