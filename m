Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B28E10531F
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKUNcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:32:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41926 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUNcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 08:32:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id b18so4401619wrj.8;
        Thu, 21 Nov 2019 05:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=+C/cs017OrqlyrW+ijapSly866aUVTUkDdweWrl6lFE=;
        b=eYpeBUR8QAO1EAEZp+JARhcC6Wz+tdkK2dpTM8QAFn18v1PBrRBAoSxPNJNg1Oqs2N
         P81KObUNS4ZjP3MhCpJHcwXHNMK3WydTf5ILGcCLYVfTwM6mbPkDfEDtS6X+VLConr8P
         xiNkmSWRev6Ptm424zs55BDDz544q9oVrCEl2OAySET98SjgA7a3T7axjNKqqrv3sgLg
         kXB/JlLlRQdTSg0xhCcrlcz2pSJzx/bQ3HHuJ6+KK/s8FJkOpFdVPXREISyO7SvD8Zeg
         ePLeltpyddXJVzWcOvIrTCFS0FoBKJCh9tHXbBfQOEkV/RKupLEo4LnwEda2D2CK7s/G
         yMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=+C/cs017OrqlyrW+ijapSly866aUVTUkDdweWrl6lFE=;
        b=EkzgVI46OnSbyiLK4UlVxOj4OM061tkROOdqPAmxps0rjF8T8rH5BYxHmstyJnGAdt
         kkv0xQi/g+1QaiacEoxhfQvQrT7AkDA2aCu/vtk0KgGZHPW7/wDfg4EDqMvWScRpwvto
         EpGjSaVEhFxsrjjZXhXXwTodSZEU1r8uvwrFqA/9rIf9Aas8eX3diIb+/6GX5JjUZ0vG
         IVdESiKpainZgw6lCGzH1bmGHs1RO+k4zWqr3QWS87t0BuATzePtTrjvE0Zlk4M0yp87
         2ZVCsyBeCvN7xI2J9DILkhrcgciVEj/9TM6RNF1/WxPsGib1rHuYVROIUUiWCzKuL78F
         Ws0w==
X-Gm-Message-State: APjAAAXDRAkdOOb/YgrX1DOfg31PiuXirBZmZyM0k47oJbUf+sPvEJD1
        1ZsUSfhZp3DPLVPkQghi/g8yGD0T
X-Google-Smtp-Source: APXvYqxgWF5Wbj1AfbjM8EnG5GkwL4TW9/QfOscwNry6IPTsj+6uG1pih6CfGBhNznygbNEwOUi0JQ==
X-Received: by 2002:a5d:51c8:: with SMTP id n8mr10632150wrv.302.1574343139817;
        Thu, 21 Nov 2019 05:32:19 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m25sm2703329wmi.46.2019.11.21.05.32.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 05:32:19 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] KVM: nVMX: expose "load IA32_PERF_GLOBAL_CTRL" controls
Date:   Thu, 21 Nov 2019 14:32:18 +0100
Message-Id: <1574343138-32015-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These controls have always been supported (or at least have been
supported for longer than nested_vmx_setup_ctls_msrs has existed),
so we should advertise them to userspace.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..4b4ce6a804ff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5982,6 +5982,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
+		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
@@ -6001,6 +6002,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
 #endif
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
 		VM_ENTRY_LOAD_IA32_PAT;
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
-- 
1.8.3.1

