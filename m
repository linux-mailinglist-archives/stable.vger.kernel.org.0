Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA137D717
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbfHAITo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:19:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46979 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbfHAITo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:19:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id k189so14684731pgk.13
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7GSqiJ6aBNFVvBBcZiH2v3S1Pbs9vo106t8SFNGIe4=;
        b=cYaRmjxpRpihR3ST0Z43FI6gGebPhfoWhCbpU+IMiA14zAmRrIrwHkLNPGxQbO3dwQ
         GKIF1ls+9uq+hNUdROGeAa0AknTV9vYQ5TFKVHdwI/2EmvyukmhMRTDGiva55cX2FenL
         aGDOJ5qzMHxinEWIcGbZyYj1dw2pxHV/LjncanSzzQL3S6e2pW5AVum+1MNUj63YHMgI
         N3LCp/eNbnqtm6aGhrAr6JZ+sPtBGtd3EyRopNtHb2rYD6dzl/Nm03uWLQROVJdNpWp7
         tXl7No6eYiHWr+8KJFDPN8JbC84yPGs9/3Latvd+MfH6CI93+nX4fYz1N+Wls25RH5UP
         oHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7GSqiJ6aBNFVvBBcZiH2v3S1Pbs9vo106t8SFNGIe4=;
        b=fK00QAWMZ6PSf0dsc4WzvhjN5W+f7+F0VJV/vpZYKlLUFnpBaswMj77PPEfK5EiFYp
         ApubR6xHxVIlVj54ueielf/ChmulZe+P65T2SRsPv6hc5rPy3/MINr2h1GFTqTVu1cAd
         rln3CHG1qZToR0DdiXX5K7Pl1i8dmWHwAjK6xbG4tkqQLYEs3opL9qjyZm71QJ/SRsoe
         m2+VLCJO3Am4pM9y302jNQXEzqZZMwqRDYHwwJj3wOE6JbK9H64Q5uSQh3IBRkdJmkaz
         FCMHj4QbHyir7bnwObJ5FHcmQKXTpHfEq1cR6Ggbof2eZv4aXebcRdELKH5TjSA+35y6
         Qpdg==
X-Gm-Message-State: APjAAAVyEpNJhJFd9yAGOecj4dpYAXW71KQlG2pajwD+312DlIbxdmzS
        KW7iwmkKoe/oqhAxAkp/IYYvN52Hajo=
X-Google-Smtp-Source: APXvYqy+r/ZBXTixIjv/M9S1DYk3sEBpMLeC+4UwOYm9t+/UkhM1ETIyQn3yLY+cECisdJqFRi6T/A==
X-Received: by 2002:a62:3c3:: with SMTP id 186mr51852915pfd.21.1564647583498;
        Thu, 01 Aug 2019 01:19:43 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id l1sm91579706pfl.9.2019.08.01.01.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:19:43 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 03/47] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date:   Thu,  1 Aug 2019 13:45:47 +0530
Message-Id: <62376918dc348842e21f6eb62235220f53d35cdb.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 6167ec5c9145cdf493722dfd80a5d48bafc4a18a upstream.

A new feature of SMCCC 1.1 is that it offers firmware-based CPU
workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
BP hardening for CVE-2017-5715.

If the host has some mitigation for this issue, report that
we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
host workaround on every guest exit.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Viresh: Picked on only arm-smccc.h changes ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/arm-smccc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index da9f3916f9a9..1f02e4045a9e 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -73,6 +73,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 1)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
2.21.0.rc0.269.g1a574e7a288b

