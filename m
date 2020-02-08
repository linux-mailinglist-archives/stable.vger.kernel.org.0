Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E908156683
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBHSfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:35:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34190 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727878AbgBHS3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003fb-9E; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-000CTt-54; Sat, 08 Feb 2020 18:29:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jim Mattson" <jmattson@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date:   Sat, 08 Feb 2020 18:20:52 +0000
Message-ID: <lsq.1581185940.373083172@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 113/148] KVM: x86: do not modify masked bits of
 shared MSRs
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit de1fca5d6e0105c9d33924e1247e2f386efc3ece upstream.

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

Reviewed-by: Jim Mattson <jmattson@google.com>
Tested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -242,13 +242,14 @@ int kvm_set_shared_msr(unsigned slot, u6
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

