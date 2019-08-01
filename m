Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE67D751
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbfHAIVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42886 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731106AbfHAIVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so33593416pff.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K9TMbtUgLTyiUr1AVMR6X3v/Vfqpdps5jv4IrzU02gI=;
        b=u2IY36x0captMh4lU1M0wOFOAmston0O2MSPdh8WfOWDhEl6wCe1fHWEB302u0RLea
         ojVO3+6Uw8ngcEcpYwUKq96/4ZNyKwEJSwrmqBpTewb+1cTQJdgIBsGPrIcskcI3D/WE
         5Eg2rHSAqdcoxT2Rx0APBgbNWmChW6h+Ch+VfBXwjDUY8xtjNpJh8eZCmXoMtYQOIAnB
         KDRBkaRJKx2tqjYEejnBltvZKwg1B+mta/JF1UVSfxbYY86SwBJDW+O9haVVpEQ7x9Ou
         qnTAXeFV4PukhvZIY1cb0Nqw3H7EhNmjHszAQmsiggMC3v6tFdCB8MczrpQKPRwPqCdj
         P4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K9TMbtUgLTyiUr1AVMR6X3v/Vfqpdps5jv4IrzU02gI=;
        b=uXREeHs3nbu4pznBONM1vCUnuJwPMyFItWVzFgIA7+sM0v3LsQMbduxGJTh/ASIrju
         oqhtmWiqPXKU26PsGIJQ9Boz0088rj9EvaQ+BzJq0k9jQt1RUQdUsqDk4SJnJXXMMmig
         nx6AYVba8FQd8IKn4gqFwXecwe/grpYhvzTyVw6kLSRfCaiIOm7x0xQoYPaZ1RCkN4Q+
         vK9QB5+qKrpNpg9tAN4h6ZxlKJ3p77MvU+Ho+vZTfAsPahlN7u2DRqqV9Hv4wmzUPrzg
         mU1t8UO6akQnkZnAdkWE3/Bdn4XXIO3Uv2a/490gE4k6Lfc+YqHjATmcBow7Eoogb1mA
         VJGg==
X-Gm-Message-State: APjAAAXCHCwgAARu3kiPMqabgyedaEp7f89QZld20+2yad1iT5GB7u19
        x0P21EOz6Z6R9/0JNjtwzT6Cz/g1QWs=
X-Google-Smtp-Source: APXvYqzf4Da2l4H3VbnCpzaG3Gl/2i8UZm2Ug4a/Qfb/Ei7T9vRFRA4QvB/43nQ/qYdiWxALcg224w==
X-Received: by 2002:a62:e901:: with SMTP id j1mr52916707pfh.189.1564647668335;
        Thu, 01 Aug 2019 01:21:08 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id y194sm47244254pfg.116.2019.08.01.01.21.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:07 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 36/47] ARM: 8797/1: spectre-v1.1: harden __copy_to_user
Date:   Thu,  1 Aug 2019 13:46:20 +0530
Message-Id: <d4353075bcd15cf29b4ff5f0d8dada48a4c28ea2.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit a1d09e074250fad24f1b993f327b18cc6812eb7a upstream.

Sanitize user pointer given to __copy_to_user, both for standard version
and memcopy version of the user accessor.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/lib/copy_to_user.S        | 6 +++++-
 arch/arm/lib/uaccess_with_memcpy.c | 3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/lib/copy_to_user.S b/arch/arm/lib/copy_to_user.S
index caf5019d8161..970abe521197 100644
--- a/arch/arm/lib/copy_to_user.S
+++ b/arch/arm/lib/copy_to_user.S
@@ -94,6 +94,11 @@
 
 ENTRY(__copy_to_user_std)
 WEAK(arm_copy_to_user)
+#ifdef CONFIG_CPU_SPECTRE
+	get_thread_info r3
+	ldr	r3, [r3, #TI_ADDR_LIMIT]
+	uaccess_mask_range_ptr r0, r2, r3, ip
+#endif
 
 #include "copy_template.S"
 
@@ -108,4 +113,3 @@ ENDPROC(__copy_to_user_std)
 	rsb	r0, r0, r2
 	copy_abort_end
 	.popsection
-
diff --git a/arch/arm/lib/uaccess_with_memcpy.c b/arch/arm/lib/uaccess_with_memcpy.c
index 588bbc288396..0b4fe892d00b 100644
--- a/arch/arm/lib/uaccess_with_memcpy.c
+++ b/arch/arm/lib/uaccess_with_memcpy.c
@@ -153,7 +153,8 @@ arm_copy_to_user(void __user *to, const void *from, unsigned long n)
 		n = __copy_to_user_std(to, from, n);
 		uaccess_restore(ua_flags);
 	} else {
-		n = __copy_to_user_memcpy(to, from, n);
+		n = __copy_to_user_memcpy(uaccess_mask_range_ptr(to, n),
+					  from, n);
 	}
 	return n;
 }
-- 
2.21.0.rc0.269.g1a574e7a288b

