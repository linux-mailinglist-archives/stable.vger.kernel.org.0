Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A954B47EA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244620AbiBNJmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244960AbiBNJlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374C06578F;
        Mon, 14 Feb 2022 01:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC232B80DC1;
        Mon, 14 Feb 2022 09:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A35C340E9;
        Mon, 14 Feb 2022 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831383;
        bh=MjwLM9w9HSUTLylEXxIBHOL81l+2um6GSMvhepqhVbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfDi0g6q1wgOkiNwVE77MbdDIjpA2to7Huk4Ekn5gWKA+FP1TvtO2KZOdaXpx5LyZ
         nd0zH6iGJBx2ujkAiiYN5BUDud32GI119/aVLxnV/Xx/vYYAZF8XmYvER1btARIqMy
         bA9ifRvO6YrwPVaXAxMmqAqdqoxUZKnNB4IgwAQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.4 29/71] ARM: socfpga: fix missing RESET_CONTROLLER
Date:   Mon, 14 Feb 2022 10:25:57 +0100
Message-Id: <20220214092452.998302958@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 3037b174b1876aae6b2d1a27a878c681c78ccadc upstream.

The SocFPGA machine since commit b3ca9888f35f ("reset: socfpga: add an
early reset driver for SoCFPGA") uses reset controller, so it should
select RESET_CONTROLLER explicitly.  Selecting ARCH_HAS_RESET_CONTROLLER
is not enough because it affects only default choice still allowing a
non-buildable configuration:

  /usr/bin/arm-linux-gnueabi-ld: arch/arm/mach-socfpga/socfpga.o: in function `socfpga_init_irq':
  arch/arm/mach-socfpga/socfpga.c:56: undefined reference to `socfpga_reset_init'

Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: b3ca9888f35f ("reset: socfpga: add an early reset driver for SoCFPGA")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-socfpga/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -2,6 +2,7 @@
 menuconfig ARCH_SOCFPGA
 	bool "Altera SOCFPGA family"
 	depends on ARCH_MULTI_V7
+	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
@@ -19,6 +20,7 @@ menuconfig ARCH_SOCFPGA
 	select PL310_ERRATA_727915
 	select PL310_ERRATA_753970 if PL310
 	select PL310_ERRATA_769419
+	select RESET_CONTROLLER
 
 if ARCH_SOCFPGA
 config SOCFPGA_SUSPEND


