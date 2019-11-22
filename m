Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568741064C0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVGTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbfKVFz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:55:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75BF4207FC;
        Fri, 22 Nov 2019 05:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402159;
        bh=OzYtwF3JQAAv1AmFBZhtaXfAlBLGifIQv0NrdVQPlHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kJYVlZAyGwxaE9F45UTXLv1XnHCAxYjXlwP7nbNg5Mfu06RoGx6MiLwG5flyQmwv
         wWn+solXbg9e3+IqDV21hOh3IaJv9VtQO9yiV3AH6btNcQaidqW34QJHW/pd/2sOzC
         hUgREYMM7MO+JelboOU8FdGxhp9gmRbhbsQvZ2Xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 013/127] ARM: ks8695: fix section mismatch warning
Date:   Fri, 22 Nov 2019 00:53:51 -0500
Message-Id: <20191122055544.3299-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4aa64677330beeeed721b4b122884dabad845d66 ]

WARNING: vmlinux.o(.text+0x13250): Section mismatch in reference from the function acs5k_i2c_init() to the (unknown reference) .init.data:(unknown)
The function acs5k_i2c_init() references
the (unknown reference) __initdata (unknown).
This is often because acs5k_i2c_init lacks a __initdata
annotation or the annotation of (unknown) is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-ks8695/board-acs5k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-ks8695/board-acs5k.c b/arch/arm/mach-ks8695/board-acs5k.c
index e4d709c8ed32f..76d3083f1f634 100644
--- a/arch/arm/mach-ks8695/board-acs5k.c
+++ b/arch/arm/mach-ks8695/board-acs5k.c
@@ -92,7 +92,7 @@ static struct i2c_board_info acs5k_i2c_devs[] __initdata = {
 	},
 };
 
-static void acs5k_i2c_init(void)
+static void __init acs5k_i2c_init(void)
 {
 	/* The gpio interface */
 	platform_device_register(&acs5k_i2c_device);
-- 
2.20.1

