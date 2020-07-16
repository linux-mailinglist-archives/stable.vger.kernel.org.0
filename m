Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88D222B5B
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 21:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGPTAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 15:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgGPTAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 15:00:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A79C061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 12:00:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so5265739pje.0
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 12:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=fyn164Bdkj2irREyDrQ4gDc5FoH5Th/YZJL5rirObpQ=;
        b=CzViUalycgyJI66C+bAXJH1eKoiQkPq4xCBH9/uRD3hCLovh+QcoMylR4dvP0EfoEb
         oSy9cMAAqktDCjg8hSkZwPd4Mlm7I+D3DVwSKU+tqko174F7hbRmZNh8Qp9DONXvyiSC
         gBC7hmINrqnRcYkJZJYyYUDxs+qHI9Dlnc+mW6YAwKMef5hKMU9Oi94yU5tIXAd3yKSm
         zfsIZGftkQdJ3VO+Mnk02mLczifvdhCieuZpkY8B6+vty25KyVZ+gFfPnDNyngUPwdr3
         L3lxCYu6O1tp/3gwyWha2bSG3uKwWltstdD0ctRaOAF90n4BXoX4RLbj7iZXiwN0B599
         Sufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=fyn164Bdkj2irREyDrQ4gDc5FoH5Th/YZJL5rirObpQ=;
        b=eSeAy1E89idA1NC+Xwp5m3mKEyxsdgmF/mHXH2/RnANZNDCsTv92Hl2P2uq/qQjRTk
         U2pVrOODET9eHjGmnvDK6bbRtq7uab/Rq0x/+BfRyDiVVX7/4+JN7PzLL9kUarWozRhe
         fIK+QtZytI5ev13CT6jXcKJ3hPTRsOgt9+sev1TH5qDBscfGuyvNsNOxYHJq6Mt5kD6J
         a+93HnJ4GlqR5FUj+hGR7q8dZbSlixdIM+z7dPErpONACz52HSPR02MRCXdp0JP7Vl3y
         OpFuBjOU/FgnJiSRzot/ETmTiuJ8qLc/XinhJAPpkhOjHa5JO6/2iNa6sVjXJXvRu3Wk
         6+9Q==
X-Gm-Message-State: AOAM533upONGhUIqi56Mtrxttojpw5UZnKjk1ML371bgE8TznyYF7gjF
        /xDKj2KNxYaRBSJ2QFjB7UwY8RMIjwQ=
X-Google-Smtp-Source: ABdhPJye0EpnoE0w0J9W8b7JjHrTpR03+uJl1O9zgNxNw0u6soZ0gAMlI4xiQfRuW/ef+k45T28+kA==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr6415455pjb.88.1594926001154;
        Thu, 16 Jul 2020 12:00:01 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id 82sm5413563pfz.151.2020.07.16.12.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 12:00:00 -0700 (PDT)
Subject: [PATCH] RISC-V: Upgrade smp_mb__after_spinlock() to iorw,iorw
Date:   Thu, 16 Jul 2020 11:57:26 -0700
Message-Id: <20200716185726.1133113-1-palmerdabbelt@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>, stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:         linux-riscv@lists.infradead.org,
            Will Deacon <willdeacon@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While digging through the recent mmiowb preemption issue it came up that
we aren't actually preventing IO from crossing a scheduling boundary.
While it's a bit ugly to overload smp_mb__after_spinlock() with this
behavior, it's what PowerPC is doing so there's some precedent.

Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/include/asm/barrier.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/barrier.h b/arch/riscv/include/asm/barrier.h
index 3f1737f301cc..d0e24aaa2aa0 100644
--- a/arch/riscv/include/asm/barrier.h
+++ b/arch/riscv/include/asm/barrier.h
@@ -58,8 +58,16 @@ do {									\
  * The AQ/RL pair provides a RCpc critical section, but there's not really any
  * way we can take advantage of that here because the ordering is only enforced
  * on that one lock.  Thus, we're just doing a full fence.
+ *
+ * Since we allow writeX to be called from preemptive regions we need at least
+ * an "o" in the predecessor set to ensure device writes are visible before the
+ * task is marked as available for scheduling on a new hart.  While I don't see
+ * any concrete reason we need a full IO fence, it seems safer to just upgrade
+ * this in order to avoid any IO crossing a scheduling boundary.  In both
+ * instances the scheduler pairs this with an mb(), so nothing is necessary on
+ * the new hart.
  */
-#define smp_mb__after_spinlock()	RISCV_FENCE(rw,rw)
+#define smp_mb__after_spinlock()	RISCV_FENCE(iorw,iorw)
 
 #include <asm-generic/barrier.h>
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog

