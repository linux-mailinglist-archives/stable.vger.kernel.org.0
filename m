Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04643680FBA
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbjA3N42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjA3N4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E9D392AE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49BEBCE16A1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EAC433D2;
        Mon, 30 Jan 2023 13:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086973;
        bh=UeGqHrvCWKj5EAXMF8Sn6n5DCLBy4MFpPvC5d4V2EpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGU6jLjkgx5I3tPU8yki/ASbFDFWTpdSD0iqzkIR30xqBAy/ruF8pCpyZoa8Mo3NA
         +3iqqOYN+/296FBqZztQPbloVDBQ9KWxtscCCOkb1DUeVOhrEtLW9/MK3YFu50IsDU
         DBM/oEKRhZfvb6VhYJtqO8iyGe7V7aLoyR9aChM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-phy@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/313] phy: ti: fix Kconfig warning and operator precedence
Date:   Mon, 30 Jan 2023 14:48:12 +0100
Message-Id: <20230130134339.344522391@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7124c93887cc4e6c5b48920f83115e4a5892e870 ]

Fix Kconfig depends operator precedence to prevent a Kconfig warning:

WARNING: unmet direct dependencies detected for MUX_MMIO
  Depends on [n]: MULTIPLEXER [=m] && OF [=n]
  Selected by [m]:
  - PHY_AM654_SERDES [=m] && (OF [=n] && ARCH_K3 || COMPILE_TEST [=y]) && COMMON_CLK [=y]

Fixes: 71e2f5c5c224 ("phy: ti: Add a new SERDES driver for TI's AM654x SoC")
Fixes: 091876cc355d ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@kernel.org>
Cc: linux-phy@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230110062529.22668-1-rdunlap@infradead.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
index 15a3bcf32308..b905902d5750 100644
--- a/drivers/phy/ti/Kconfig
+++ b/drivers/phy/ti/Kconfig
@@ -23,7 +23,7 @@ config PHY_DM816X_USB
 
 config PHY_AM654_SERDES
 	tristate "TI AM654 SERDES support"
-	depends on OF && ARCH_K3 || COMPILE_TEST
+	depends on OF && (ARCH_K3 || COMPILE_TEST)
 	depends on COMMON_CLK
 	select GENERIC_PHY
 	select MULTIPLEXER
@@ -35,7 +35,7 @@ config PHY_AM654_SERDES
 
 config PHY_J721E_WIZ
 	tristate "TI J721E WIZ (SERDES Wrapper) support"
-	depends on OF && ARCH_K3 || COMPILE_TEST
+	depends on OF && (ARCH_K3 || COMPILE_TEST)
 	depends on HAS_IOMEM && OF_ADDRESS
 	depends on COMMON_CLK
 	select GENERIC_PHY
-- 
2.39.0



