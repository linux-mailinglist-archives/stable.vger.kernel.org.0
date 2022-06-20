Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD459551A29
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiFTM4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243369AbiFTMzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C9B19F95;
        Mon, 20 Jun 2022 05:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4BD5614CE;
        Mon, 20 Jun 2022 12:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D06C3411B;
        Mon, 20 Jun 2022 12:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729690;
        bh=YGPJSIN4rLQzhxISScC7BKlrycx2fKnKwDHRfnaUlJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyJG/wHuU33FtiGHzui43jTn6r/n3BiNcyaOT10OHwKj7OYrTgWn0b4si6vWzl//k
         0heR1GoP84mr4jP+9M3AYt47YEIFmt4fRYkNOCtZ5cz9MGopjIDtwUJKPRLxy/ZtIQ
         ET17wXaZpgk+r8/mKZusOcrLyh854A1+WbSJGUP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yupeng Li <liyupeng@zbhlos.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 044/141] MIPS: Loongson-3: fix compile mips cpu_hwmon as module build error.
Date:   Mon, 20 Jun 2022 14:49:42 +0200
Message-Id: <20220620124730.837456177@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Yupeng Li <liyupeng@zbhlos.com>

[ Upstream commit 41e456400212803704e82691716e1d7b0865114a ]

  set cpu_hwmon as a module build with loongson_sysconf, loongson_chiptemp
  undefined error,fix cpu_hwmon compile options to be bool.Some kernel
  compilation error information is as follows:

  Checking missing-syscalls for N32
  CALL    scripts/checksyscalls.sh
  Checking missing-syscalls for O32
  CALL    scripts/checksyscalls.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC [M]  drivers/platform/mips/cpu_hwmon.o
  Building modules, stage 2.
  MODPOST 200 modules
ERROR: "loongson_sysconf" [drivers/platform/mips/cpu_hwmon.ko] undefined!
ERROR: "loongson_chiptemp" [drivers/platform/mips/cpu_hwmon.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92：__modpost] 错误 1
make: *** [Makefile:1261：modules] 错误 2

Signed-off-by: Yupeng Li <liyupeng@zbhlos.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index d421e1482395..6b51ad01f791 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -17,7 +17,7 @@ menuconfig MIPS_PLATFORM_DEVICES
 if MIPS_PLATFORM_DEVICES
 
 config CPU_HWMON
-	tristate "Loongson-3 CPU HWMon Driver"
+	bool "Loongson-3 CPU HWMon Driver"
 	depends on MACH_LOONGSON64
 	select HWMON
 	default y
-- 
2.35.1



