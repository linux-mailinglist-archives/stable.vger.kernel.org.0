Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464ECBCD36
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390485AbfIXQoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404399AbfIXQoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F8820872;
        Tue, 24 Sep 2019 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343454;
        bh=GMQqub5xp0/4XAi4fDZg0COcqBv/GhT/CjZ1rK/+jCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQOZl3RI9XjgJ9FrBdsLL+M5xwR+4uTBLdj1l6vfefsqNdo2nWDFludllxijVyvAL
         ELX7O3RHvqht397FShpkotvM/V20Ovpr/k4U7WlbMhENtu22wcUd4to+adcWjPNIP9
         0PJLLejNtv7e6KTHUg80oCaPzy74Kkr1a06VaOr0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 54/87] drm/nouveau/kms/tu102-: disable input lut when input is already FP16
Date:   Tue, 24 Sep 2019 12:41:10 -0400
Message-Id: <20190924164144.25591-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 1e339ab2ac3c769c1b06b9fb7d532f8495ebc56d ]

On Turing, an input LUT is required to transform inputs in fixed-point
formats to FP16 for the internal display pipe.  We provide an identity
mapping whenever a window is enabled for this reason.

HW has error checks to ensure when the input is already FP16, that the
input LUT is also disabled.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/wndw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
index 283ff690350ea..50303ec194bbc 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -320,7 +320,9 @@ nv50_wndw_atomic_check_lut(struct nv50_wndw *wndw,
 		asyh->wndw.olut &= ~BIT(wndw->id);
 	}
 
-	if (!ilut && wndw->func->ilut_identity) {
+	if (!ilut && wndw->func->ilut_identity &&
+	    asyw->state.fb->format->format != DRM_FORMAT_XBGR16161616F &&
+	    asyw->state.fb->format->format != DRM_FORMAT_ABGR16161616F) {
 		static struct drm_property_blob dummy = {};
 		ilut = &dummy;
 	}
-- 
2.20.1

