Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A82AD19F
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 03:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbfIIBkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 21:40:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45025 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731948AbfIIBkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 21:40:35 -0400
Received: by mail-pl1-f196.google.com with SMTP id k1so5798201pls.11;
        Sun, 08 Sep 2019 18:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k1Kf8xMbkRDHr8n0Ak2LvAQxnQ9bC0rCE/1ZgT65+C4=;
        b=VV7Wrq6MY+yzFcwIwG1efanp6VJ8HOZ3HH9TT5BHjXp0/4DuBcVOdgszMBySBSDaU4
         aW29GAKuwuAweCAxIL4mBethP+Dp9f8+uky/+fop7aBAzRAd/l+trbYZDHUXwuEY4vgt
         Jc2b4Mkej7a3+I+3ngg2BukVELBFUvfQpGQ/1+OZTgyK1VoR2Z6q9SfwZ52ZhNgRSjYk
         fNAhI1QXHeDCa468pwoXpLJhLD6DJirSv2wvwzlmIxD5mwQXOE0unyQkGU0HDAdk1VWR
         FJxyQMpEzUoAr8EqAIoEyT/2kwwbziG0dd1rcMHoZgxvOS3d2TbQXjzQM3idAt+SRUYQ
         lQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k1Kf8xMbkRDHr8n0Ak2LvAQxnQ9bC0rCE/1ZgT65+C4=;
        b=oTVdum2OpyBcO5c/7q1MrYJ1Q8khoZIVpzuMeH6+F2xPNxhWGTXen9BrKilAhNHjzp
         H3SBpkoeTgyrxVMUDCm16c5TUJUHlqFSe/glMy2OQVqGE6INUeH//6eD7KpxD9KKBRZI
         wCuPrlykMkWK/Wwq9SW7ngKEa9bVA4R54CfNea+0zXTycaqFLyaYzVayDeIHTPp1InNZ
         9TJyhWYx1tK1CbaiA9fX7JshO3kYAREsGXmJxBfTbq9WFHReQHb4WaOpPme4AD6DNlb6
         KoabJ52u0IJcnj7p77cd5hlzSN5VpsYpxh3p92ZkLKB5i99ewpBL34E9GpNAbDQz68aL
         VGTQ==
X-Gm-Message-State: APjAAAVPvwoNByNg59ckbPNuLxCJfdfdqhzkSMfeTjipXC1Ju92aIkW2
        Nx4636XFXt6tew/f1QP1P/Jbljy3
X-Google-Smtp-Source: APXvYqx/KsEp8b0srchrNLkvc8bnJcJN2/lMsKwOLdoaFG+Diy+DWrPllHpcniCsDmSRUXTwZZilrQ==
X-Received: by 2002:a17:902:7c88:: with SMTP id y8mr21451213pll.306.1567993234474;
        Sun, 08 Sep 2019 18:40:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j26sm12413196pfe.181.2019.09.08.18.40.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 08 Sep 2019 18:40:33 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Waiman Long <longman@redhat.com>, loobinliu@tencent.com,
        stable@vger.kernel.org
Subject: [PATCH] Revert "locking/pvqspinlock: Don't wait if vCPU is preempted"
Date:   Mon,  9 Sep 2019 09:40:28 +0800
Message-Id: <1567993228-23668-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch reverts commit 75437bb304b20 (locking/pvqspinlock: Don't wait if 
vCPU is preempted), we found great regression caused by this commit.

Xeon Skylake box, 2 sockets, 40 cores, 80 threads, three VMs, each is 80 vCPUs.
The score of ebizzy -M can reduce from 13000-14000 records/s to 1700-1800 
records/s with this commit.

          Host                       Guest                score

vanilla + w/o kvm optimizes     vanilla               1700-1800 records/s
vanilla + w/o kvm optimizes     vanilla + revert      13000-14000 records/s
vanilla + w/ kvm optimizes      vanilla               4500-5000 records/s
vanilla + w/ kvm optimizes      vanilla + revert      14000-15500 records/s

Exit from aggressive wait-early mechanism can result in yield premature and 
incur extra scheduling latency in over-subscribe scenario.

kvm optimizes:
[1] commit d73eb57b80b (KVM: Boost vCPUs that are delivering interrupts)
[2] commit 266e85a5ec9 (KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption)

Tested-by: loobinliu@tencent.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: loobinliu@tencent.com
Cc: stable@vger.kernel.org 
Fixes: 75437bb304b20 (locking/pvqspinlock: Don't wait if vCPU is preempted)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 kernel/locking/qspinlock_paravirt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/qspinlock_paravirt.h b/kernel/locking/qspinlock_paravirt.h
index 89bab07..e84d21a 100644
--- a/kernel/locking/qspinlock_paravirt.h
+++ b/kernel/locking/qspinlock_paravirt.h
@@ -269,7 +269,7 @@ pv_wait_early(struct pv_node *prev, int loop)
 	if ((loop & PV_PREV_CHECK_MASK) != 0)
 		return false;
 
-	return READ_ONCE(prev->state) != vcpu_running || vcpu_is_preempted(prev->cpu);
+	return READ_ONCE(prev->state) != vcpu_running;
 }
 
 /*
-- 
2.7.4

