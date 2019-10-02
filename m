Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0449C885D
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 14:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfJBM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 08:26:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33190 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfJBM0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 08:26:12 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x92CPxJx073005;
        Wed, 2 Oct 2019 07:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1570019159;
        bh=EDYFrWfYHk5McenIprwnW2MZAkgJrfgPI50SZBwt2Ak=;
        h=From:To:CC:Subject:Date;
        b=B0sleF8CLZS8WkFm0/QCECxFDGUTuy+0CYJ6QkvIiCQI+y/WMvo/RQLKn6JSGc2Bu
         W2KhAmDmai4/1lbVQkO38S3Ige5V4doXMW1HzyUZTUmSN7hbgArWkOSMij49khBchf
         OvAzJeBOV4fLagmSw+dzlnGnvLxERnX5XeGg4B+w=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x92CPxgN120509
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 2 Oct 2019 07:25:59 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 2 Oct
 2019 07:25:47 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 2 Oct 2019 07:25:47 -0500
Received: from deskari.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x92CPu7F109850;
        Wed, 2 Oct 2019 07:25:56 -0500
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     <dri-devel@lists.freedesktop.org>
CC:     <linux-omap@vger.kernel.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Adam Ford <aford173@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/omap: fix max fclk divider for omap36xx
Date:   Wed, 2 Oct 2019 15:25:42 +0300
Message-ID: <20191002122542.8449-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
(in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
correct, and using divider of 32 breaks DSS with a flood or underflows
and sync losts. Dividers up to 31 seem to work fine.

There is another patch to the DT files to limit the divider correctly,
but as the DSS driver also needs to know the maximum divider to be able
to iteratively find good rates, we also need to do the fix in the DSS
driver.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Adam Ford <aford173@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/omapdrm/dss/dss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
index e226324adb69..4bdd63b57100 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1083,7 +1083,7 @@ static const struct dss_features omap34xx_dss_feats = {
 
 static const struct dss_features omap3630_dss_feats = {
 	.model			=	DSS_MODEL_OMAP3,
-	.fck_div_max		=	32,
+	.fck_div_max		=	31,
 	.fck_freq_max		=	173000000,
 	.dss_fck_multiplier	=	1,
 	.parent_clk_name	=	"dpll4_ck",
-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

