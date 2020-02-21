Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD216788B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgBUHow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgBUHow (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:44:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BCCC222C4;
        Fri, 21 Feb 2020 07:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271091;
        bh=5X0WupEnFfrRuUFOQtt2nR3NK/iuICCSLiohKNtFgtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdjWPsCjRMSJBKpeu8HTzNhZeRlN6md52vCcCgex7fYL4/+7Vz44DSV+tcRWW6Xpv
         NsWGbdvMMVe/MJC0j/MM0MGJMgVkXsqDjtUp0Ba8TWFH+9QDLQQz8ZYzGQGstEd706
         h6L/kuswvECxvAcwh0GpboWcjoqhGU55INKGGSDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 008/399] drm/dp_mst: fix multiple frees of tx->bytes
Date:   Fri, 21 Feb 2020 08:35:33 +0100
Message-Id: <20200221072403.123394889@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 2c8bc91488fc57438c43b3bb19deb7fdbc1e5119 ]

Currently tx->bytes is being freed r->num_transactions number of
times because tx is not being set correctly. Fix this by setting
tx to &r->transactions[i] so that the correct objects are being
freed on each loop iteration.

Addresses-Coverity: ("Double free")
Fixes: 2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191120173509.347490-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 6cd90cb4b6b10..4a65ef8d8bff3 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -517,8 +517,10 @@ drm_dp_decode_sideband_req(const struct drm_dp_sideband_msg_tx *raw,
 			}
 
 			if (failed) {
-				for (i = 0; i < r->num_transactions; i++)
+				for (i = 0; i < r->num_transactions; i++) {
+					tx = &r->transactions[i];
 					kfree(tx->bytes);
+				}
 				return -ENOMEM;
 			}
 
-- 
2.20.1



