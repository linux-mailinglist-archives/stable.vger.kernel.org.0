Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F23F540F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbfKHSxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732666AbfKHSxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:53:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58980222CF;
        Fri,  8 Nov 2019 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239231;
        bh=HoAwLUVebhRyUIJxWgNCYwzotcFZ2Jz19CSj3Fnu+us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbxcuntcDh+Zvq2eIJizV3oW0dUZaU9oaXFBTVv8Wo6yf4wTR4/1gxKz3bR26TanS
         bjBV9XGOyfx83UHqcTk1dWArSkgTTfIrhcUGLIonMEf6oDKuYoESH2nX7sM4q/Meby
         +8RTcbMHEvCousGkL19sF66/0FjpriwFkuYUcxzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 37/75] arm/arm64: smccc: Add SMCCC-specific return codes
Date:   Fri,  8 Nov 2019 19:49:54 +0100
Message-Id: <20191108174745.750485322@linuxfoundation.org>
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

commit eff0e9e1078ea7dc1d794dc50e31baef984c46d7 upstream.

We've so far used the PSCI return codes for SMCCC because they
were extremely similar. But with the new ARM DEN 0070A specification,
"NOT_REQUIRED" (-2) is clashing with PSCI's "PSCI_RET_INVALID_PARAMS".

Let's bite the bullet and add SMCCC specific return codes. Users
can be repainted as and when required.

Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/arm-smccc.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -264,5 +264,10 @@ asmlinkage void arm_smccc_hvc(unsigned l
  */
 #define arm_smccc_1_1_hvc(...)	__arm_smccc_1_1(SMCCC_HVC_INST, __VA_ARGS__)
 
+/* Return codes defined in ARM DEN 0070A */
+#define SMCCC_RET_SUCCESS			0
+#define SMCCC_RET_NOT_SUPPORTED			-1
+#define SMCCC_RET_NOT_REQUIRED			-2
+
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/


