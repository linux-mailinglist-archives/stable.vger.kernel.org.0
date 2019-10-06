Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F287CD5D6
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfJFRkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbfJFRkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EDCF2053B;
        Sun,  6 Oct 2019 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383617;
        bh=jP5aR8QFUuqvh6IsxqjL6IewN0qsy7Z1B9ECwlveLB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltyf0fPx3QsE5e/m991m43YA2xN+15PhZ2vo6MU1WPVx33cCtPAHeQWTcMWiCj12B
         sRS/H7sXUYgAopUz3G2ExxYJQEH5BijqdyilzsBsmHYxWPTX+CDVcgIoE9LgaJOewR
         y0elRgf8Li/sMbd3WNe6Vfcg+fD/8yKpymBNLiho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        David Francis <David.Francis@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 031/166] drm/amd/display: Register VUPDATE_NO_LOCK interrupts for DCN2
Date:   Sun,  6 Oct 2019 19:19:57 +0200
Message-Id: <20191006171215.621657686@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit e40837afb9b011757e17e9f71d97853ca574bcff ]

[Why]
These are needed to send back DRM vblank events in the case where VRR
is on. Without the interrupt enabled we're deferring the events into the
vblank queue and userspace is left waiting forever to get back the
events they need.

Found using igt@kms_vrr - the test fails immediately due to vblank
timeout.

[How]
Register them the same way we're handling it for DCN1.

This fixes igt@kms_vrr for DCN2.

Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: David Francis <David.Francis@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/irq/dcn20/irq_service_dcn20.c  | 28 ++++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c b/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
index 3cc0f2a1f77cc..5db29bf582d31 100644
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn20/irq_service_dcn20.c
@@ -167,6 +167,11 @@ static const struct irq_source_info_funcs vblank_irq_info_funcs = {
 	.ack = NULL
 };
 
+static const struct irq_source_info_funcs vupdate_no_lock_irq_info_funcs = {
+	.set = NULL,
+	.ack = NULL
+};
+
 #undef BASE_INNER
 #define BASE_INNER(seg) DCN_BASE__INST0_SEG ## seg
 
@@ -221,12 +226,15 @@ static const struct irq_source_info_funcs vblank_irq_info_funcs = {
 		.funcs = &pflip_irq_info_funcs\
 	}
 
-#define vupdate_int_entry(reg_num)\
+/* vupdate_no_lock_int_entry maps to DC_IRQ_SOURCE_VUPDATEx, to match semantic
+ * of DCE's DC_IRQ_SOURCE_VUPDATEx.
+ */
+#define vupdate_no_lock_int_entry(reg_num)\
 	[DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
 		IRQ_REG_ENTRY(OTG, reg_num,\
-			OTG_GLOBAL_SYNC_STATUS, VUPDATE_INT_EN,\
-			OTG_GLOBAL_SYNC_STATUS, VUPDATE_EVENT_CLEAR),\
-		.funcs = &vblank_irq_info_funcs\
+			OTG_GLOBAL_SYNC_STATUS, VUPDATE_NO_LOCK_INT_EN,\
+			OTG_GLOBAL_SYNC_STATUS, VUPDATE_NO_LOCK_EVENT_CLEAR),\
+		.funcs = &vupdate_no_lock_irq_info_funcs\
 	}
 
 #define vblank_int_entry(reg_num)\
@@ -333,12 +341,12 @@ irq_source_info_dcn20[DAL_IRQ_SOURCES_NUMBER] = {
 	dc_underflow_int_entry(6),
 	[DC_IRQ_SOURCE_DMCU_SCP] = dummy_irq_entry(),
 	[DC_IRQ_SOURCE_VBIOS_SW] = dummy_irq_entry(),
-	vupdate_int_entry(0),
-	vupdate_int_entry(1),
-	vupdate_int_entry(2),
-	vupdate_int_entry(3),
-	vupdate_int_entry(4),
-	vupdate_int_entry(5),
+	vupdate_no_lock_int_entry(0),
+	vupdate_no_lock_int_entry(1),
+	vupdate_no_lock_int_entry(2),
+	vupdate_no_lock_int_entry(3),
+	vupdate_no_lock_int_entry(4),
+	vupdate_no_lock_int_entry(5),
 	vblank_int_entry(0),
 	vblank_int_entry(1),
 	vblank_int_entry(2),
-- 
2.20.1



