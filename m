Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC252AF1EB
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgKKNUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgKKNUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:20:50 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E7BC0613D1
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 05:20:50 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id o23so2699466ejn.11
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 05:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sMazCSF4CFuNBWmGwYfS+HzKdoSOvCzHZkHhs0oGXHg=;
        b=cxWP3PcCMA5+/BBqpxNcmC0W9grGyJA9rDB71OmIkfTMfJSdIyF3cNtd2L1kH3jvrh
         B9ErqSaVgKcUyHG2xDlf+qMzwgetyfLG5u7/ReRaoFBL6uyJCU3f9I0T0IWy+e1oTz90
         RcNKdbAN2SUoe4M/mKoBQvRTMvNnKtMtZgmRTbO7nEaWuqWcZial2dRqbRiEmVD7bqUW
         biEdKAS1fbo2zip6miQcQVDA4HU3BbEyDJQvNgF+gZ17y4atDDtiAfv/gl15uqmr9ug5
         wbWTM7/9tBPP3ZLaMuQY7BuPLG1TKr2RTA2VvMxukogeAzJpddaX2Sk50t814Sw8o9wO
         3lNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sMazCSF4CFuNBWmGwYfS+HzKdoSOvCzHZkHhs0oGXHg=;
        b=TJ2+AymuGlKfXergzekLTxav3v2Elj+CMitjzmE65ONqZOrjFCZtWDKehwqbFnzQYn
         N4+HonYd41KjVUmKl/6e6tlHlQRJiOMjCzx2tfpGCJImh/9SEgiC9DODvAJ/6ZFA21cQ
         NdWJVwIYRzGKkc6sQevUETU44+boNRKWeG6EsFBgRnVVrWkX+bkl8FXXJ4qRREaYNWPH
         8nNnaH6RihtMaXRU+soC8xa7GqJnwCq1vB8VzpIQXaiI3D5sXV4oXUsNbaVq+B5uNLvw
         1kR/AkYNnqqbXz/H8Q0yPFRwiEXYG4KEL3BV3L3qv3MDxDarZM/bj9Cmii4NbvzwVxK2
         WcVg==
X-Gm-Message-State: AOAM530WyaqvDqsQJjc4KJOYC7qLwTc0fT83hPGKLOisSHSqHLEb1mJX
        ANrskrkpShl0+a9t/VrW63eW2w==
X-Google-Smtp-Source: ABdhPJxos/GeR/yynEfINgjpdWbNhohHA1F59jKqD7Vww5vce+kSmQtKnRC29YdahH/cyXQL1PYryQ==
X-Received: by 2002:a17:906:a20b:: with SMTP id r11mr26345261ejy.41.1605100848757;
        Wed, 11 Nov 2020 05:20:48 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4951:7a00:5552:6745:93b5:959])
        by smtp.gmail.com with ESMTPSA id z23sm856948ejb.4.2020.11.11.05.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 05:20:48 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH stable-5.4] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
Date:   Wed, 11 Nov 2020 14:20:47 +0100
Message-Id: <20201111132047.64845-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

This msr is only available when the host supports WAITPKG feature.

This breaks a nested guest, if the L1 hypervisor is set to ignore
unknown msrs, because the only other safety check that the
kernel does is that it attempts to read the msr and
rejects it if it gets an exception.

Cc: stable@vger.kernel.org
Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200523161455.3940-3-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a
use boot_cpu_has for checking the feature)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 708b37274cb5..4cacf4669235 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5226,6 +5226,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_x86_ops->rdtscp_supported())
 				continue;
 			break;
+		case MSR_IA32_UMWAIT_CONTROL:
+			if (!boot_cpu_has(X86_FEATURE_WAITPKG))
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_x86_ops->pt_supported())
-- 
2.25.1

