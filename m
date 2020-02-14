Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FACC15F521
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgBNPs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729574AbgBNPs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:48:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F212524650;
        Fri, 14 Feb 2020 15:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695338;
        bh=Cn7TKzpjDmcKLJqcQyACvvttFDv1Dt5rowsDQWV0Su0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/Hep9VpgPuDW6t2ZYTAPfRBXHr3PBZmg6N4XAz2PNNdg5jfUsRx0fq7rmqLWZe7v
         Aci1vdAgIDaRt4Epl2aIoyEdvnD+g7s6rVgWHB0dvosDgT4b/urQUy0OaHGBhGvx7U
         V8ZJOakwjptuSOPSdCx+UsK9NqcMEfFgfqx3zJio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 003/542] drm/dp_mst: fix multiple frees of tx->bytes
Date:   Fri, 14 Feb 2020 10:39:55 -0500
Message-Id: <20200214154854.6746-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 141ba31cf5486..cfee59e9c85e5 100644
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

