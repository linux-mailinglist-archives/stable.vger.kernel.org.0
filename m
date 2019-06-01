Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3423D31E59
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfFANWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfFANWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:22:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 077E22613B;
        Sat,  1 Jun 2019 13:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395374;
        bh=mzRhmXuI4ZWTSvCv+QrJuuMfqNv47a8FqXXXnGcwYpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjhUVA12LOGbjhZe+znJiI+iESJeK++MWO6ImWALEvemw/3aVjS3dSI3++v4VfhsL
         Hz7ELAJLdrkD9LtG1TwMIStvbCTtSi9MyDrib/R/aM3J72vVu/wpqAqNLQIPS7ybHU
         W1S6X2PPg795/f+iYGKLphioVH98wajJL8dvXgQo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 024/141] drm/nouveau/kms/gf119-gp10x: push HeadSetControlOutputResource() mthd when encoders change
Date:   Sat,  1 Jun 2019 09:20:00 -0400
Message-Id: <20190601132158.25821-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit a0b694d0af21c9993d1a39a75fd814bd48bf7eb4 ]

HW has error checks in place which check that pixel depth is explicitly
provided on DP, while HDMI has a "default" setting that we use.

In multi-display configurations with identical modelines, but different
protocols (HDMI + DP, in this case), it was possible for the DP head to
get swapped to the head which previously drove the HDMI output, without
updating HeadSetControlOutputResource(), triggering the error check and
hanging the core update.

Reported-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/head.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index 4f57e53797968..d81a99bb2ac31 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -306,7 +306,7 @@ nv50_head_atomic_check(struct drm_crtc *crtc, struct drm_crtc_state *state)
 			asyh->set.or = head->func->or != NULL;
 		}
 
-		if (asyh->state.mode_changed)
+		if (asyh->state.mode_changed || asyh->state.connectors_changed)
 			nv50_head_atomic_check_mode(head, asyh);
 
 		if (asyh->state.color_mgmt_changed ||
-- 
2.20.1

