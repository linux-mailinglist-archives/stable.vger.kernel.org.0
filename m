Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E4B1EDEFD
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 10:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgFDICq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 04:02:46 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:49012 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgFDICq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 04:02:46 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05482iG3023258;
        Thu, 4 Jun 2020 03:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591257764;
        bh=joMQqNeegOH99dRt4Epi3EIzooKrPzI0zg/KJucaX2w=;
        h=From:To:CC:Subject:Date;
        b=rEkv2YREqxQ5v6W0umtdXt63uW16v4rfKRi9LheQmuB47LNLq+A9HkSboYMLTe+JT
         UT+WXSeQSeZhQPyqc7BgCXX8c+QOruiwxbqo+opIyiPikEZ2L0QlyIIWMGkf6m89B4
         KTV+4NKXUhgLJ6/kVHxA3rWnB0ie3F3IjOJdi5RM=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05482iY5079546
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 4 Jun 2020 03:02:44 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 4 Jun
 2020 03:02:44 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 4 Jun 2020 03:02:44 -0500
Received: from deskari.lan (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05482gej127193;
        Thu, 4 Jun 2020 03:02:43 -0500
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Jyri Sarha <jsarha@ti.com>, <dri-devel@lists.freedesktop.org>
CC:     Tomi Valkeinen <tomi.valkeinen@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/tidss: fix modeset init for DPI panels
Date:   Thu, 4 Jun 2020 11:02:14 +0300
Message-ID: <20200604080214.107159-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The connector type for DISPC's DPI videoport was set the LVDS instead of
DPI. This causes any DPI panel setup to fail with tidss, making all DPI
panels unusable.

Fix this by using correct connector type.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: 32a1795f57eecc39749017 ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Cc: stable@vger.kernel.org # v5.7+
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index 7d419960b030..74467f6eafee 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -154,7 +154,7 @@ static int tidss_dispc_modeset_init(struct tidss_device *tidss)
 				break;
 			case DISPC_VP_DPI:
 				enc_type = DRM_MODE_ENCODER_DPI;
-				conn_type = DRM_MODE_CONNECTOR_LVDS;
+				conn_type = DRM_MODE_CONNECTOR_DPI;
 				break;
 			default:
 				WARN_ON(1);
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

