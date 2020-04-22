Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978C81B3EE7
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgDVKY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730476AbgDVKY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:24:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E904F20776;
        Wed, 22 Apr 2020 10:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551096;
        bh=009fT8XnlNWgSGFjkqzi9WHS52wJSOjnMq5vvLMSftE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW/XRh63tRkDUUveaNk+ktq/cNenSZwyy5DsrHiqtYUnlCtJi65AckmFpfj8RZgWP
         1rHRtOURAIz7HSjI0k7QVNXRZH81etA2pThcNCPcd5Lu8S/VvPfx8r3sOVBFgd0OKt
         3hjn49duyA287M3WBAofMvrr1HGLeWXy0EyBSMEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 098/166] dt-bindings: thermal: tsens: Fix nvmem-cell-names schema
Date:   Wed, 22 Apr 2020 11:57:05 +0200
Message-Id: <20200422095059.485243431@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit b9589def9f9af93d9d4c5969c9a6c166f070e36e ]

There's a typo 'nvmem-cells-names' in the schema which means the correct
'nvmem-cell-names' in the examples are not checked. The possible values
are wrong too both in that the 2nd entry is not specified correctly and the
values are just wrong based on the dts files in the kernel.

Fixes: a877e768f655 ("dt-bindings: thermal: tsens: Convert over to a yaml schema")
Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/thermal/qcom-tsens.yaml          | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index eef13b9446a87..a4df53228122a 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -53,13 +53,12 @@ properties:
     description:
       Reference to an nvmem node for the calibration data
 
-  nvmem-cells-names:
+  nvmem-cell-names:
     minItems: 1
     maxItems: 2
     items:
-      - enum:
-        - caldata
-        - calsel
+      - const: calib
+      - const: calib_sel
 
   "#qcom,sensors":
     allOf:
@@ -125,7 +124,7 @@ examples:
                  <0x4a8000 0x1000>; /* SROT */
 
            nvmem-cells = <&tsens_caldata>, <&tsens_calsel>;
-           nvmem-cell-names = "caldata", "calsel";
+           nvmem-cell-names = "calib", "calib_sel";
 
            interrupts = <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
            interrupt-names = "uplow";
-- 
2.20.1



