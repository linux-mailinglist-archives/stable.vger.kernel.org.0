Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C77A441684
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhKAJ0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232621AbhKAJYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB45561179;
        Mon,  1 Nov 2021 09:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758471;
        bh=USSO+xNUiBioOo7quBRHf76QRiBObLPd9my0F6hFe5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZJh/zS75ytPwszLFAbcdRp5Hx0PLN+76syDCEo1ifHL6Q/niWvY4ckm4Lc0j1Oc0
         YeZKqjYQrzgGG7v5dJx4EBIXWydgI0KvABM3OjxJPv/oKCZePaqqFTk3xFol+dBre5
         +08Abe0kzd/4GULUV4VCnOVkT1CMkTsCAQaPJKIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 04/35] ARM: 9141/1: only warn about XIP address when not compile testing
Date:   Mon,  1 Nov 2021 10:17:16 +0100
Message-Id: <20211101082452.581447646@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 48ccc8edf5b90622cdc4f8878e0042ab5883e2ca upstream.

In randconfig builds, we sometimes come across this warning:

arm-linux-gnueabi-ld: XIP start address may cause MPU programming issues

While this is helpful for actual systems to figure out why it
fails, the warning does not provide any benefit for build testing,
so guard it in a check for CONFIG_COMPILE_TEST, which is usually
set on randconfig builds.

Fixes: 216218308cfb ("ARM: 8713/1: NOMMU: Support MPU in XIP configuration")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/vmlinux-xip.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/vmlinux-xip.lds.S
+++ b/arch/arm/kernel/vmlinux-xip.lds.S
@@ -181,7 +181,7 @@ ASSERT(__hyp_idmap_text_end - (__hyp_idm
 ASSERT((_end - __bss_start) >= 12288, ".bss too small for CONFIG_XIP_DEFLATED_DATA")
 #endif
 
-#ifdef CONFIG_ARM_MPU
+#if defined(CONFIG_ARM_MPU) && !defined(CONFIG_COMPILE_TEST)
 /*
  * Due to PMSAv7 restriction on base address and size we have to
  * enforce minimal alignment restrictions. It was seen that weaker


