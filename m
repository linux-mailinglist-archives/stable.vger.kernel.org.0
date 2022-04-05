Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815124F3052
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiDEI2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072956384;
        Tue,  5 Apr 2022 01:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 983AE60AFB;
        Tue,  5 Apr 2022 08:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82316C385A0;
        Tue,  5 Apr 2022 08:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146597;
        bh=skwGjJleA6WjxDdMKnkBNDhJLVUBgPnr7tJN0zUUfos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rERXY6cI4vcy2iob7q2RfjO0RM/VIz4caK9hpFica1Y5NOViV51GcK/w0ogzMjqvb
         Hh9ChAwPQEYhIsPOocB9/D593yf7UxC0n1l4gmDNUMO61pvGgLgFW05fUAimr6WbXa
         WrHxMvqm3eHbsy2ukx7Q4urywXKSmg2McYdlj7Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0821/1126] net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL
Date:   Tue,  5 Apr 2022 09:26:08 +0200
Message-Id: <20220405070431.660045388@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 08be6b13db23f68146c600dd5adfd92e99d9ec6e ]

Fix build errors when PTP_1588_CLOCK=m and SPARX5_SWTICH=y.

arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.o: in function `sparx5_get_ts_info':
sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
arc-linux-ld: sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_init':
sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
arc-linux-ld: sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_deinit':
sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf38): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf46): undefined reference to `ptp_clock_unregister'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o:sparx5_ptp.c:(.text+0xf46): more undefined references to `ptp_clock_unregister' follow

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Steen Hegelund <steen.hegelund@microchip.com>
Cc: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index 7bdbb2d09a14..85b24edb65d5 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -4,6 +4,7 @@ config SPARX5_SWITCH
 	depends on HAS_IOMEM
 	depends on OF
 	depends on ARCH_SPARX5 || COMPILE_TEST
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
-- 
2.34.1



