Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E8499BDF
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404619AbfHVR0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404606AbfHVR0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:07 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1CE2341C;
        Thu, 22 Aug 2019 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494766;
        bh=wKXD6gj0JrSo8P6g8TBDInk14gTgVAubp7XlhD41KnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdEx9xa8Vw5PT5wZJgCkL0ygf0HDNKLnMtIMNZorpUFk7GUqpu+3XqM8H30XA/maZ
         2xEf4KaaBm+DDuHFgtBXIPmfIg/SgNM8wF6hxedX2fC5hNQBYF+/ZJi8Ly6I2yE2jJ
         WgY0uRtYMAjH8Q17OZM2M/k3XDABKgw4vo4kgHfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Qian Cai <cai@lca.pw>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/85] arm64/efi: fix variable si set but not used
Date:   Thu, 22 Aug 2019 10:19:16 -0700
Message-Id: <20190822171733.156230259@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f1d4836201543e88ebe70237e67938168d5fab19 ]

GCC throws out this warning on arm64.

drivers/firmware/efi/libstub/arm-stub.c: In function 'efi_entry':
drivers/firmware/efi/libstub/arm-stub.c:132:22: warning: variable 'si'
set but not used [-Wunused-but-set-variable]

Fix it by making free_screen_info() a static inline function.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/efi.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 7ed320895d1f4..f52a2968a3b69 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -94,7 +94,11 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
 
 #define alloc_screen_info(x...)		&screen_info
-#define free_screen_info(x...)
+
+static inline void free_screen_info(efi_system_table_t *sys_table_arg,
+				    struct screen_info *si)
+{
+}
 
 /* redeclare as 'hidden' so the compiler will generate relative references */
 extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
-- 
2.20.1



