Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6737214E069
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgA3SCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:02:04 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46024 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbgA3SCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 13:02:03 -0500
Received: by mail-wr1-f67.google.com with SMTP id a6so5198956wrx.12;
        Thu, 30 Jan 2020 10:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wxAE+rmvrsDq27Iqeo6nEv/48a4RUlHGSm7qdXtegOw=;
        b=gu2kirdOGx8YQhv8sLhotM0mi1J0Qxp5BjsY+pQjI6/ZTbFWCJPndiRPKWm/HDqmLJ
         XrdZ/pum1kE1hsiSoUh/EwOf/XbPnUKFxGxLJ1Dbp+NNYYYBhuqB7vb2BTf+CDy/avLi
         XHyEr141cj3gsW9MYKy5q7JhbjkYtRveUIYo+Fk55BKddNPHSm2u0+kkc+dPi5wMnIhh
         xKrU3B21Uv9NcBZ+nAevzs4JtE7ZljK2Gyx02Ro6oVF6ISuvlsfwjcd+ixxDvnxbmZG9
         i7OJ34QStHDTlibxr38Bj7/0XItrSlEGP6GEweIruQlZGbn/mZxqXTdoOolIQDQ0o6MV
         wcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=wxAE+rmvrsDq27Iqeo6nEv/48a4RUlHGSm7qdXtegOw=;
        b=tS1P9AFKY6kFApHdhoQVBE7L4ahgjPz+P+jWTjV2rH+sBUlDlm+8x6vkREvLo2UPTb
         MCva3xpjVHa6ZzttQ2pYjCQExKGmcWU/wqYr5LDcMN1xe2OlcDGMFaA4PX872PIsUJTD
         dPh9AIV+bmfNfGCDkC0Hhzlzlo8hmTX2yvix4DrrqI1FYhHZn0mAzGdYyCn+S835F35w
         VrE3UNbTmKqawDIKC67BC7CchuBjCN7C98praSCfgoiixgI6nkNIu0CF6q3Y0AXZnmDd
         CJsWHDqtHnb3JOQ/bVFrqLG7PN1YF1SlX82LXlg/RwxavYM1U2c/LNvOdV0I1pRzCJjf
         W6Jg==
X-Gm-Message-State: APjAAAX9HVGtSJBGKzTekqsmi+6KD45sMBTsSHaeFakQp5XgkOiKizQV
        o3Pw+8YnHoJHtUjp8mgzFXshWVfPbWw=
X-Google-Smtp-Source: APXvYqwxNN2iCPg7v5ok/gV29ASxuj2urpqlce/yebuWXUT28AiUgavY1YOz82pb/64V0SWdvoCNeA==
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr6804519wrs.395.1580407321318;
        Thu, 30 Jan 2020 10:02:01 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w19sm6956878wmc.22.2020.01.30.10.02.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:02:00 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
Subject: [FYI PATCH 1/5] x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
Date:   Thu, 30 Jan 2020 19:01:52 +0100
Message-Id: <1580407316-11391-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
References: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

kvm_steal_time_set_preempted() may accidentally clear KVM_VCPU_FLUSH_TLB
bit if it is called more than once while VCPU is preempted.

This is part of CVE-2019-3016.

(This bug was also independently discovered by Jim Mattson
<jmattson@google.com>)

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf91713..8c93691 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
+	if (vcpu->arch.st.steal.preempted)
+		return;
+
 	vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
-- 
1.8.3.1

