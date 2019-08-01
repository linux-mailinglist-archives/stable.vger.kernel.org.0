Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73517D74B
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfHAIVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42930 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731116AbfHAIVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so31903212plb.9
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5vIaM+vVchIZG6+Gh1WcpqO4yKh8TnPpANQdT1zWCg=;
        b=NpnvqtjK49HYBgbUiDGgi6xSJ03C6UtcvxRKF5TE0WHirWiIbnALLSZJY52O1CHNZK
         FenUuArNYNx5FObhoUmbuVHY9+TQhtb77eXZaTPvmLlDTDZeLOiYBkEwSAjK+oLv7sAo
         9RDwz+ktZskTt9WhFVwRYsPJ4+JwH+AmkH6fTrFVQBH0oJfx9Wtx8PhUuFsqweiS5dqt
         8x7HU+jAlADxbEjOdCPkC1PWXYO1E7Nee4cq2F4h1WH4JTuScbkwZbvCbxMXmRSomJwA
         heyhgkDjkxTvakUp5J31B8/EXj5YPr2HQVcwbMfT9pU3CxpqNiRy+OWbMVRomKzEExiO
         PIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5vIaM+vVchIZG6+Gh1WcpqO4yKh8TnPpANQdT1zWCg=;
        b=lLwY9HV05G2xOqRk/uBQkisV/EcP+76kcHRmxiqi43DJYOiQNOkGnn3M1MM2N9pD1S
         fMQ8ZLi75rJ03apO/Hd7Ni/Vz9cLMY+P0qzdQxGIgvZq7xa5SUXANS/lTzL1MaFyZBEK
         kAEqd8mORWOZzCCYpdOGdGpnejIr5c2oi7XXcTu22aQzsnBCJC3RRM9fuB+s7McvUpJb
         WnpAqFntXd+l6CP8R+ZxiQLYT72tkrSwq2OTHOaGUBnbKwZDLkmsViEq8lMtN+MWl2l8
         ln2sCtyrOmxtCnB0zsAIubwhPrngODKg8guWAwKEZv2cTzjlnyaQxXfUsabocY2GhVSz
         +8iQ==
X-Gm-Message-State: APjAAAVm06A8xmAxqfVk11NGXR9KqxMVjA/d2EGtU4oIWulj/vLLtZBA
        sm5biL2IwXuvpWAePF1hZKr1O7xT28U=
X-Google-Smtp-Source: APXvYqxHzo8Gha+mkvmGOss5j3RTk3imIHXq1nsnN4IBoKCBHaJe829TSCm3FiSqE9ZmAng+hLC2qw==
X-Received: by 2002:a17:902:6b86:: with SMTP id p6mr127587221plk.14.1564647663394;
        Thu, 01 Aug 2019 01:21:03 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id z4sm111700635pfg.166.2019.08.01.01.21.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:02 -0700 (PDT)
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
Subject: [PATCH ARM32 v4.4 V2 34/47] ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()
Date:   Thu,  1 Aug 2019 13:46:18 +0530
Message-Id: <89ae15bfdcc72b42ebacde01603f09fd5cd880b7.1564646727.git.viresh.kumar@linaro.org>
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

Commit e3aa6243434fd9a82e84bb79ab1abd14f2d9a5a7 upstream.

When Spectre mitigation is required, __put_user() needs to include
check_uaccess. This is already the case for put_user(), so just make
__put_user() an alias of put_user().

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/uaccess.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 94b1bf53b820..7f96a942d9a0 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -407,6 +407,14 @@ do {									\
 	__pu_err;							\
 })
 
+#ifdef CONFIG_CPU_SPECTRE
+/*
+ * When mitigating Spectre variant 1.1, all accessors need to include
+ * verification of the address space.
+ */
+#define __put_user(x, ptr) put_user(x, ptr)
+
+#else
 #define __put_user(x, ptr)						\
 ({									\
 	long __pu_err = 0;						\
@@ -414,12 +422,6 @@ do {									\
 	__pu_err;							\
 })
 
-#define __put_user_error(x, ptr, err)					\
-({									\
-	__put_user_switch((x), (ptr), (err), __put_user_nocheck);	\
-	(void) 0;							\
-})
-
 #define __put_user_nocheck(x, __pu_ptr, __err, __size)			\
 	do {								\
 		unsigned long __pu_addr = (unsigned long)__pu_ptr;	\
@@ -499,6 +501,7 @@ do {									\
 	: "r" (x), "i" (-EFAULT)				\
 	: "cc")
 
+#endif /* !CONFIG_CPU_SPECTRE */
 
 #ifdef CONFIG_MMU
 extern unsigned long __must_check
-- 
2.21.0.rc0.269.g1a574e7a288b

