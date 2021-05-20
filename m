Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6E38A7C7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhETKmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237283AbhETKkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B26161C85;
        Thu, 20 May 2021 09:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504538;
        bh=l2vINwjNzD/kL0d2dHFIoMKDvlhQqugNOsCZAc01pYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKxOwsxnzyMnAMlpnZ39WI5U5yFhf0DEA1/BIRdVJOnOibXunCoCJZdxmBV4+FP1z
         yGtYrfmO+W54MQ3HLcwxB4lu7RTjZlQBeAtHuv068urpkfLAe3kSDqqtNzOiRiD57j
         h3ATu6vq5o0ox5rywlOg3ICdkp5w3Uj+C06ZXZ7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 292/323] KVM: x86: Cancel pvclock_gtod_work on module removal
Date:   Thu, 20 May 2021 11:23:04 +0200
Message-Id: <20210520092130.220378035@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 594b27e677b35f9734b1969d175ebc6146741109 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6420,6 +6420,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();


