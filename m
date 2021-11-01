Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58F0441761
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhKAJgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233692AbhKAJd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6915C610A2;
        Mon,  1 Nov 2021 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758732;
        bh=9noM7hHTOaAdFAqtn5N/TwngkaAf9W5fhyZTkZG+RXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcAdzYGJDD0Ik6MOxsviMfI4tYtEeBPDTCgaEDAkpBydvPUI+f0nO1MALTXeNcCcf
         VGqWJvk1KQ4Jav7lEPSr66EtaC1VRWnsq1YB+90GeH4DWcGWKYV8EtViJG5L7u8FdW
         cBW4xZyg4/gVRBFxWnlFLNhtoQZ80gL0xCFFCffA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 06/77] ARM: 9141/1: only warn about XIP address when not compile testing
Date:   Mon,  1 Nov 2021 10:16:54 +0100
Message-Id: <20211101082513.217113632@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -176,7 +176,7 @@ ASSERT((__arch_info_end - __arch_info_be
 ASSERT((_end - __bss_start) >= 12288, ".bss too small for CONFIG_XIP_DEFLATED_DATA")
 #endif
 
-#ifdef CONFIG_ARM_MPU
+#if defined(CONFIG_ARM_MPU) && !defined(CONFIG_COMPILE_TEST)
 /*
  * Due to PMSAv7 restriction on base address and size we have to
  * enforce minimal alignment restrictions. It was seen that weaker


