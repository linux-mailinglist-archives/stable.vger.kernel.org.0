Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86817816E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbgCCSCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgCCSCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA14120836;
        Tue,  3 Mar 2020 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258543;
        bh=0Q53lTt8WEN/YkJpYY+XsdCaId8103a3xFhEzMLRWdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4AgNQYzwVVp8WsIWXVQGQ1jiV3Dx7WYSZS2RfHyy+2of4c4EaKDzNo4Fn0AI9sK2
         v9EMM8V3Kdgj5gQp//YD0qb3XjwlHZJnor5JO62j0nppiV8MYETYJA9fJ0jPOZ7D/w
         u8Mgxh9RiGeCMA5GlveB6PWucQkO6keTu8NoJWWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Andrew Honig <ahonig@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 71/87] KVM: Check for a bad hva before dropping into the ghc slow path
Date:   Tue,  3 Mar 2020 18:44:02 +0100
Message-Id: <20200303174356.652072494@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2024,12 +2024,12 @@ int kvm_write_guest_offset_cached(struct
 	if (slots->generation != ghc->generation)
 		__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len);
 
-	if (unlikely(!ghc->memslot))
-		return kvm_write_guest(kvm, gpa, data, len);
-
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
 
+	if (unlikely(!ghc->memslot))
+		return kvm_write_guest(kvm, gpa, data, len);
+
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
@@ -2057,12 +2057,12 @@ int kvm_read_guest_cached(struct kvm *kv
 	if (slots->generation != ghc->generation)
 		__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len);
 
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


