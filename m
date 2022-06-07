Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB51A540978
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349823AbiFGSI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349522AbiFGSHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AF45371E;
        Tue,  7 Jun 2022 10:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A76661732;
        Tue,  7 Jun 2022 17:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83259C385A5;
        Tue,  7 Jun 2022 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624070;
        bh=cnXSpj71eQMwhKdrGkg6POkXC+2h0YgRyd9EbaikIb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wip/wwz41pKz/yAybu/HiFd1EWjqxlwBgP7doPQbApulJTekeZk4iSneh2noTU/cX
         5NdtUH51ep3TvAEm+BsLfELHBH5YAc7AJNglQcGIqeibaHNuvBsE1GJePPmyMrlt3I
         gZ6nFT7vJ5hMh+5CcBn428mdElBp1741+5jQA/lM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <singh.kuldeep87k@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/667] spi: qcom-qspi: Add minItems to interconnect-names
Date:   Tue,  7 Jun 2022 18:57:39 +0200
Message-Id: <20220607164940.620603263@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuldeep Singh <singh.kuldeep87k@gmail.com>

[ Upstream commit e23d86c49a9c78e8dbe3abff20b30812b26ab427 ]

Add minItems constraint to interconnect-names as well. The schema
currently tries to match 2 names and fail for DTs with single entry.

With the change applied, below interconnect-names values are possible:
['qspi-config'], ['qspi-config', 'qspi-memory']

Fixes: 8f9c291558ea ("dt-bindings: spi: Add interconnect binding for QSPI")
Signed-off-by: Kuldeep Singh <singh.kuldeep87k@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220328192006.18523-1-singh.kuldeep87k@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
index ef5698f426b2..392204a08e96 100644
--- a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
@@ -45,6 +45,7 @@ properties:
     maxItems: 2
 
   interconnect-names:
+    minItems: 1
     items:
       - const: qspi-config
       - const: qspi-memory
-- 
2.35.1



