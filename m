Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85B847A76B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhLTJty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhLTJty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:49:54 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A2CC061574;
        Mon, 20 Dec 2021 01:49:53 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t26so18842207wrb.4;
        Mon, 20 Dec 2021 01:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tu1mxNPlCAVLOtBC6EzxrlJgXNOEwpITHtoKkTh60es=;
        b=SXHWNfqkCrGQXOkoHpd2QkFJoXgq6+3NL4hRhwnphh6215y/So/BesHBH7pNR1L36W
         s+RbBOZdzzmK/LOzm4B/b5EQoM1t9CIWyIOydT9jig9Fwo6p+V5O5QuPuMyR7lKe6i6N
         bI3sx7QfqZFfhiw7k69/SOGU6frpdGB7I5D8hGhNQiLMv45ZWV8PLbFt19sFsn91IyD4
         SE76mpFC+9sDpqfeueIMpT48Iz9EzH1pzvSGFBnxAhnYOF/ofXx/NZqFSpHb/ujbpcfS
         VfBulP026LTJB+9g8sCU6vs0gYYLfd2CBDdHbQYGmTKocLOhDRaUdEnWbTuZ0YULVKSW
         sVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=tu1mxNPlCAVLOtBC6EzxrlJgXNOEwpITHtoKkTh60es=;
        b=xhIHB6NTP4fHrMAZWzHkpJsrxg98tstjz7W4a/3ssk7TLdp4pMZi2ig7g8yupeZlS7
         5f+VPhJsZK2HmojgfnPZM5Wi9pk2sMqgmATtDaxkU0slQWpU23HOUVJmKIzqR/ldyxfK
         3QLj8EOlW2AdYNQCHe+6wHNmNqhFh6/oQyDs5ZFKNLorxXHFyrh0+VGYeDrsPUZlEczP
         h0RXghgx3/8cei7oh9htxg93FU72Mm8GXqoBQByCjiUNwJXgas/N/UsWnFyxRwm/LxD6
         qCvFKSUzrpkMaUn6y94VSrxEoa/0Po0Fhk4+ylG5DY6CN/Mlm59BV6rO+ndgoNsSn/OV
         d7TQ==
X-Gm-Message-State: AOAM532jF4tFuEgxRjaelY1CiUBnFOBu36zfA7Q8sbguSUlKlYbgg/tk
        wJ0Mwy8M4xNzz2/P06JOCBVlNEj1jQQ=
X-Google-Smtp-Source: ABdhPJy0TCffoVMUlYGgCcNZsQ75ynAF2S04SoBtYyBjxtirlnrqIayjsU/rwMVpw18K6vEYXetfcA==
X-Received: by 2002:a05:6000:188a:: with SMTP id a10mr11921103wri.423.1639993792586;
        Mon, 20 Dec 2021 01:49:52 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id q8sm3047963wrx.59.2021.12.20.01.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 01:49:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH for-stable] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Date:   Mon, 20 Dec 2021 10:49:50 +0100
Message-Id: <20211220094950.288692-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e90e51d5f01d2baae5dcce280866bbb96816e978 upstream.

There is nothing to synchronize if APICv is disabled, since neither
other vCPUs nor assigned devices can set PIR.ON.

After the patch was committed to Linus's tree, it was observed that
this fixes an issue with commit 7e1901f6c86c ("KVM: VMX: prepare
sync_pir_to_irr for running with APICv disabled", backported to stable
as e.g. commit 70a37e04c08a for the 5.15 tree).  Without this patch,
vmx_sync_pir_to_irr can be reached with enable_apicv == false, triggering

 	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))

Fixes: 7e1901f6c86c ("KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dacdf2395f01..4e212f04268b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7776,10 +7776,10 @@ static __init int hardware_setup(void)
 		ple_window_shrink = 0;
 	}
 
-	if (!cpu_has_vmx_apicv()) {
+	if (!cpu_has_vmx_apicv())
 		enable_apicv = 0;
+	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
-	}
 
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
-- 
2.33.1

