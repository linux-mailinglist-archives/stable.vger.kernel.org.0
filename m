Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594774526C
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFNDM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38683 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id a186so495527pfa.5
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VnHrOqiLyuTpal1o2zRenzQv7xKEdgOssME91mwrbo=;
        b=Tb47hPFhrekRIM/B4VddOaEWndYWU2Mpfbs111lRorm/o8pnyAoKX5rwgAtdbh9Ccw
         fwb7GLYKgWUtNl8cQJpMYeOvZoNMd7Wu5qd7n6wAz1atAQo8t+VQSLxOEhz9562am+vj
         VWg/seVR9qMm30yB3daUKfVvrwvi/YkYDymDHYZ4mYYiUQZPdeBSQdGrFz/nxMizP2tH
         yYxcEWqg/Jga4CVq0WCtbo1VV+7l2YAP2pyZw6FikYnWiH76f1YfzGyFVJNfVMaAVbWA
         Y3N6VH6UYvlE9futQG+BB1WPjVZ3xk0qI+pY+L/tJrJ2Z6UndfT1oaEkJe4T3EbTckEH
         vF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VnHrOqiLyuTpal1o2zRenzQv7xKEdgOssME91mwrbo=;
        b=rfbRmarPQuM3S3wsZpoyOI/Pz8aBcFPoha/Kx4Pe+FxW5+EgjSmtDqrFYA12bkJIIW
         nrBg9pa/lt8EMKdwhy7jyiKGMMHeGti/X1kEr6xxu+zRrWFmzImWcYNNGx7s9abK81sW
         dfPqvO03aBYe0KFlMXegFua1IH9Gv11dTrhxp1HIhWin8KZ58XqRKxGcIiu37qnOYx/d
         JHsHgHYgvxeadwKywLfgg9mVoLVP/G3XoLdd0dlvJ/JY4nsL/KGIGjMlxTQFsjJeJzov
         rbJutFt7Yn3CkrfOqY7FBlDM7dTOEpLgWXbd/4/3heyT4NfHdSYt/cpCmeQREMhMk0/d
         ntVg==
X-Gm-Message-State: APjAAAWCHtLSZ0WLAcNlGbu1DeCKzhJ6o8jwLj4cStJnpBXAJf8/YZFU
        +w6aqoGZJZrGRcHu3Ts4vejq5A==
X-Google-Smtp-Source: APXvYqxB1kT4JeouoUecMrtwQioocrM699/ETpWT/9TwmrlHZEVVfCDOCCQfYKs58tBjEcSSaW4k0g==
X-Received: by 2002:a65:4209:: with SMTP id c9mr34462297pgq.111.1560481948541;
        Thu, 13 Jun 2019 20:12:28 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id g2sm1165232pfb.95.2019.06.13.20.12.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:28 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 13/45] arm64: cpufeature: Pass capability structure to ->enable callback
Date:   Fri, 14 Jun 2019 08:37:56 +0530
Message-Id: <16cc80ceb76db7e889b16a3d9b8c45ae821087de.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 0a0d111d40fd1dc588cc590fab6b55d86ddc71d3 upstream.

In order to invoke the CPU capability ->matches callback from the ->enable
callback for applying local-CPU workarounds, we need a handle on the
capability structure.

This patch passes a pointer to the capability structure to the ->enable
callback.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Use &caps[i] instead as caps isn't incremented ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c1eddc07d996..c7a2827658fd 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -780,7 +780,7 @@ static void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 			 * uses an IPI, giving us a PSTATE that disappears when
 			 * we return.
 			 */
-			stop_machine(caps[i].enable, NULL, cpu_online_mask);
+			stop_machine(caps[i].enable, (void *)&caps[i], cpu_online_mask);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -894,7 +894,7 @@ void verify_local_cpu_capabilities(void)
 		if (!feature_matches(__raw_read_system_reg(caps[i].sys_reg), &caps[i]))
 			fail_incapable_cpu("arm64_features", &caps[i]);
 		if (caps[i].enable)
-			caps[i].enable(NULL);
+			caps[i].enable((void *)&caps[i]);
 	}
 
 	for (i = 0, caps = arm64_hwcaps; caps[i].desc; i++) {
-- 
2.21.0.rc0.269.g1a574e7a288b

