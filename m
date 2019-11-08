Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B1EF54C2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbfKHSxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732341AbfKHSx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:53:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 128B3218AE;
        Fri,  8 Nov 2019 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239208;
        bh=5q8MdXl36BTYt1/zFIU1xr7uiq22NFrK9WPUMpYkyg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXKwNwBG+CZ7/p032AlPwQ0E6MGBcUyM3Vtq7DUrbPzN+PvlKpbRz/A2rD7OhKi67
         O99fWLmo28k/qTPkBKFZ4mbVHL8vCKoOMq0O1FUy98A371UW0wPV8vTFx8XYUBjwQ4
         v8+i9D3ZzMAgUQS+oJsj0FQDZFLYC2mh8IaQ4Lvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Hackmann <ghackmann@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 4.4 35/75] arm/arm64: smccc: Make function identifiers an unsigned quantity
Date:   Fri,  8 Nov 2019 19:49:52 +0100
Message-Id: <20191108174744.434421656@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit ded4c39e93f3b72968fdb79baba27f3b83dad34c upstream.

Function identifiers are a 32bit, unsigned quantity. But we never
tell so to the compiler, resulting in the following:

 4ac:   b26187e0        mov     x0, #0xffffffff80000001

We thus rely on the firmware narrowing it for us, which is not
always a reasonable expectation.

Cc: stable@vger.kernel.org
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com> [v4.9 backport]
Tested-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/arm-smccc.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -14,14 +14,16 @@
 #ifndef __LINUX_ARM_SMCCC_H
 #define __LINUX_ARM_SMCCC_H
 
+#include <uapi/linux/const.h>
+
 /*
  * This file provides common defines for ARM SMC Calling Convention as
  * specified in
  * http://infocenter.arm.com/help/topic/com.arm.doc.den0028a/index.html
  */
 
-#define ARM_SMCCC_STD_CALL		0
-#define ARM_SMCCC_FAST_CALL		1
+#define ARM_SMCCC_STD_CALL	        _AC(0,U)
+#define ARM_SMCCC_FAST_CALL	        _AC(1,U)
 #define ARM_SMCCC_TYPE_SHIFT		31
 
 #define ARM_SMCCC_SMC_32		0


