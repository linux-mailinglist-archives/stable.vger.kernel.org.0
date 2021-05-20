Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1B38A9C2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhETLGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239079AbhETLEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:04:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C5161D15;
        Thu, 20 May 2021 10:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505084;
        bh=EYqJyQn1h3/jnWGL9CemVfZG4p72PJcqzn8dYrWlgVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0B+SR5StWb5bqEvNA6hAL5pXqqjcmeHZ3/PzjFfzdLjd4QAqYdE140dRlx934Ykk
         hcfGXwNpmTtrPawHH9LDtcNZxndYkaOLS7uXp3mUFRRitBnKnW9Ek4KbeX0+tvTRLo
         wFb5OqIhL/9VnJ4FGcFuFGm0w7i994YR+xc3/M+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 214/240] KVM: x86: Cancel pvclock_gtod_work on module removal
Date:   Thu, 20 May 2021 11:23:26 +0200
Message-Id: <20210520092115.867797789@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
@@ -6268,6 +6268,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();


