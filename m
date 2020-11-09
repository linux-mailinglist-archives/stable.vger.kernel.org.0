Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A599D2ABB6C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgKINOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733075AbgKINOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE61A20867;
        Mon,  9 Nov 2020 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927644;
        bh=aUzQk5vOBc+/Hfh/Vr/aJE1XyEccDnj0JJ1rxa2Jirc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwpMFeTEC2ue76/RUYjoyFZYAy7A0RSq58gGV51v8qoneemCFoEnxPd5NYU9ysz3U
         aUlmI5EAL1gMvefzE/VwGeqSnh8xnM4/PxDA08WejwnvBBQ7pn4AFWO4bSqCOHgGo6
         P45tyUIGPXv87sqS/PGUZSD1IV3ypMzfNbxFnwII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/85] drm/vc4: drv: Add error handding for bind
Date:   Mon,  9 Nov 2020 13:55:54 +0100
Message-Id: <20201109125025.308973704@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
index 5e6fb6c2307f0..0d78ba017a29b 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -309,6 +309,7 @@ static int vc4_drm_bind(struct device *dev)
 	component_unbind_all(dev, drm);
 gem_destroy:
 	vc4_gem_destroy(drm);
+	drm_mode_config_cleanup(drm);
 	vc4_bo_cache_destroy(drm);
 dev_put:
 	drm_dev_put(drm);
-- 
2.27.0



