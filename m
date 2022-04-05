Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0604F2C53
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355670AbiDEKV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347214AbiDEJZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F54DBD36;
        Tue,  5 Apr 2022 02:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201196164E;
        Tue,  5 Apr 2022 09:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304E3C385A3;
        Tue,  5 Apr 2022 09:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150066;
        bh=oPodn0ztNol+LNm49PEtGqL8jXdiQr3R6lw3KsHDegQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzvXelg5gjV+dviWZDYGUeI+tRcz8dmD6foPcAskKtWzweunUqWi4LduYrKSnyXsq
         e4/hSaHFsNRE+ZRSYPT7FJ5eEY65XdXW9Z1qvSTNHAN7MjmCcx2jpTFvVRzf5g/3i3
         /nBzXC/ae0XbTD+J5Qa5yfyhXbfuBm5RI1JUB5uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 0942/1017] net: sparx5: uses, depends on BRIDGE or !BRIDGE
Date:   Tue,  5 Apr 2022 09:30:55 +0200
Message-Id: <20220405070422.176390423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

commit f9512d654f62604664251dedd437a22fe484974a upstream.

Fix build errors when BRIDGE=m and SPARX5_SWITCH=y:

riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L305':
sparx5_switchdev.c:(.text+0xdb0): undefined reference to `br_vlan_enabled'
riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L283':
sparx5_switchdev.c:(.text+0xee0): undefined reference to `br_vlan_enabled'

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20220330012025.29560-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -5,6 +5,7 @@ config SPARX5_SWITCH
 	depends on OF
 	depends on ARCH_SPARX5 || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER


