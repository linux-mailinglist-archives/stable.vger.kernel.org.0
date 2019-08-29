Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0ED1A18CE
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfH2Lfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33227 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfH2Lfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id go14so1457579plb.0
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j1PYP8TRl6+XUUI1RLnfOfH8okdoaEeO+GZk5UMu4vo=;
        b=ip6B9wM3ozT5CT1rKsg2Sx1YA1l7zbcAgXEfTHR261lT39mZNG5TpiKTz9bDHVjWF/
         MhPxnm5U803S8RYlcg+msMGad2IdyLt5YMVzPJ289jnrjReXJym3hbxs3Q0WhVuK/qtm
         /DwZ4q8yg+0JBX18qJEvbeaM40xU4/tbRRruNn7a7pLOcd8TEP2pZ9DdfE5rwE7u9CI2
         CBVPFXZAPY9xmM13w3m6rRpK0LlCV0OBWY2x4d0MsCYxX3gK13I52wFCfVKnnllBRB8R
         bV1M+7Sn8TJmVTh920gC5luu4Ixg8dZJjKZaEYg5xbQ2FB4N3QmIuViy85Jy8FYMpCzW
         Frkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j1PYP8TRl6+XUUI1RLnfOfH8okdoaEeO+GZk5UMu4vo=;
        b=k7+virurx3AWG91mwJmpzTbtgThealeL6Iq3AOEj65Wzsug2GoZtFyrt+RhDH0M780
         gqueNBMvAqHl48J0re4/Rsm9l7flrfjyX/rCQBdK0Wv/rrXhG3IyStsxMjvwmjbBJadp
         DR23S2J1MN0gMJ/CdAhfKLrnMnOJJmE/OyZeQJADOdBOlJi7jWWoWSDTXw1Bjz2uLojc
         iHCi8x+EBOtjIXeXGzCkueFIU+s6jTuw/z871Tcm/LpToL21/9/rb+OuY/O01NoLidPA
         +TqQiiz2D//Q2gpUAPGDj3Aw7P6LO8KubDi5pvwXce4pEu3g02ZtSSbTwps8JJzrGXVM
         j0AQ==
X-Gm-Message-State: APjAAAUtYQ1vAg2k+WmtaW3c/ZNlq72Yp/4HC2LTXcjBnF5Y/xOsnF2j
        3dIfklBrjkvusEtYt9/BV/RgJWYw7vM=
X-Google-Smtp-Source: APXvYqwuPHsKKVQRD+tHwC8rwaqwFTzSbBajVIUNajXxIz6vJIkjabi8x87nDdU3W5m8zTUhPNz7fg==
X-Received: by 2002:a17:902:2bc7:: with SMTP id l65mr8972172plb.119.1567078546059;
        Thu, 29 Aug 2019 04:35:46 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id j11sm2356521pjb.11.2019.08.29.04.35.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:45 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 20/44] arm64: Run enable method for errata work arounds on late CPUs
Date:   Thu, 29 Aug 2019 17:04:05 +0530
Message-Id: <0022a5059adb91ea87175fb215ddd19440bed555.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 55b35d070c2534dfb714b883f3c3ae05d02032da upstream.

When a CPU is brought up after we have finalised the system
wide capabilities (i.e, features and errata), we make sure the
new CPU doesn't need a new errata work around which has not been
detected already. However we don't run enable() method on the new
CPU for the errata work arounds already detected. This could
cause the new CPU running without potential work arounds.
It is upto the "enable()" method to decide if this CPU should
do something about the errata.

Fixes: commit 6a6efbb45b7d95c84 ("arm64: Verify CPU errata work arounds on hotplugged CPU")
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d9f095439011..047f1da59cb1 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -125,15 +125,18 @@ void verify_local_cpu_errata(void)
 {
 	const struct arm64_cpu_capabilities *caps = arm64_errata;
 
-	for (; caps->matches; caps++)
-		if (!cpus_have_cap(caps->capability) &&
-			caps->matches(caps, SCOPE_LOCAL_CPU)) {
+	for (; caps->matches; caps++) {
+		if (cpus_have_cap(caps->capability)) {
+			if (caps->enable)
+				caps->enable((void *)caps);
+		} else if (caps->matches(caps, SCOPE_LOCAL_CPU)) {
 			pr_crit("CPU%d: Requires work around for %s, not detected"
 					" at boot time\n",
 				smp_processor_id(),
 				caps->desc ? : "an erratum");
 			cpu_die_early();
 		}
+	}
 }
 
 void check_local_cpu_errata(void)
-- 
2.21.0.rc0.269.g1a574e7a288b

