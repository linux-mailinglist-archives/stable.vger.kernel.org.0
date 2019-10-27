Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0769E690C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfJ0VLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbfJ0VLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:20 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00502214AF;
        Sun, 27 Oct 2019 21:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210679;
        bh=0Yf3Sk80zrmXm6bH+9w5Mz+Gheo+SF6FY/8Hxrs8ppQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qy0/wXN0XgOvjdfROp1tDZn7rUxNI7gzb2o3F77IDutNFaDt78U1c2ER+GLX5URGp
         x1gKQyIoSeIcRNkWu3k4m6AJuo7msFTDJngOWTpVcnq9AOlWbPFwwYA0UmQGEA4ivW
         E3UuIkd2nN5IkTE1xrTHGctVl//6YCpPnQkD2riQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 055/119] arm64: capabilities: Allow features based on local CPU scope
Date:   Sun, 27 Oct 2019 22:00:32 +0100
Message-Id: <20191027203324.012028429@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit fbd890b9b8497bab04c1d338bd97579a7bc53fab ]

So far we have treated the feature capabilities as system wide
and this wouldn't help with features that could be detected locally
on one or more CPUs (e.g, KPTI, Software prefetch). This patch
splits the feature detection to two phases :

 1) Local CPU features are checked on all boot time active CPUs.
 2) System wide features are checked only once after all CPUs are
    active.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,6 +485,7 @@ static void __init init_cpu_ftr_reg(u32
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
+static const struct arm64_cpu_capabilities arm64_features[];
 static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 				    u16 scope_mask, const char *info);
 
@@ -526,11 +527,12 @@ void __init init_cpu_features(struct cpu
 	}
 
 	/*
-	 * Run the errata work around checks on the boot CPU, once we have
-	 * initialised the cpu feature infrastructure.
+	 * Run the errata work around and local feature checks on the
+	 * boot CPU, once we have initialised the cpu feature infrastructure.
 	 */
 	update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
 				"enabling workaround for");
+	update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU, "detected:");
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1349,15 +1351,18 @@ void check_local_cpu_capabilities(void)
 
 	/*
 	 * If we haven't finalised the system capabilities, this CPU gets
-	 * a chance to update the errata work arounds.
+	 * a chance to update the errata work arounds and local features.
 	 * Otherwise, this CPU should verify that it has all the system
 	 * advertised capabilities.
 	 */
-	if (!sys_caps_initialised)
+	if (!sys_caps_initialised) {
 		update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
 					"enabling workaround for");
-	else
+		update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU,
+					"detected:");
+	} else {
 		verify_local_cpu_capabilities();
+	}
 }
 
 DEFINE_STATIC_KEY_FALSE(arm64_const_caps_ready);
@@ -1382,7 +1387,7 @@ void __init setup_cpu_features(void)
 	int cls;
 
 	/* Set the CPU feature capabilies */
-	update_cpu_capabilities(arm64_features, SCOPE_ALL, "detected:");
+	update_cpu_capabilities(arm64_features, SCOPE_SYSTEM, "detected:");
 	update_cpu_capabilities(arm64_errata, SCOPE_SYSTEM,
 				"enabling workaround for");
 	enable_cpu_capabilities(arm64_features, SCOPE_ALL);


