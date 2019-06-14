Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C64528F
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfFNDNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43940 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so664066pgv.10
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PDeednBQHQCWJxR0NKh3z84Gd8kBTabHNB90hamsE18=;
        b=h4QWP2mvAS916s6auJJfFzviYDDjb+PpuiP6IFws5Q2EJ2uXczHMoheg4jezvSjnWr
         IJZk2FdXIdxz4vVreKM+jSnz4myExFPgAWxesJ/pE5wWSokxF95skddVsLWzPAFq2qBa
         rWImiMAK2fNA0OmFptcJ3wBYFUWzhWTrrdjce/uktXZQsjpCDqQr+9KgdFG8HvaxatBa
         dldxbR/0B1pKiGZFbiisf23ByiGrVPy4yxKyj4SQtn3SLEwGY6B/MqLfsRWtZ1Y79LDF
         G069q0y5MeHuXEEZZlup4NZcn5SOiaCUZOD1Ayqbx3h0mCWmJuDIykLZNpm1YUL0O0cp
         P4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDeednBQHQCWJxR0NKh3z84Gd8kBTabHNB90hamsE18=;
        b=mtUBkbgUI6KQXtnE9e81AmNyEM0FXVuZLTyxpod4MQOq+ST27qgJKEtIWoVbW9ayMG
         tJp/lhTdqW/kiulv/j63MbPKoMLuCwNLBZDKdLPvJVPP+aZj+RgN/LzJSBlEwuQKbOok
         YEU4Rlpa52m+4so11sGfAMjMxrewV4kF34qt09C2IRKejV3w1td1h1Yd7gaXbxc71Nh6
         N/MF51unxlI836B5b7Gp7QLWq49pjI/Et9F0rb78I7K1W0WRd1QbH2w89uvU06VCbjqz
         LUMAmYxC8kjUZ/HkEKkrfMiN99oAkGKA+zBtvM3udpRdlxRg7faHtszXGyivTy0rvrp9
         RFkA==
X-Gm-Message-State: APjAAAV6n15dcqZ4tgp783yt36G519FWdbo0XH/8Lv/eiAMrJdmBieMZ
        rbw358S8+VCnbNYuSI4M4uyp+A==
X-Google-Smtp-Source: APXvYqyB8Yl7Jcgzm5jDA6YzQVPHMarwbfyU+veTySu1KhLykTJJEGVatBN2jEFN1ggpDp0OoSP18Q==
X-Received: by 2002:a63:a056:: with SMTP id u22mr33204122pgn.318.1560482031830;
        Thu, 13 Jun 2019 20:13:51 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id s12sm1032837pfe.143.2019.06.13.20.13.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:51 -0700 (PDT)
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
Subject: [PATCH v4.4 45/45] arm64: futex: Mask __user pointers prior to dereference
Date:   Fri, 14 Jun 2019 08:38:28 +0530
Message-Id: <1e0218d2ca5026bccbad88acba998349fe2195f1.1560480942.git.viresh.kumar@linaro.org>
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

commit 91b2d3442f6a44dce875670d702af22737ad5eff upstream.

The arm64 futex code has some explicit dereferencing of user pointers
where performing atomic operations in response to a futex command. This
patch uses masking to limit any speculative futex operations to within
the user address space.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/futex.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 34d4d2e2f561..8ab6e83cb629 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -53,9 +53,10 @@
 	: "memory")
 
 static inline int
-arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
+arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 {
 	int oldval = 0, ret, tmp;
+	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
 
 	pagefault_disable();
 
@@ -93,15 +94,17 @@ arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
 			      u32 oldval, u32 newval)
 {
 	int ret = 0;
 	u32 val, tmp;
+	u32 __user *uaddr;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+	if (!access_ok(VERIFY_WRITE, _uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	uaddr = __uaccess_mask_ptr(_uaddr);
 	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
 ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	prfm	pstl1strm, %2\n"
-- 
2.21.0.rc0.269.g1a574e7a288b

