Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0538313E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbhEQOgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240121AbhEQOdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:33:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA42613F0;
        Mon, 17 May 2021 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260968;
        bh=aDl7CI31KRCpujTGlycyuxBH8b2aZG9xBJYxehUrVRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2emMDC2wUsFcKtkdlahFu1CKRDXoHGVJkUuUpjTdLSbQ8RiC6Y7WY6mqkyVHSp3A
         MTjE4KRoOi5qRS9ZMlmecBHGCLQRG3nUHY3zeCKXEvc7pFnGvKhV8K/HD2exW4Ci3t
         YNMeN6bjy4Ip0he4esh8dACDojuhTPTnoPzOtXEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 277/363] KVM: x86: Cancel pvclock_gtod_work on module removal
Date:   Mon, 17 May 2021 16:02:23 +0200
Message-Id: <20210517140311.983195418@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 594b27e677b35f9734b1969d175ebc6146741109 ]

Nothing prevents the following:

  pvclock_gtod_notify()
    queue_work(system_long_wq, &pvclock_gtod_work);
  ...
  remove_module(kvm);
  ...
  work_queue_run()
    pvclock_gtod_work()	<- UAF

Ditto for any other operation on that workqueue list head which touches
pvclock_gtod_work after module removal.

Cancel the work in kvm_arch_exit() to prevent that.

Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Message-Id: <87czu4onry.ffs@nanos.tec.linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3406ff421c1a..f1fd52eddabf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8096,6 +8096,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
-- 
2.30.2



