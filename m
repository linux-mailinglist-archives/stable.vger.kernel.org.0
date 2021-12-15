Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15D1475E9A
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245496AbhLORXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245351AbhLORXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB456C06173E;
        Wed, 15 Dec 2021 09:23:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A68DFB82023;
        Wed, 15 Dec 2021 17:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF635C36AE4;
        Wed, 15 Dec 2021 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588981;
        bh=pdD7OQqmkY5962sRXlSmyDA9SqmytB67ve9HECdPo18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFbw96Esg00XHt7eiHJXPW+MSx+Bq8zKzXs5IU8njLHe5mQ7uAfiu8eCy180zbNL7
         X9ewroQe8v/Z3tdZJkXY2arJxWrFo4iBtgGhWx9B+f9Stf7evgL7MdAlnVDPr9b40C
         2c1JEs3Os1MbHeqxm3e+WjlMASi5VnUiI0IfIkWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/42] dt-bindings: media: nxp,imx7-mipi-csi2: Drop bad if/then schema
Date:   Wed, 15 Dec 2021 18:20:49 +0100
Message-Id: <20211215172026.927622164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit b54472a02cefd0dc468158bbc4d636b27cd6fc34 ]

The if/then schema for 'data-lanes' doesn't work as 'compatible' is at a
different level than 'data-lanes'. To make it work, the if/then schema
would have to be moved to the top level and then whole hierarchy of
nodes down to 'data-lanes' created. I don't think it is worth the
complexity to do that, so let's just drop it.

The error in this schema is masked by a fixup in the tools causing the
'allOf' to get overwritten. Removing the fixup as part of moving to
json-schema draft 2019-09 revealed the issue:

Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.example.dt.yaml: mipi-csi@30750000: ports:port@0:endpoint:data-lanes:0: [1] is too short
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.example.dt.yaml: mipi-csi@32e30000: ports:port@0:endpoint:data-lanes:0: [1, 2, 3, 4] is too long
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml

The if condition was always true because 'compatible' did not exist in
'endpoint' node and a non-existent property is true for json-schema.

Fixes: 85b62ff2cb97 ("media: dt-bindings: media: nxp,imx7-mipi-csi2: Add i.MX8MM support")
Cc: Rui Miguel Silva <rmfrfs@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Link: https://lore.kernel.org/r/20211203164828.187642-1-robh@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/media/nxp,imx7-mipi-csi2.yaml         | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml b/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
index 877183cf42787..1ef849dc74d7e 100644
--- a/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx7-mipi-csi2.yaml
@@ -79,6 +79,8 @@ properties:
 
             properties:
               data-lanes:
+                description:
+                  Note that 'fsl,imx7-mipi-csi2' only supports up to 2 data lines.
                 items:
                   minItems: 1
                   maxItems: 4
@@ -91,18 +93,6 @@ properties:
             required:
               - data-lanes
 
-            allOf:
-              - if:
-                  properties:
-                    compatible:
-                      contains:
-                        const: fsl,imx7-mipi-csi2
-                then:
-                  properties:
-                    data-lanes:
-                      items:
-                        maxItems: 2
-
       port@1:
         $ref: /schemas/graph.yaml#/properties/port
         description:
-- 
2.33.0



