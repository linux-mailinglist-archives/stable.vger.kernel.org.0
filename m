Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD254956B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353800AbiFMM5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354814AbiFMMzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B100711A3F;
        Mon, 13 Jun 2022 04:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61C1DB80E93;
        Mon, 13 Jun 2022 11:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64DCC34114;
        Mon, 13 Jun 2022 11:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118998;
        bh=l2YBfg34tk5X/O+rDM5zgYJ6lyiB2LpFE7Bnqfy9WVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxfrQvuSu9q8yR0TCzqd5s86MzeGyzAx07h8zM+LcZyIUbEqTEeGJmTSBkZn7LxUT
         sfk1NIXC3fm6jj7AyVFHMAjt0TV0h8tV2qAB9xt07eyy7xYMykQySSFZ0eWNMkrMjh
         WOPXWCgl8ShXILkKweQHJJUwD4twapCETSim0sq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/247] regulator: mt6315-regulator: fix invalid allowed mode
Date:   Mon, 13 Jun 2022 12:10:05 +0200
Message-Id: <20220613094926.080039626@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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



