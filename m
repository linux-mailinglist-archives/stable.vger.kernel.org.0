Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F2608A56
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiJVIvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiJVItP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:49:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F5480F58;
        Sat, 22 Oct 2022 01:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 625C360B94;
        Sat, 22 Oct 2022 08:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59536C433D7;
        Sat, 22 Oct 2022 08:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426050;
        bh=SfovaiwKGLjcp/SsOJAxEXvxF9kuiamt4gaWeahnRxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4qC1DPzOiZL+1dWi7NbGw9EwKuwy2enhjTYT6RvQqi0+vJw/6VEAE7AG8PvHlFGz
         P8HjSxmBdO9iCTsMgBB1lMQEC/VHWXGfIwpf7Z6TbmQAgmqq4xREh5x+zmFWVx/CIX
         VsS9CrDdfix09IRqaZzttqgK3m8q7Dhckh1hAacQ=
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
Subject: [PATCH 5.19 703/717] net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses
Date:   Sat, 22 Oct 2022 09:29:42 +0200
Message-Id: <20221022072529.547751759@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 


