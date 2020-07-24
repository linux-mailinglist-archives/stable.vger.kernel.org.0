Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D36F22CC3C
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXRfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 13:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGXRfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 13:35:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB06C0619D3
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 10:35:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v11so3732194pfu.16
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 10:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9z4C5r79ACInbjfze4NId6Y2btX0M3fh8nl4dn9b26s=;
        b=fN4sZq/TP83yFzy+siEXLP4SrgOpx7NBN6ZiJVHwc3DsYjLS6vFtBeOspp2/PMgVYc
         BRp6JmUw/hMfGePHy/NJFvFDe4LzBFq+JJE/NvACrw8LLgRTmINP+mnqpWisEEkunNQo
         Fws/zekrL0GiMxgAUAMLgsE/13aJfgnxXFtzWBra/K5uSTlmzpjtzQ+184Qw3Ap7Dpx4
         UXtMdoJtToto60EenvqQcfQmcQXzbcG0KMU7+EsrPUzi9282GIyW5upCwSSvvhDFy5XM
         n6lc9UKvVwwk5SFEm6220t9AwlKp07h/YEo0IuB+ak1ke9ySE/DZhqPkzRHcs1peQsMn
         0L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9z4C5r79ACInbjfze4NId6Y2btX0M3fh8nl4dn9b26s=;
        b=sDkCKQGX2EK0JNH1hbPvm5hIyLOX9sjiDjSKnOUkYM4qAr3Sgq69F6OaGf9sDEdnWZ
         ulUZIifkhireeUq2XKifVXtvAaVgei7/0NgPQ+tNLXpxmnJTP/qY9X96yLpUR7c11jot
         Zn+gITCWhXwG7B2Ar0zG1oci68huJcUu6wXJEGWA/hmFkCqukAVAxfCH5HqkH8XbKhCL
         ZbqfkFuHZWl6IJMqLAb77By5p6ITqfyHErzUWcVxxFBpGBwcEr9wp+8a0jhoz4jRkpjZ
         DhPYKRyfJu2ScqNE9quVz4bJ8vw67P8RJR8br+pbPi6jyfYGvQAeZwFn9gZRs4XAh6/B
         eHBA==
X-Gm-Message-State: AOAM5328hbELU4mEULC6LRhO3X8xHuhnjljXTXDJmG3m0R6DPSE8B1Rh
        rwcD1HJxHJQ3XAMUhJfPNiKlRRx07tQ=
X-Google-Smtp-Source: ABdhPJzodcJYbtUzygaRALh5D65g0it/h4cc6rUSeS1ixMjdWjcC2aH+Frr78yzdpW4AwxEmwHhFlf6YfCg=
X-Received: by 2002:a17:90b:1b08:: with SMTP id nu8mr2292293pjb.190.1595612145895;
 Fri, 24 Jul 2020 10:35:45 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:35:36 +0000
Message-Id: <20200724173536.789982-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH] kvm: x86: fix reversed timespec values in PV wall clock
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8171cd68806b ("KVM: x86: use raw clock values consistently")
causes KVM to accidentally write seconds to the nanoseconds field (and
vice versa) in the KVM wall clock. Fix it by reversing this accidental
switch. Modulo the written nanoseconds value by NSEC_PER_SEC to correct
for the amount of time represented as seconds.

Fixes: 8171cd68806b ("KVM: x86: use raw clock values consistently")
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Parent commit: c34b26b98cac ("KVM: MIPS: clean up redundant 'kvm_run' parameters")

 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e27d3db7e43f..86228cc6b29e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1809,8 +1809,9 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	 */
 	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
 
-	wc.nsec = do_div(wall_nsec, 1000000000);
-	wc.sec = (u32)wall_nsec; /* overflow in 2106 guest time */
+	/* overflow in 2106 guest time */
+	wc.sec = (u32)do_div(wall_nsec, NSEC_PER_SEC);
+	wc.nsec = wall_nsec % NSEC_PER_SEC;
 	wc.version = version;
 
 	kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc));
-- 
2.28.0.rc0.142.g3c755180ce-goog

