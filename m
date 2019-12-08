Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B521161D9
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfLHNz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:55:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60552 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbfLHNyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1H-0007i1-0a; Sun, 08 Dec 2019 13:54:43 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1F-0002PP-7T; Sun, 08 Dec 2019 13:54:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        syzbot+e3f4897236c4eeb8af4f@syzkaller.appspotmail.com
Date:   Sun, 08 Dec 2019 13:53:46 +0000
Message-ID: <lsq.1575813165.35435092@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 62/72] KVM: x86: fix out-of-bounds write in
 KVM_GET_EMULATED_CPUID (CVE-2019-19332)
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 433f4ba1904100da65a311033f17a9bf586b287e upstream.

The bounds check was present in KVM_GET_SUPPORTED_CPUID but not
KVM_GET_EMULATED_CPUID.

Reported-by: syzbot+e3f4897236c4eeb8af4f@syzkaller.appspotmail.com
Fixes: 84cffe499b94 ("kvm: Emulate MOVBE", 2013-10-29)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/cpuid.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -327,7 +327,7 @@ static inline int __do_cpuid_ent(struct
 
 	r = -E2BIG;
 
-	if (*nent >= maxnent)
+	if (WARN_ON(*nent >= maxnent))
 		goto out;
 
 	do_cpuid_1_ent(entry, function, index);
@@ -599,6 +599,9 @@ out:
 static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 func,
 			u32 idx, int *nent, int maxnent, unsigned int type)
 {
+	if (*nent >= maxnent)
+		return -E2BIG;
+
 	if (type == KVM_GET_EMULATED_CPUID)
 		return __do_cpuid_ent_emulated(entry, func, idx, nent, maxnent);
 

