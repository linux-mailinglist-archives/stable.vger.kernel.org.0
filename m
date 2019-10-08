Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E33CFDDF
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfJHPka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38463 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfJHPka (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id w12so19989301wro.5
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O18xZOEMMJydjKMD80TyT8oRhz4SapCait5DnLCUfdg=;
        b=zwctIF/ukmMnoeE7TiEtLzRgjRx1h+0miKYBzh8SxwqVgoLeEnVrS1vnd+kTLJIeS3
         wGt06XJKluONW8oBFsmSVORQ8/6dl33wDmQqFFQtuHK1GRZ92Q/Q2EcTtYA4SgtjOwgq
         hSPKNC9jM5vADNrq8yj4lUMT/h+ssjjcwW5gRupYIxBxzpQLLOEOBtEibjfk22CET88x
         wNwSimuXSoaqRaoa5cXG/bbQ47xof/pD7xMIEbc3e2Z8Xe8VTvmd+Gf/YBXXufxNc/P/
         IzkTwKsxKxTWCE7Aq5yrNLhGtK/9+SKni7O7wVx0Kwe+nvMMENEipiQ/1KnodvzrylcG
         0gsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O18xZOEMMJydjKMD80TyT8oRhz4SapCait5DnLCUfdg=;
        b=oeN13nJ+x1QAgDKHqMElao75eRITR2K0cUAV1jiz0tHjFEq2FNHU+ZgySeu+VGv2tj
         BNsLPz1WEy6l9NHFsXwGFRazUA1nMnTAvn+zsI4uXgSI/sr16stcLEeP8BlQdot+9JbS
         y3j3wu2HlN7ctG8V5U1yXYiUHBnRHtgneAVDled7WaOXcQv9k9SbcyhMITWjYecuE4yA
         HMbeVfU62HKXaYhaOq4w61QTC9matpj9dI952kwfyG0NcfpgZlDoYdJV08lCx2nGYEDD
         JyQuVIBh7dvMNGNmCxSzBQEjaN4NUPz9MhR1tbJ6Nah3nQ+/5ORQZ+4HJztnsKdrkt6F
         bCIQ==
X-Gm-Message-State: APjAAAW5zZN8uxO4gQ3V7jBocImM5/HtEtoSfpjOlNdGPksZiIycWmGT
        WHZCgnV3nRQ8pbDHPvgwxgUoZQ==
X-Google-Smtp-Source: APXvYqypH7JrYxjtBRHUzeS8ZMlhq3WMnbVCetS1pPun1EDOh7twRNxqiTyq0fUcyCfaGoz7cmEFdg==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr26513389wru.242.1570549228737;
        Tue, 08 Oct 2019 08:40:28 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:27 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 15/16] arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB
Date:   Tue,  8 Oct 2019 17:39:29 +0200
Message-Id: <20191008153930.15386-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit eb337cdfcd5dd3b10522c2f34140a73a4c285c30 ]

SSBS provides a relatively cheap mitigation for SSB, but it is still a
mitigation and its presence does not indicate that the CPU is unaffected
by the vulnerability.

Tweak the mitigation logic so that we report the correct string in sysfs.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0ce4a6aaf6fc..292625fcba04 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -341,15 +341,17 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	/* delay setting __ssb_safe until we get a firmware response */
+	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
+		this_cpu_safe = true;
+
 	if (this_cpu_has_cap(ARM64_SSBS)) {
+		if (!this_cpu_safe)
+			__ssb_safe = false;
 		required = false;
 		goto out_printmsg;
 	}
 
-	/* delay setting __ssb_safe until we get a firmware response */
-	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
-		this_cpu_safe = true;
-
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0) {
 		ssbd_state = ARM64_SSBD_UNKNOWN;
 		if (!this_cpu_safe)
-- 
2.20.1

