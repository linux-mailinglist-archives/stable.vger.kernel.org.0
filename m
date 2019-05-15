Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E3E1ECE5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfEOLCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfEOLCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27E220881;
        Wed, 15 May 2019 11:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918171;
        bh=fBRVkqBjHSTyyyVUnqFlJbhJuCXdnpu2AZKuH3hCTl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3adg7ZqmboDm1Iv+5wa7QJczHzEKyrRntBF0lqriHFVk5DJiBooE44WGICP/RzRs
         o2fC/u8QZLRz4r2wUCHLWxxeTWK9I5ntDrBcpyY8Sj3QZVmjPD238XSoWP8jx8ypkp
         twIvotRCgGd+1cEKNDBREyFBanSn5wo8Ef5HhAbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 033/266] powerpc: Move default security feature flags
Date:   Wed, 15 May 2019 12:52:20 +0200
Message-Id: <20190515090723.652749951@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

commit e7347a86830f38dc3e40c8f7e28c04412b12a2e7 upstream.

This moves the definition of the default security feature flags
(i.e., enabled by default) closer to the security feature flags.

This can be used to restore current flags to the default flags.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/security_features.h |    8 ++++++++
 arch/powerpc/kernel/security.c               |    7 +------
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -63,4 +63,12 @@ static inline bool security_ftr_enabled(
 // Firmware configuration indicates user favours security over performance
 #define SEC_FTR_FAVOUR_SECURITY		0x0000000000000200ull
 
+
+// Features enabled by default
+#define SEC_FTR_DEFAULT \
+	(SEC_FTR_L1D_FLUSH_HV | \
+	 SEC_FTR_L1D_FLUSH_PR | \
+	 SEC_FTR_BNDS_CHK_SPEC_BAR | \
+	 SEC_FTR_FAVOUR_SECURITY)
+
 #endif /* _ASM_POWERPC_SECURITY_FEATURES_H */
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -11,12 +11,7 @@
 #include <asm/security_features.h>
 
 
-unsigned long powerpc_security_features __read_mostly = \
-	SEC_FTR_L1D_FLUSH_HV | \
-	SEC_FTR_L1D_FLUSH_PR | \
-	SEC_FTR_BNDS_CHK_SPEC_BAR | \
-	SEC_FTR_FAVOUR_SECURITY;
-
+unsigned long powerpc_security_features __read_mostly = SEC_FTR_DEFAULT;
 
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, char *buf)
 {


