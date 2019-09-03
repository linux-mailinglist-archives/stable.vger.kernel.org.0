Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F733A6FEA
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfICQ13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730852AbfICQ13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920FB23878;
        Tue,  3 Sep 2019 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528048;
        bh=HhjMPDYWRfDZBm9ZYOsXvGnHX2QeGL7rJQdeG914/1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEPGl3zVYHlg0Lp7IqIfM/3pHGmWwoGB2qAicL8fNttm0BVEmnYVihsmww+k+OsKf
         f7rt21rER34hnnhwvdQKW4Z0wGr0y4eINtFX9/GW5iLp04dVuYr4Gpg+HBEH6L7h5H
         nBMKbwcrn8nQW6H7PFl6bZUKMQFw40yk1xVUj1fc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 070/167] drm/nouveau: Don't WARN_ON VCPI allocation failures
Date:   Tue,  3 Sep 2019 12:23:42 -0400
Message-Id: <20190903162519.7136-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

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

