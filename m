Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2374F24E1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiDEHmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiDEHlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D14791573;
        Tue,  5 Apr 2022 00:39:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CBD461668;
        Tue,  5 Apr 2022 07:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B18AC340EE;
        Tue,  5 Apr 2022 07:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144389;
        bh=UAOLU6WpY5Znh06Wx/tPkpyuwgUKvr+IDiRcwclCbfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Exo/jyQPx5XD5ssaS/AAiOJEYOZvPboITsLR+kvB0awr5/X+L98ulEILkmBnyS+Nj
         68RxSkVSviO0VW0U0Lk5IAiQ1tRaUptrCuB7utHlAmebEf75Ahn++i7NDTGP8mYV2R
         hK/TztBSxxgGizxITy7JH7Uk96wqDgtho8jDHI9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Rob Herring <robh@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0028/1126] dt-bindings: iio: adc: zynqmp_ams: Add clock entry
Date:   Tue,  5 Apr 2022 09:12:55 +0200
Message-Id: <20220405070408.378169343@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 5165102efa41c2aedc77441612f4506a8a8671db upstream.

The AMS driver DT binding was missing the clock entry, which is actually
mandatory according to the driver implementation. Add this in.

Fixes: 39dd2d1e251d ("dt-bindings: iio: adc: Add Xilinx AMS binding documentation")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20220127173450.3684318-2-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml
@@ -92,6 +92,10 @@ properties:
     description: AMS Controller register space
     maxItems: 1
 
+  clocks:
+    items:
+      - description: AMS reference clock
+
   ranges:
     description:
       Maps the child address space for PS and/or PL.
@@ -181,12 +185,15 @@ properties:
 required:
   - compatible
   - reg
+  - clocks
   - ranges
 
 additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/xlnx-zynqmp-clk.h>
+
     bus {
         #address-cells = <2>;
         #size-cells = <2>;
@@ -196,6 +203,7 @@ examples:
             interrupt-parent = <&gic>;
             interrupts = <0 56 4>;
             reg = <0x0 0xffa50000 0x0 0x800>;
+            clocks = <&zynqmp_clk AMS_REF>;
             #address-cells = <1>;
             #size-cells = <1>;
             #io-channel-cells = <1>;


