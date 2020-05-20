Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE021DB65C
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgETOYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33180 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00036u-H8; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-007DVe-9h; Wed, 20 May 2020 15:22:21 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Andrew Honig" <ahonig@google.com>
Date:   Wed, 20 May 2020 15:14:52 +0100
Message-ID: <lsq.1589984009.983393284@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 84/99] KVM: Check for a bad hva before dropping into
 the ghc slow path
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit fcfbc617547fc6d9552cb6c1c563b6a90ee98085 upstream.

When reading/writing using the guest/host cache, check for a bad hva
before checking for a NULL memslot, which triggers the slow path for
handing cross-page accesses.  Because the memslot is nullified on error
by __kvm_gfn_to_hva_cache_init(), if the bad hva is encountered after
crossing into a new page, then the kvm_{read,write}_guest() slow path
could potentially write/access the first chunk prior to detecting the
bad hva.

Arguably, performing a partial access is semantically correct from an
architectural perspective, but that behavior is certainly not intended.
In the original implementation, memslot was not explicitly nullified
and therefore the partial access behavior varied based on whether the
memslot itself was null, or if the hva was simply bad.  The current
behavior was introduced as a seemingly unintentional side effect in
commit f1b9dd5eb86c ("kvm: Disallow wraparound in
kvm_gfn_to_hva_cache_init"), which justified the change with "since some
callers don't check the return code from this function, it sit seems
prudent to clear ghc->memslot in the event of an error".

Regardless of intent, the partial access is dependent on _not_ checking
the result of the cache initialization, which is arguably a bug in its
own right, at best simply weird.

Fixes: 8f964525a121 ("KVM: Allow cross page reads and writes from cached translations.")
Cc: Jim Mattson <jmattson@google.com>
Cc: Andrew Honig <ahonig@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1596,12 +1596,12 @@ int kvm_write_guest_cached(struct kvm *k
 	if (slots->generation != ghc->generation)
 		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
 
-	if (unlikely(!ghc->memslot))
-		return kvm_write_guest(kvm, ghc->gpa, data, len);
-
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
 
+	if (unlikely(!ghc->memslot))
+		return kvm_write_guest(kvm, ghc->gpa, data, len);
+
 	r = __copy_to_user((void __user *)ghc->hva, data, len);
 	if (r)
 		return -EFAULT;
@@ -1622,12 +1622,12 @@ int kvm_read_guest_cached(struct kvm *kv
 	if (slots->generation != ghc->generation)
 		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
 
-	if (unlikely(!ghc->memslot))
-		return kvm_read_guest(kvm, ghc->gpa, data, len);
-
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
 
+	if (unlikely(!ghc->memslot))
+		return kvm_read_guest(kvm, ghc->gpa, data, len);
+
 	r = __copy_from_user(data, (void __user *)ghc->hva, len);
 	if (r)
 		return -EFAULT;

