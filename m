Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70D559DA55
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352284AbiHWKHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352775AbiHWKGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2AA54CB1;
        Tue, 23 Aug 2022 01:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C59611DD;
        Tue, 23 Aug 2022 08:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03699C433D7;
        Tue, 23 Aug 2022 08:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244771;
        bh=vYopN2OvdoOaGtVHd9gj1WN5klnOVbI44044XMYR80o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qh5HBMDmuUMzU2Er8b4XKEAiOuF6J0WjWw0eeNPe/xPqRff64YLjE3WbVCh67/LiK
         lWIbmD9wl86DIoitZ4/Vg4yRSDEhChqBPcEDsQi15WH6NLza/6sxEyCCwOGRVQVOA6
         xa+uKxoSPnkwfpMJSFABkX8++83pX0dOFiFUZNq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 5.15 146/244] regulator: pca9450: Remove restrictions for regulator-name
Date:   Tue, 23 Aug 2022 10:25:05 +0200
Message-Id: <20220823080104.052218001@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit b0de7fa706506bf0591037908376351beda8c5d6 upstream.

The device bindings shouldn't put any constraints on the regulator-name
property specified in the generic bindings. This allows using arbitrary
and descriptive names for the regulators.

Suggested-by: Mark Brown <broonie@kernel.org>
Fixes: 7ae9e3a6bf3f ("dt-bindings: regulator: add pca9450 regulator yaml")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20220802064335.8481-1-frieder@fris.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml |   11 ----------
 1 file changed, 11 deletions(-)

--- a/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
@@ -47,12 +47,6 @@ properties:
         description:
           Properties for single LDO regulator.
 
-        properties:
-          regulator-name:
-            pattern: "^LDO[1-5]$"
-            description:
-              should be "LDO1", ..., "LDO5"
-
         unevaluatedProperties: false
 
       "^BUCK[1-6]$":
@@ -62,11 +56,6 @@ properties:
           Properties for single BUCK regulator.
 
         properties:
-          regulator-name:
-            pattern: "^BUCK[1-6]$"
-            description:
-              should be "BUCK1", ..., "BUCK6"
-
           nxp,dvs-run-voltage:
             $ref: "/schemas/types.yaml#/definitions/uint32"
             minimum: 600000


