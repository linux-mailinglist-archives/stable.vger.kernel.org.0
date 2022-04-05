Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A60E4F39E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378859AbiDELj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354112AbiDEKLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD1C4EA06;
        Tue,  5 Apr 2022 02:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C8266167E;
        Tue,  5 Apr 2022 09:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C661C385A2;
        Tue,  5 Apr 2022 09:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152638;
        bh=oPodn0ztNol+LNm49PEtGqL8jXdiQr3R6lw3KsHDegQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDVeZPk8OB7QW65lsOxrG7XOVGEbnzjSEF8a8hAmGoaHrwIWU51fYS4WejHUjtvsS
         udIxsn46qsR587Wbum+g61hh3muJQ23GzTrgzmY8QN+7Iy4tDlXY+trt1SAQM6lo1s
         iHE9GDuUF9gBT1b4oaA2mXuDPvkYd2yBklKO3Xuk=
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
Subject: [PATCH 5.15 849/913] net: sparx5: uses, depends on BRIDGE or !BRIDGE
Date:   Tue,  5 Apr 2022 09:31:51 +0200
Message-Id: <20220405070405.277914895@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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


