Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DC04F3087
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbiDEInV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241109AbiDEIct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A59415739;
        Tue,  5 Apr 2022 01:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25348609D0;
        Tue,  5 Apr 2022 08:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D87C385A2;
        Tue,  5 Apr 2022 08:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147258;
        bh=MOk/RdGK+fojtYaaJuzFPNg01OhU29vMlA4QzjbvP3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrYgc+wLkOdUWQs7eIDZv8LfH3CCXavpVeW0pvOB0FTMvEGCouJ5pMxzE6PIFia+w
         HIPEmhLlK+CRfuahipArLMQctWbOIeUGNYj87/CcjjxX7Xt3OTegk4pypnpW4JmGYj
         lcD8Gxl4tMznCyX7sBLzzS/ZIDwFe5ZlLVl/OKTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 1060/1126] spi: Fix Tegra QSPI example
Date:   Tue,  5 Apr 2022 09:30:07 +0200
Message-Id: <20220405070438.575943824@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

commit 320689a1b543ca1396b3ed43bb18045e4a7ffd79 upstream.

When running dt_binding_check on the nvidia,tegra210-quad.yaml binding
document the following error is reported ...

 nvidia,tegra210-quad.example.dt.yaml:0:0: /example-0/spi@70410000/flash@0:
 	failed to match any schema with compatible: ['spi-nor']

Update the example in the binding document to fix the above error.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: 9684752e5fe3 ("dt-bindings: spi: Add Tegra Quad SPI device tree  binding")
Link: https://lore.kernel.org/r/20220307113529.315685-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml
@@ -106,7 +106,7 @@ examples:
             dma-names = "rx", "tx";
 
             flash@0 {
-                    compatible = "spi-nor";
+                    compatible = "jedec,spi-nor";
                     reg = <0>;
                     spi-max-frequency = <104000000>;
                     spi-tx-bus-width = <2>;


