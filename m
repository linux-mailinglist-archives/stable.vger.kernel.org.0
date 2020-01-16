Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850A413D68A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgAPJPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:15:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59963 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgAPJPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 04:15:13 -0500
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1is1F9-0003M7-L2
        for stable@vger.kernel.org; Thu, 16 Jan 2020 09:15:11 +0000
Received: by mail-wm1-f70.google.com with SMTP id 7so415110wmf.9
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 01:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aVzo3u3vzwM5ThkvqoKrUpe2i/w/3V0ttK2gZpY+UCQ=;
        b=qchJaV5fpFmQT7kr4T7ULDFBro8VI4klBqxlq8qH8+Najg+Q6ex/5LTaYD1S3Lqewq
         0Qbz/fucZyxAzDCtqRdI1KcUE5ET8WBRhWMeBslChfzmSWXoFPaqBG1o/Gx79v5sxwiZ
         +//dUMTaGblAs1aFLjzsLPuu2ODKN1udn8auivHsCizycuqU9Pswf82AdrxhOul5Ski9
         j3Uuj/75coB2/b8xhzKajwkacup4mJxFN4c0/X7S/OoocUZSgTG4hhAo7ghmrj1ujeBp
         n7RleSvT1XsKV0iZDkHvFrWVTRBf5XYSgg9HlLwR7oZHRPlYF+6rmmRouO5fy/+a4Sjp
         67nQ==
X-Gm-Message-State: APjAAAVKa3LvQLs7/Lg7H03lKs9MAtYSYmR8Bm7HxrksPVTauiJa8+4g
        3UKEmkllprLMJ3fOEZsBjhjpnVmgHnQSzikHw2iREah3e2kon5EGy2akvBoMLewkbI7i5czpoE2
        W7y6vOAeQMmVR9DjrQFSWsMZ4q27OBi1kpA==
X-Received: by 2002:adf:fd43:: with SMTP id h3mr2097714wrs.169.1579166111106;
        Thu, 16 Jan 2020 01:15:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqzratkF/B8qzbpgDwWkihwwcZK8nMEX6KpcYOcXwqWtRqUdvo0CuVrcpa52Z2Vp0z/z6i4B8w==
X-Received: by 2002:adf:fd43:: with SMTP id h3mr2097693wrs.169.1579166110943;
        Thu, 16 Jan 2020 01:15:10 -0800 (PST)
Received: from localhost.localdomain ([81.221.209.144])
        by smtp.gmail.com with ESMTPSA id f1sm28478062wru.6.2020.01.16.01.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 01:15:10 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH 4.14 1/2] arm64: add sentinel to kpti_safe_list
Date:   Thu, 16 Jan 2020 10:14:21 +0100
Message-Id: <20200116091422.8413-2-juergh@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116091422.8413-1-juergh@canonical.com>
References: <20200116091422.8413-1-juergh@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 71c751f2a43fa03fae3cf5f0067ed3001a397013 upstream.

We're missing a sentinel entry in kpti_safe_list. Thus is_midr_in_range_list()
can walk past the end of kpti_safe_list. Depending on the contents of memory,
this could erroneously match a CPU's MIDR, cause a data abort, or other bad
outcomes.

Add the sentinel entry to avoid this.

Fixes: be5b299830c63ed7 ("arm64: capabilities: Add support for checks based on a list of MIDRs")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 60066315d669..ae28979676c1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -836,6 +836,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		{ /* sentinel */ }
 	};
 	char const *str = "kpti command line option";
 	bool meltdown_safe;
-- 
2.20.1

