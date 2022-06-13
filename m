Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38C9549423
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383581AbiFMO0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383911AbiFMOYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA40473AE;
        Mon, 13 Jun 2022 04:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E125F613CA;
        Mon, 13 Jun 2022 11:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E84C34114;
        Mon, 13 Jun 2022 11:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120750;
        bh=l2YBfg34tk5X/O+rDM5zgYJ6lyiB2LpFE7Bnqfy9WVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noM+3V0wY2UpDCehqP3YbITF9VAVhJD976IpKkGYcim+DgctKULb+LVxk4/62DmW2
         fQZS0BcaUhqjMJUyA3kDhAWMsLUf86fpRFutz/+JCQeVM8/fQNyDrfXKTnMHE8F4EW
         TOq6+sARC7cyXeNXLPcyenfrlkpLAJWkgcnhAYRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 120/298] regulator: mt6315-regulator: fix invalid allowed mode
Date:   Mon, 13 Jun 2022 12:10:14 +0200
Message-Id: <20220613094928.583050569@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit 28cbc2d4c54c09a427b18a1604740efb6b2cc2d6 ]

In the binding example, the regulator mode 4 is shown as a valid mode,
but the driver actually only support mode 0 to 2:

This generates an error in dmesg when copy/pasting the binding example:
[    0.306080] vbuck1: invalid regulator-allowed-modes element 4
[    0.307290] vbuck2: invalid regulator-allowed-modes element 4

This commit fixes this error by removing the invalid mode from the
examples.

Fixes: 977fb5b58469 ("regulator: document binding for MT6315 regulator")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Link: https://lore.kernel.org/r/20220529154613.337559-1-fparent@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/regulator/mt6315-regulator.yaml       | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
index 5d2d989de893..37402c370fbb 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -55,7 +55,7 @@ examples:
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-          regulator-allowed-modes = <0 1 2 4>;
+          regulator-allowed-modes = <0 1 2>;
         };
 
         vbuck3 {
@@ -63,7 +63,7 @@ examples:
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-          regulator-allowed-modes = <0 1 2 4>;
+          regulator-allowed-modes = <0 1 2>;
         };
       };
     };
-- 
2.35.1



