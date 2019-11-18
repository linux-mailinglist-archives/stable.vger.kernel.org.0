Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A069100B58
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 19:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfKRSR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 13:17:57 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42040 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRSRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 13:17:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so20684436wrf.9;
        Mon, 18 Nov 2019 10:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kG2FZYKkJlrx1H8gAFUJ6ynBgNplxVBjCy1R1O8SXuw=;
        b=GicilK5U6a0LrOwLTLOadikMR5QhCvFRQvprLaWfbGWxKMJFNHdUc8uGyNmWLx5j39
         41+LlKhNOFytOyl/9IB6AsaVupOqwHwa3zUebZG/yTb1UKbGHNIciRlRNI9oPeLmM6u7
         tzVLFcY8a9tz5X52sUOpPFZXQudiR6zs3gnuqRzZyxuCojhxKI4ctjpDjbs0N5sPtUoY
         zbtZYuT7KiXEH/oCgZRTcIym6NQ1B6FEUs/a7mJXWqqg/KB5hIJbqKdOQ9XKRMwDbc1X
         IgDECDnxvgBOENh1FOY3lsrEk0pcM061B5rb7h2NPUA2RhVhVF7ufPFiGz0AL9VoIMBF
         qsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=kG2FZYKkJlrx1H8gAFUJ6ynBgNplxVBjCy1R1O8SXuw=;
        b=Q9XK7V2op2rtss59eT/SMfFTHq+Ie0mapjce2tAM/N1TgZQYp987ua1d+2QIVBoV/k
         /9Vdf/tieQVXvpBtE5ksGSOtcZSmskWVDESELVn3vNFEYQq7vZsEv8eR1wtfVFg+U3yt
         B2PLNyoznGq/AL1UbTcpjlZ2X5Ge3G2u7jSDpRmRwvw53bPscq1DzDOVBFFdjCQTUIVF
         eL6bXCfA9tAlOUZlx8Vp/DCIq55LbEZmj1kREyIlJMiPV274Ej1iQpnrhMjrZlLZigG2
         luTZEBKnrotRa/ha3rTL84mA6BdB/hewSPZFCBzeunZiA/pt8wBtGoclb8uVkFKjhpc+
         8ZNg==
X-Gm-Message-State: APjAAAWaSHNSWWGZTNyoK+SG6xDbMo+go6TmwmbEKGD1lmsP9T6IzCJf
        diRRSgrFtc0dPvdP2A7YzjITg8Wp
X-Google-Smtp-Source: APXvYqwT+qWZ9yO+HV/xrSWPLR4nO90jFgOKP70liBqNu2KbAaCxLK4sQN1rmnoUXcBXjySAnQha3w==
X-Received: by 2002:adf:de0a:: with SMTP id b10mr32559584wrm.268.1574101073394;
        Mon, 18 Nov 2019 10:17:53 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v81sm233794wmg.4.2019.11.18.10.17.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 10:17:52 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/5] KVM: x86: do not modify masked bits of shared MSRs
Date:   Mon, 18 Nov 2019 19:17:44 +0100
Message-Id: <1574101067-5638-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Shared MSRs" are guest MSRs that are written to the host MSRs but
keep their value until the next return to userspace.  They support
a mask, so that some bits keep the host value, but this mask is
only used to skip an unnecessary MSR write and the value written
to the MSR is always the guest MSR.

Fix this and, while at it, do not update smsr->values[slot].curr if
for whatever reason the wrmsr fails.  This should only happen due to
reserved bits, so the value written to smsr->values[slot].curr
will not match when the user-return notifier and the host value will
always be restored.  However, it is untidy and in rare cases this
can actually avoid spurious WRMSRs on return to userspace.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ea735d632e9..02863998af91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -300,13 +300,14 @@ int kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
 	struct kvm_shared_msrs *smsr = per_cpu_ptr(shared_msrs, cpu);
 	int err;
 
-	if (((value ^ smsr->values[slot].curr) & mask) == 0)
+	value = (value & mask) | (smsr->values[slot].host & ~mask);
+	if (value == smsr->values[slot].curr)
 		return 0;
-	smsr->values[slot].curr = value;
 	err = wrmsrl_safe(shared_msrs_global.msrs[slot], value);
 	if (err)
 		return 1;
 
+	smsr->values[slot].curr = value;
 	if (!smsr->registered) {
 		smsr->urn.on_user_return = kvm_on_user_return;
 		user_return_notifier_register(&smsr->urn);
-- 
1.8.3.1


