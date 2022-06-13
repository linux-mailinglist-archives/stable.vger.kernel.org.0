Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CCE548718
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355148AbiFMNAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357025AbiFMM6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF64BFF;
        Mon, 13 Jun 2022 04:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7D260F19;
        Mon, 13 Jun 2022 11:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF391C34114;
        Mon, 13 Jun 2022 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119045;
        bh=tbsBjKqvCokBZRsF7bu0vr3QAcJFbcOcF4t0Z/UWIyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1xja4qd01cG7+umpQ4teSUK31b0SoFvuX03n2SO71BuG/Do4N1s/auLLy/API6ZQ
         2e6oo0biS4OsLA2Xl9QQ4fsFFyh94pGL+W9SGa7lxToXt8IOboo/H4DEJ5wIL69GxT
         Zg7rx80nfylYpqNv0mqQEeKWTSaUXvdwlsUJFDSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/247] m68knommu: fix undefined reference to `_init_sp
Date:   Mon, 13 Jun 2022 12:10:23 +0200
Message-Id: <20220613094926.633223926@linuxfoundation.org>
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

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit a71b9e66fee47c59b3ec34e652b5c23bc6550794 ]

When configuring a nommu classic m68k system enabling the uboot parameter
passing support (CONFIG_UBOOT) will produce the following compile error:

   m68k-linux-ld: arch/m68k/kernel/uboot.o: in function `process_uboot_commandline':
   uboot.c:(.init.text+0x32): undefined reference to `_init_sp'

The logic to support this option is only used on ColdFire based platforms
(in its head.S startup code). So make the selection of this option
depend on building for a ColdFire based platform.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.machine | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index eeab4f3e6c19..946853a08502 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -335,6 +335,7 @@ comment "Machine Options"
 
 config UBOOT
 	bool "Support for U-Boot command line parameters"
+	depends on COLDFIRE
 	help
 	  If you say Y here kernel will try to collect command
 	  line parameters from the initial u-boot stack.
-- 
2.35.1



