Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05B960400F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiJSJnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiJSJmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D90B1DFD;
        Wed, 19 Oct 2022 02:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19B55617B0;
        Wed, 19 Oct 2022 09:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EF0C433C1;
        Wed, 19 Oct 2022 09:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170990;
        bh=SfovaiwKGLjcp/SsOJAxEXvxF9kuiamt4gaWeahnRxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoU8bxzx6tf0UkEthkI7gJOK6k4X4cuGLVUe3Fx/wg3HNa1VDWIi7fu9eIV4QL3kt
         JRyXJcAavTUFl5n0UsaLedFca+oUmd8lee5uwAgofcDYnzKvbcXI9wXYVltm8vWiwS
         vrLwneVJ4ASvmD8T0bZuOBlQtZrvJcW4rPahT0sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ravi Gunasekaran <r-gunasekaran@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 852/862] net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses
Date:   Wed, 19 Oct 2022 10:35:39 +0200
Message-Id: <20221019083327.507859591@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 35bbe652c421037822aba29423f5f1f7d0d69f3f upstream.

davinci_mdio.c uses mdio bitbang APIs, so it should select
MDIO_BITBANG to prevent build errors.

arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_remove':
drivers/net/ethernet/ti/davinci_mdio.c:649: undefined reference to `free_mdio_bitbang'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_probe':
drivers/net/ethernet/ti/davinci_mdio.c:545: undefined reference to `alloc_mdio_bitbang'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_read':
drivers/net/ethernet/ti/davinci_mdio.c:236: undefined reference to `mdiobb_read'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_write':
drivers/net/ethernet/ti/davinci_mdio.c:253: undefined reference to `mdiobb_write'

Fixes: d04807b80691 ("net: ethernet: ti: davinci_mdio: Add workaround for errata i2329")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Sudip Mukherjee (Codethink) <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/20220824024216.4939-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -33,6 +33,7 @@ config TI_DAVINCI_MDIO
 	tristate "TI DaVinci MDIO Support"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST
 	select PHYLIB
+	select MDIO_BITBANG
 	help
 	  This driver supports TI's DaVinci MDIO module.
 


