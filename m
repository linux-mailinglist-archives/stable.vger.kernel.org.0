Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96CFA119DB0
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbfLJWdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbfLJWdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:33:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7128C2073D;
        Tue, 10 Dec 2019 22:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017198;
        bh=DiRCgErLnaPFpDFzZ7O2OQisayRi7QqIXVHj7zFDuXw=;
        h=From:To:Cc:Subject:Date:From;
        b=fJA7NeihFF7PkPApy56zBaOsM15RZXI3EVqn5G3Ey8/tPYVPRfHpFVUkmDDKSEsBw
         vhlV5sdmnRgSVrUZdh7y10owGcg0JLRKYde0K5pq1Se23tt4dnxSnFTr+xkNuxKvO6
         lBjHbl1he1Yo/LTx6OogpfOortYLuAn5yGzhtOMM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Paul <seanpaul@chromium.org>, Lyude Paul <lyude@redhat.com>,
        Todd Previte <tprevite@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 01/71] drm: mst: Fix query_payload ack reply struct
Date:   Tue, 10 Dec 2019 17:32:06 -0500
Message-Id: <20191210223316.14988-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

[ Upstream commit 268de6530aa18fe5773062367fd119f0045f6e88 ]

Spec says[1] Allocated_PBN is 16 bits

[1]- DisplayPort 1.2 Spec, Section 2.11.9.8, Table 2-98

Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Todd Previte <tprevite@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Sean Paul <sean@poorly.run>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190829165223.129662-1-sean@poorly.run
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_dp_mst_helper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_dp_mst_helper.h b/include/drm/drm_dp_mst_helper.h
index f356f9716474a..674472ac067ad 100644
--- a/include/drm/drm_dp_mst_helper.h
+++ b/include/drm/drm_dp_mst_helper.h
@@ -303,7 +303,7 @@ struct drm_dp_resource_status_notify {
 
 struct drm_dp_query_payload_ack_reply {
 	u8 port_number;
-	u8 allocated_pbn;
+	u16 allocated_pbn;
 };
 
 struct drm_dp_sideband_msg_req_body {
-- 
2.20.1

