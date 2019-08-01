Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9897D754
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbfHAIVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34607 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfHAIVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so33609616pfo.1
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ds/lGPMr1EeNlwL4g2s5u78S6SjnXx7V9zy6A/rndeo=;
        b=mrBLXFMWzLa/t7R+RAPTUBkuVhtuO0SSPUQKBcr4iUCBlgaEqHyhHd1/uFMJhGMS4H
         N7XjT/O08TzqMLeVggwfT1HkHWMoa9XZeUoJ2ULmHwCAkn2l0Y5Ub+4RWPx5FREjiOG3
         xUhF0T115Bzb04sIYFubQM6mOq/14QvHEkB5h782l/RJNU1EKnLx/NMzfR0bgMV3We07
         4zuE/xFl23PtDuJ0i3REzyBcqE3BaNSJTNyqxML7FsXc7LTY8qLCZ3zUH+TZ1ypTx/gE
         qFmHoJxAufo87ZLAQx8l988GrmSI8dpXGDOubdDWBDHk030J6NlJEpENvqm9TEq1OThR
         d0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ds/lGPMr1EeNlwL4g2s5u78S6SjnXx7V9zy6A/rndeo=;
        b=ioQXpGsJuBlxeWAUGlk8kcL0ueVTjZWmD+IgET628nEky/fuK+nX/dM2bxWlFf0VdH
         kBytBgOqSlH5lhDwF1mVWMysThkCfIRYOsD4maiM9j5tQGOZbIPxjxZn/PBG3AVwm4mQ
         FhjYHUR07wnBOG+IvEr7xKsZQvx+pTP9nydZSIZZGZFcQvn90kPzQ2MbfOZ3fr+aLE64
         ssI4wSQMRa42HyATp815vJyNy3xBKJG6dJB9VtSpMZLZjtcZRSrejAh4MmI0IFj3zGg4
         MOkMWZDgdmwn6/DFsBEv0Te6aUGQNEjCy+DVn34AuW8juuWvyZ77CfZK46ReI0qXeVp+
         X1tw==
X-Gm-Message-State: APjAAAWoy2kvosKcOE/RYVuEe2o9ng6716/vPtQYVfvHvQqB7+BAnxS6
        Dlcgcq71+DDUKmKlv25ab6H/lrpIEB0=
X-Google-Smtp-Source: APXvYqwtKxDMpgoZCbvREEE29QxNQP1W961hLJzisPedFonBaTo+teb/eU6GTFHq0O6jopgGgyalGg==
X-Received: by 2002:a62:642:: with SMTP id 63mr52289837pfg.257.1564647676154;
        Thu, 01 Aug 2019 01:21:16 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id v18sm69519775pgl.87.2019.08.01.01.21.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:15 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 39/47] ARM: make lookup_processor_type() non-__init
Date:   Thu,  1 Aug 2019 13:46:23 +0530
Message-Id: <8571a7c6a6ff472e0d794311dda2ee4fb64f29eb.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 899a42f836678a595f7d2bc36a5a0c2b03d08cbc upstream.

Move lookup_processor_type() out of the __init section so it is callable
from (eg) the secondary startup code during hotplug.

Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/head-common.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 8733012d231f..7e662bdd5cb3 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -122,6 +122,9 @@ ENDPROC(__mmap_switched)
 	.long	init_thread_union + THREAD_START_SP @ sp
 	.size	__mmap_switched_data, . - __mmap_switched_data
 
+	__FINIT
+	.text
+
 /*
  * This provides a C-API version of __lookup_processor_type
  */
@@ -133,9 +136,6 @@ ENTRY(lookup_processor_type)
 	ldmfd	sp!, {r4 - r6, r9, pc}
 ENDPROC(lookup_processor_type)
 
-	__FINIT
-	.text
-
 /*
  * Read processor ID register (CP#15, CR0), and look up in the linker-built
  * supported processor list.  Note that we can't use the absolute addresses
-- 
2.21.0.rc0.269.g1a574e7a288b

