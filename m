Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 019DCB201C
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389862AbfIMNQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389857AbfIMNQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:28 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1886B20CC7;
        Fri, 13 Sep 2019 13:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380587;
        bh=zOG44NvZII34L1rJxUscROwjCbvLnAhsBzplt5zW7gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMGbEDQaIgJqotn8TtEeOZBstFJiWMDoNjzJtw9PyzKt3xBDCGT7V2l3gC92EYdmb
         JDGWcQ813/S2+3fbHX89DcHoAvPndziK9jr/JCM3KkAVhmBDVFXF4OHtMyqM2kzCws
         qaZHNKSEf664DVjsmgZ4pJwiucfImCJ4XB4DvfIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/190] drm/nouveau: Dont WARN_ON VCPI allocation failures
Date:   Fri, 13 Sep 2019 14:05:47 +0100
Message-Id: <20190913130606.981926197@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b513a18cf1d705bd04efd91c417e79e4938be093 ]

This is much louder then we want. VCPI allocation failures are quite
normal, since they will happen if any part of the modesetting process is
interrupted by removing the DP MST topology in question. So just print a
debugging message on VCPI failures instead.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: f479c0ba4a17 ("drm/nouveau/kms/nv50: initial support for DP 1.2 multi-stream")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index f889d41a281fa..5e01bfb69d7a3 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -759,7 +759,8 @@ nv50_msto_enable(struct drm_encoder *encoder)
 
 	slots = drm_dp_find_vcpi_slots(&mstm->mgr, mstc->pbn);
 	r = drm_dp_mst_allocate_vcpi(&mstm->mgr, mstc->port, mstc->pbn, slots);
-	WARN_ON(!r);
+	if (!r)
+		DRM_DEBUG_KMS("Failed to allocate VCPI\n");
 
 	if (!mstm->links++)
 		nv50_outp_acquire(mstm->outp);
-- 
2.20.1



