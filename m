Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CF845274
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFNDMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35716 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so685941pgl.2
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EmoJPia4REdmsbQ4H3ol9/VbnaPc01q7ugk/yi36Irk=;
        b=PkSwe6ZM+84aZssqC9yjuM9KdfFBu/kwlLo5pJlTemrHl3tbpWb2jFu9oCwjIJLbjZ
         +R2sV3v4Svb7AGgxYSENh7WQ/BsSqkO3SrL6i1rAA8K9jGSppUSeagoCqZ7kApJZrdmN
         Ut75sba5qxz1fnQrw+BDywqbPFjsmoNKEmHjhAV+153MleaDr7XY+6okqraszIUYzqRX
         yRGdmp4jlswT+ElJ/Br6Q9ooyShdDsSjoot+sJxssHE/ZFb7kM+znGZgY02db3aviW/3
         qBfzYmNrPIFScOHk+93wZHDGvUVHziCN41rErxUmySN2LDp2wy1cJYAsbuOtFZOVECLc
         6YPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EmoJPia4REdmsbQ4H3ol9/VbnaPc01q7ugk/yi36Irk=;
        b=KgY32MtTlnjO8zKiKslYr7/DLu1xPSJYs7glXi+umBTDKw1494Gae+YbthYhR+u8d0
         rDGm0Fr2anc3SaNl0clpdJ3w/b+0IQt6gmUycgWlUPvWeK91Wdwd8bFu9794dgIBcUi5
         ecMQZwpPlEE+mAOmd3OxdedIDsMVO6DPDxjczAHeflE8AsjZRTnAzfVE8F6aexogjs2r
         zpABjk6438fgwwlzM0lRbhYC6JeAnCZrfpqKfQzYlGAGXdcmtwPmGbNQFcn+5ccMeOFN
         QHLnI9OQzFJQ5ymd4wjf3JGtdTQqJt+iuPvzksB/kPn6NUarD1kOOh98hcAJXzHwrtsy
         s91w==
X-Gm-Message-State: APjAAAWVwSADBQK/SDuup0An7gLeSUI6Pm+ag7ctBQ9CtNsjjI8B2oQL
        6RedygjisbWWAuu/Pmr4M7tONA==
X-Google-Smtp-Source: APXvYqzFJ5M7fhmGROMUgYHr4HeztcDrQP1Hyg2FauE3GQtu6eOZ00AU7ushEX3OlWUqiKLJAas35g==
X-Received: by 2002:aa7:825a:: with SMTP id e26mr98018300pfn.255.1560481966986;
        Thu, 13 Jun 2019 20:12:46 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id o13sm1237168pje.28.2019.06.13.20.12.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:46 -0700 (PDT)
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
Subject: [PATCH v4.4 20/45] mm: Introduce lm_alias
Date:   Fri, 14 Jun 2019 08:38:03 +0530
Message-Id: <8500aeb27596eef7bd952f988c8db0a4b2f655c6.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

commit 568c5fe5a54f2654f5a4c599c45b8a62ed9a2013 upstream.

Certain architectures may have the kernel image mapped separately to
alias the linear map. Introduce a macro lm_alias to translate a kernel
image symbol into its linear alias. This is used in part with work to
add CONFIG_DEBUG_VIRTUAL support for arm64.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/mm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 251adf4d8a71..f86fdf015c74 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -59,6 +59,10 @@ extern int sysctl_legacy_va_layout;
 #define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
 #endif
 
+#ifndef lm_alias
+#define lm_alias(x)	__va(__pa_symbol(x))
+#endif
+
 /*
  * To prevent common memory management code establishing
  * a zero page mapping on a read fault.
-- 
2.21.0.rc0.269.g1a574e7a288b

