Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CEB505025
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbiDRMVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbiDRMVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B881B798;
        Mon, 18 Apr 2022 05:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13D860F0C;
        Mon, 18 Apr 2022 12:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D80C385A1;
        Mon, 18 Apr 2022 12:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284235;
        bh=5JbYmoZdz9OPv01seDCLPt6a9WZgN2UOJzLnWfa3bRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zgsmz60WqL6tg7nH47U08R3ghAafQparK030Os59HTgr0i4TLLvzQkFHsYqMXomc
         J6YlPIaCGMZ1HQDd53zkP77fFH8y5JrpJ4sKGli6OYhFCOlV8nS7Jme0FQ+yaWTbsB
         xKNrJZ6H/14Bx4Lw7hB6JBaroAEDG3Aq0Hmh7zkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 007/219] net: dsa: realtek: make interface drivers depend on OF
Date:   Mon, 18 Apr 2022 14:09:36 +0200
Message-Id: <20220418121203.680735597@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

commit 109d899452ba17996eccec7ae8249fb1f8900a16 upstream.

The kernel test robot reported build warnings with a randconfig that
built realtek-{smi,mdio} without CONFIG_OF set. Since both interface
drivers are using OF and will not probe without, add the corresponding
dependency to Kconfig.

Link: https://lore.kernel.org/all/202203231233.Xx73Y40o-lkp@intel.com/
Link: https://lore.kernel.org/all/202203231439.ycl0jg50-lkp@intel.com/
Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
Fixes: 765c39a4fafe ("net: dsa: realtek: convert subdrivers into modules")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20220323124225.91763-1-alvin@pqrs.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[alsi: backport to 5.16: remove mdio part]
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/realtek/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -14,6 +14,7 @@ menuconfig NET_DSA_REALTEK
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
+	depends on OF
 	default y
 	help
 	  Select to enable support for registering switches connected


