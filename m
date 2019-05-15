Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF031F0EA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfEOLXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731630AbfEOLXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D41206BF;
        Wed, 15 May 2019 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919401;
        bh=/6v4q7HorDwUbu/gg1s9GVvcdOTHYUySSEJ4nqN5lH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZMm8QtjGwyj27XjgsjHaxc76FWoW7nCg1fLhNAGQpnr1EthcTvXV5qdREFKMhiCJ
         4tCbMZBILBMKSDr8AEv9KlAvxcZKKLIHY8h79qwD2jFugSSy/C2E1KZNkJgKWAWbZR
         qC0QzMb3xJORjqVd1Qoqm80XVo3Us1FOIAyO0ASo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/113] drm/sun4i: Unbind components before releasing DRM and memory
Date:   Wed, 15 May 2019 12:55:52 +0200
Message-Id: <20190515090658.200297776@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e02bc29b2cfa7806830d6da8b2322cddd67e8dfe ]

Our components may still be using the DRM device driver (if only to
access our driver's private data), so make sure to unbind them before
the final drm_dev_put.

Also release our reserved memory after component unbind instead of
before to match reverse creation order.

Fixes: f5a9ed867c83 ("drm/sun4i: Fix component unbinding and component master deletion")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190424090413.6918-1-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index 62703630090aa..57f61ec4bc6be 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -158,10 +158,11 @@ static void sun4i_drv_unbind(struct device *dev)
 	drm_kms_helper_poll_fini(drm);
 	sun4i_framebuffer_free(drm);
 	drm_mode_config_cleanup(drm);
-	of_reserved_mem_device_release(dev);
-	drm_dev_put(drm);
 
 	component_unbind_all(dev, NULL);
+	of_reserved_mem_device_release(dev);
+
+	drm_dev_put(drm);
 }
 
 static const struct component_master_ops sun4i_drv_master_ops = {
-- 
2.20.1



