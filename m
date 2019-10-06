Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFFCCD6B0
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbfJFRlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbfJFRlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0655F2053B;
        Sun,  6 Oct 2019 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383663;
        bh=GMQqub5xp0/4XAi4fDZg0COcqBv/GhT/CjZ1rK/+jCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQuKQPmNCPHzj3idgxjJLfAXgm9bWzg90PVkuvJIGjD1a//Lby9VVxqPoLU46W4Iy
         Xe2godVNO0ro81+VzTWNVsihJo1eOYdqNbMICEsSSDFm2Cs4gZFfBc8BY9IkWGnl3L
         2uOZvdSkx2YAHZckY2JXKcgAhnPeRTtZYv++iNaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 050/166] drm/nouveau/kms/tu102-: disable input lut when input is already FP16
Date:   Sun,  6 Oct 2019 19:20:16 +0200
Message-Id: <20191006171217.241742953@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



