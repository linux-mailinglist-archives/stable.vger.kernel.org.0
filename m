Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEB18195A
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgCKNNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:13:21 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:49262 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729414AbgCKNNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 09:13:21 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0286243B45;
        Wed, 11 Mar 2020 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583932400; bh=8rfNPQeTls9UibHljNnu2AKJ+S9mqQvjUSn2bsEDSsY=;
        h=From:To:Cc:Subject:Date:From;
        b=BU1UKVUwEwWyrOTAzHEIBxtutkZiEm1pm8ctfu39cHnyOZe33JwSZcixhmW+wSjPG
         pl0gbq6eDXHKAEaJ3Z5zU/7v4kt582lVAiCbht3QF6f3F4dkLjUl+m57z/zLoGFtwh
         MWSErBoAlaq4AFey3pIIIzZUVz7VVUgUKnU8/ODBkKZ2cXqABO7aIGow2kSJqYcRJS
         nx13U+d1cxkHtcwaQNZMq4xM4G2M57j/bcK1qdo3qelXpPoVMi5qti8n1rk9VcoEoW
         ooKWn6aKHCWy20NdxIDN/IDdTN/vokJwSdqFag9gpOkQtNtbuPeknJEhnii1KVxZv9
         KCdWZUmGbXR6w==
Received: from paltsev-e7480.internal.synopsys.com (unknown [10.121.8.79])
        by mailhost.synopsys.com (Postfix) with ESMTP id 49BFCA005C;
        Wed, 11 Mar 2020 13:13:16 +0000 (UTC)
From:   Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
To:     dri-devel@lists.freedesktop.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc:     linux-snps-arc@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Subject: [PATCH] DRM: ARC: PGU: interlaced mode not supported
Date:   Wed, 11 Mar 2020 16:13:10 +0300
Message-Id: <20200311131310.20446-1-Eugeniy.Paltsev@synopsys.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Filter out interlaced modes as they are not supported by ARC PGU
hardware.

Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
---
 drivers/gpu/drm/arc/arcpgu_crtc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/arc/arcpgu_crtc.c b/drivers/gpu/drm/arc/arcpgu_crtc.c
index 8ae1e1f97a73..c854066d4c75 100644
--- a/drivers/gpu/drm/arc/arcpgu_crtc.c
+++ b/drivers/gpu/drm/arc/arcpgu_crtc.c
@@ -67,6 +67,9 @@ static enum drm_mode_status arc_pgu_crtc_mode_valid(struct drm_crtc *crtc,
 	long rate, clk_rate = mode->clock * 1000;
 	long diff = clk_rate / 200; /* +-0.5% allowed by HDMI spec */
 
+	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+		return MODE_NO_INTERLACE;
+
 	rate = clk_round_rate(arcpgu->clk, clk_rate);
 	if ((max(rate, clk_rate) - min(rate, clk_rate) < diff) && (rate > 0))
 		return MODE_OK;
-- 
2.21.1

