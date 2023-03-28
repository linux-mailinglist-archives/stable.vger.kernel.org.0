Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40BF6CC608
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjC1PWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbjC1PVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:21:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51134AD1E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E63FBB81D7B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F103C433D2;
        Tue, 28 Mar 2023 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016016;
        bh=YcdL9DIfgCquNYFERgVLKt5AeIWRu96ixCdaS5l/uC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ym9ptZudIJxR/qMH5TAHdkW1saO+EajJNaQZnBHWsxIMefLLs/rbsy6rH7FnshfHG
         fxZFkNs3+kTfv1hjoV/lqI3MKO+ulSW7zPvnCKdMj9e5ykO32lDu11wtOtO0jOIlME
         jH3XnfGdEgFzIS7/1VCywaw6Vh7GaWj0BqH8ojq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeremy Kerr <jk@ozlabs.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/146] serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED
Date:   Tue, 28 Mar 2023 16:41:37 +0200
Message-Id: <20230328142603.036262249@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 806a449725cbd679a7f52c394d3c87b451d66bd5 ]

The Aspeed Virtual UART is only present on Aspeed BMC platforms.  Hence
add a dependency on ARCH_ASPEED, to prevent asking the user about this
driver when configuring a kernel without Aspeed BMC support.

Reviewed-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/259138c372d433005b4871789ef9ee8d15320307.1657528861.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f8086d1a65ac ("serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index da63e76c7530c..7cd61565c1351 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -254,6 +254,7 @@ config SERIAL_8250_ASPEED_VUART
 	depends on SERIAL_8250
 	depends on OF
 	depends on REGMAP && MFD_SYSCON
+	depends on ARCH_ASPEED || COMPILE_TEST
 	help
 	  If you want to use the virtual UART (VUART) device on Aspeed
 	  BMC platforms, enable this option. This enables the 16550A-
-- 
2.39.2



