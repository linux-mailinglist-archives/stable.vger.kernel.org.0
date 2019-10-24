Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CA5E32DD
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfJXMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53189 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfJXMtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id p21so1253093wmg.2
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uZJuGMTWF5qRFyb7iiSg0MWxdZKBAoQdF2RYT4fwFtE=;
        b=auHjKwFCEj/n1R/QBrTzou0FU9vjtK4tyWmgpX2FaNpWZ1ZDdTcVNr9iJbWaXhVIWL
         oeXaPXEcPDDMcNf9/q9qvrEp6rtaXHQtBoegb2BNLxlanldAaEABH0dMQUpv0nFeaPn6
         TLnhDCFDkzz5ihoWw8ClaiqKawsheCWEZ/pSJikJmnxuVO+Fm7UhBLfsJv4h++QKGebs
         HFkKpHKPFIGsEIN/N+/ZzOm6bDMZoo9ayNmfgKIiUcZhJP8sPa1SHSYJvMHL7eHNr7XB
         qMctOgaW1OZ8hXFxArRPYawJ+S/LXKt0fsH1MFkpumUxaimk4n/Slw/xhNhRd0yUs9WX
         RQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uZJuGMTWF5qRFyb7iiSg0MWxdZKBAoQdF2RYT4fwFtE=;
        b=hSfgF/pRrkl0S4x61OM1KNYlSvVlJhnYH4+Jm12wN9DaIk7muS41WAcS6FTCR7Ryxb
         U/iaqyqLHB7wHBpKp/f+UqEbAvAzLDR2yWQcycEyemaN+GUnFn2WIKCPqwoqoHP1NN2a
         pnClvytx5gh3iBAhuqiyJP6EPM0jReO24o/pwiBOWvU1wisaGQOnvdoseR5+1PbVobyH
         +0g7jzgEhxg8KxFd/xaCeYtx8IWETGpRc6hbQRfiA1ijapAV0Wox+uc2tRUv1jF3dyU/
         gucufXhhsVsp7vas4H1UPr4VDN3dDr9Bs5wMcd+mOj3nMNpoexakMHmBCPaf11DOzXDD
         B4Hg==
X-Gm-Message-State: APjAAAV0CeqiFjHxLoHBL9FOE14eYj6fiVhYfe8DUmZ9N1/waIjGsWT7
        tDZWQkWrltPfcDl4+3LyK6N1jUu2fn8TMFBf
X-Google-Smtp-Source: APXvYqzlW6hCkOqacn6UT27pOejepyyDY20Xt9yZ2lhM9xpAnaYnf0JYpNZlPuht6/Pe1lIscLCVwA==
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr4474907wme.99.1571921355681;
        Thu, 24 Oct 2019 05:49:15 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 18/48] arm64: capabilities: Split the processing of errata work arounds
Date:   Thu, 24 Oct 2019 14:48:03 +0200
Message-Id: <20191024124833.4158-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit d69fe9a7e7214d49fe157ec20889892388d0fe23 ]

Right now we run through the errata workarounds check on all boot
active CPUs, with SCOPE_ALL. This wouldn't help for detecting erratum
workarounds with a SYSTEM_SCOPE. There are none yet, but we plan to
introduce some: let us clean this up so that such workarounds can be
detected and enabled correctly.

So, we run the checks with SCOPE_LOCAL_CPU on all CPUs and SCOPE_SYSTEM
checks are run only once after all the boot time CPUs are active.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bc76597abe7b..291f8899b37f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -529,7 +529,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	 * Run the errata work around checks on the boot CPU, once we have
 	 * initialised the cpu feature infrastructure.
 	 */
-	update_cpu_capabilities(arm64_errata, SCOPE_ALL,
+	update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
 				"enabling workaround for");
 }
 
@@ -1354,7 +1354,7 @@ void check_local_cpu_capabilities(void)
 	 * advertised capabilities.
 	 */
 	if (!sys_caps_initialised)
-		update_cpu_capabilities(arm64_errata, SCOPE_ALL,
+		update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
 					"enabling workaround for");
 	else
 		verify_local_cpu_capabilities();
@@ -1383,6 +1383,8 @@ void __init setup_cpu_features(void)
 
 	/* Set the CPU feature capabilies */
 	update_cpu_capabilities(arm64_features, SCOPE_ALL, "detected:");
+	update_cpu_capabilities(arm64_errata, SCOPE_SYSTEM,
+				"enabling workaround for");
 	enable_cpu_capabilities(arm64_features, SCOPE_ALL);
 	enable_cpu_capabilities(arm64_errata, SCOPE_ALL);
 	mark_const_caps_ready();
-- 
2.20.1

