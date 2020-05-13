Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59F61D0DDC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbgEMJ4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388426AbgEMJ42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:56:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F0202176D;
        Wed, 13 May 2020 09:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363788;
        bh=KIbshgR2Hr2P0QjIcLIWNF8IE/9xpGbzNGoIKxojQxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEZVpwgmKsipiE+PGtZ7OQB4LTUYSaHGK4xq/8OFo4aeoNVARjer1oa6CF9VDw9ME
         tjL8vlJk9zoCpLycUXqvwJoG3ly9ZPqQanlwjjeiSx84T8N9gvZctyhKdCeeINYvcX
         GqUrmm8MZkGhn9ULfs5W/3rQ+Hf7NcnCL+I+DJ/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 106/118] arch/x86/kvm/svm/sev.c: change flag passed to GUP fast in sev_pin_memory()
Date:   Wed, 13 May 2020 11:45:25 +0200
Message-Id: <20200513094427.166204184@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>

commit 996ed22c7a5251d76dcdfe5026ef8230e90066d9 upstream.

When trying to lock read-only pages, sev_pin_memory() fails because
FOLL_WRITE is used as the flag for get_user_pages_fast().

Commit 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a
write 'bool'") updated the get_user_pages_fast() call sites to use
flags, but incorrectly updated the call in sev_pin_memory().  As the
original coding of this call was correct, revert the change made by that
commit.

Fixes: 73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write 'bool'")
Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Link: http://lkml.kernel.org/r/20200423152419.87202-1-Janakarajan.Natarajan@amd.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1886,7 +1886,7 @@ static struct page **sev_pin_memory(stru
 		return NULL;
 
 	/* Pin the user virtual address. */
-	npinned = get_user_pages_fast(uaddr, npages, FOLL_WRITE, pages);
+	npinned = get_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		goto err;


