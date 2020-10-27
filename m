Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523FE29B715
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902430AbgJ0P3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798432AbgJ0P0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10EBB2064B;
        Tue, 27 Oct 2020 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812409;
        bh=3q8GrmWADCY3LHr42pxLaEiU9wKUntRlWHdUcTiqk6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBiige6d99x3Bxvvhkb9Thw53T5+xKqvClKVrGMBVA6r80VCRf1CWR8SSP6gZHdig
         lX4LAbYuDH/w44HDQsSlU8VKf7c73R6Bfep/a6rIILTD1d8XxbuHzwSllkVEQ9zRYH
         6XfcQ/mG4tE/lQs3hmSVvabdOieak3cxS4r0OaKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Emil Velikov <emil.velikov@collabora.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 199/757] drm/malidp: Use struct drm_gem_object_funcs.get_sg_table internally
Date:   Tue, 27 Oct 2020 14:47:29 +0100
Message-Id: <20201027135459.946060696@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit d3d1bbe794ab4f7cce13e8ba08a2ac978133375e ]

The malidp driver uses GEM object functions for callbacks. Fix it to
use them internally as well.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Fixes: ecdd6474644f ("drm/malidp: Use GEM CMA object functions")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Brian Starkey <brian.starkey@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200807111022.12117-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_planes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index ab45ac445045a..351a85088d0ec 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -346,7 +346,7 @@ static bool malidp_check_pages_threshold(struct malidp_plane_state *ms,
 		if (cma_obj->sgt)
 			sgt = cma_obj->sgt;
 		else
-			sgt = obj->dev->driver->gem_prime_get_sg_table(obj);
+			sgt = obj->funcs->get_sg_table(obj);
 
 		if (!sgt)
 			return false;
-- 
2.25.1



