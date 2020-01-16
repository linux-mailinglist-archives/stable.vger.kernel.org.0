Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1370813D68B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgAPJP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:15:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59970 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgAPJP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 04:15:28 -0500
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1is1FO-0003Ne-Lv
        for stable@vger.kernel.org; Thu, 16 Jan 2020 09:15:26 +0000
Received: by mail-wr1-f70.google.com with SMTP id j4so9030910wrs.13
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 01:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vusVyG/HdIs5SqMX8T1FHrEOTntqQSGVra2a2Gyteq0=;
        b=V0/BcPL6ia51s9KcvSp4hY+yTWXUtvzBapbDkekH9o83GFTKfcMK05rUmrGAFtQe08
         VORPLNtP+/ZfOqPToWyqZaVQsxhw9VZB/SQ5NQF8QGAlrzyGlnA3CUbvjabPNlpCpb3n
         Gi/I/mpEmhhG9osNP7H3TUE+HdEDBai8WtuUpTHycxJI1R13IWg37gi5q55BAiBP7PVn
         N7sO1EwZyR9qIaTWWNahTim7BuWYnH0cijHqsFp/kl5R+jUg47+sJY/2Bme/w3HVLGJT
         e3jyR7Or2o2xOmrYFcXB4D2eyJ9wWcDiRn/VKPJ33HnGlBPbw/thtFV5KjLVUTa0VTKe
         8pyw==
X-Gm-Message-State: APjAAAWfqzb2M+C03xVPU0mMbm4mXY84lEXb1NgEcZpRtYifqkSTEdB4
        Ekm4Ztvw61JKSPjZKp7dQoJlw6nBXG6SbMZH53VeAKrzRJD1bRk6pqgO+GTNh77FHGgN0UccUiZ
        i9a/8mzx3mHYOFwW/H+pkS0itIVtoWGh/uQ==
X-Received: by 2002:a7b:c956:: with SMTP id i22mr4994464wml.67.1579166126218;
        Thu, 16 Jan 2020 01:15:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhDDhcLPmOGfV+0DC5jEMztJlFwwMMIYez0/0IS4JBuhoGv7GFVEU4OgddjcFYwgGBX7QeWQ==
X-Received: by 2002:a7b:c956:: with SMTP id i22mr4994444wml.67.1579166126047;
        Thu, 16 Jan 2020 01:15:26 -0800 (PST)
Received: from localhost.localdomain ([81.221.209.144])
        by smtp.gmail.com with ESMTPSA id f1sm28478062wru.6.2020.01.16.01.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 01:15:25 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     stable@vger.kernel.org
Cc:     Dirk Mueller <dmueller@suse.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH 4.14 2/2] arm64: Check for errata before evaluating cpu features
Date:   Thu, 16 Jan 2020 10:14:22 +0100
Message-Id: <20200116091422.8413-3-juergh@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116091422.8413-1-juergh@canonical.com>
References: <20200116091422.8413-1-juergh@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Mueller <dmueller@suse.com>

commit dc0e36581eb2da1aa3c63ceeff0f10ef1e899b2a upstream.

Since commit d3aec8a28be3b8 ("arm64: capabilities: Restrict KPTI
detection to boot-time CPUs") we rely on errata flags being already
populated during feature enumeration. The order of errata and
features was flipped as part of commit ed478b3f9e4a ("arm64:
capabilities: Group handling of features and errata workarounds").

Return to the orginal order of errata and feature evaluation to
ensure errata flags are present during feature evaluation.

Fixes: ed478b3f9e4a ("arm64: capabilities: Group handling of
    features and errata workarounds")
CC: Suzuki K Poulose <suzuki.poulose@arm.com>
CC: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Dirk Mueller <dmueller@suse.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 arch/arm64/kernel/cpufeature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ae28979676c1..09c6499bc500 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1278,9 +1278,9 @@ static void __update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 
 static void update_cpu_capabilities(u16 scope_mask)
 {
-	__update_cpu_capabilities(arm64_features, scope_mask, "detected:");
 	__update_cpu_capabilities(arm64_errata, scope_mask,
 				  "enabling workaround for");
+	__update_cpu_capabilities(arm64_features, scope_mask, "detected:");
 }
 
 static int __enable_cpu_capability(void *arg)
@@ -1335,8 +1335,8 @@ __enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 
 static void __init enable_cpu_capabilities(u16 scope_mask)
 {
-	__enable_cpu_capabilities(arm64_features, scope_mask);
 	__enable_cpu_capabilities(arm64_errata, scope_mask);
+	__enable_cpu_capabilities(arm64_features, scope_mask);
 }
 
 /*
-- 
2.20.1

