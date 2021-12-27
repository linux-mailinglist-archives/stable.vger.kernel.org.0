Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA5748001B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbhL0PnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239126AbhL0PlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8CCC061785;
        Mon, 27 Dec 2021 07:40:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08DB7CE10CB;
        Mon, 27 Dec 2021 15:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E980AC36AEA;
        Mon, 27 Dec 2021 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619636;
        bh=4AgBbM/0dkgR4prNEKqldJxEif3d+cyMJkraSgItTek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cg4HXTD6ZNi+5pR/mH+YODRC1Mn5nYu6y5RTIgfnN0rJr7iTaWPWleUJk8T9W04uD
         LGF9c985uvDJaaMdZwY9HbNB8FBt/8x9vjCf6vFiQoTTbjdB24mge+9TBF+RBr1O2N
         1RrhN9IjjQOCWi65PJaW/2YZLmF3W/Q/oyotujmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 006/128] selftests: KVM: Fix non-x86 compiling
Date:   Mon, 27 Dec 2021 16:29:41 +0100
Message-Id: <20211227151331.716702569@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

commit 577e022b7b41854911dcfb03678d8d2b930e8a3f upstream.

Attempting to compile on a non-x86 architecture fails with

include/kvm_util.h: In function â€˜vm_compute_max_gfnâ€™:
include/kvm_util.h:79:21: error: dereferencing pointer to incomplete type â€˜struct kvm_vmâ€™
  return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
                     ^~

This is because the declaration of struct kvm_vm is in
lib/kvm_util_internal.h as an effort to make it private to
the test lib code. We can still provide arch specific functions,
though, by making the generic function symbols weak. Do that to
fix the compile error.

Fixes: c8cc43c1eae2 ("selftests: KVM: avoid failures due to reserved HyperTransport region")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Jones <drjones@redhat.com>
Message-Id: <20211214151842.848314-1-drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h |   10 +---------
 tools/testing/selftests/kvm/lib/kvm_util.c     |    5 +++++
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -69,15 +69,6 @@ enum vm_guest_mode {
 
 #endif
 
-#if defined(__x86_64__)
-unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
-#else
-static inline unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
-{
-	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
-}
-#endif
-
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
 #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
 
@@ -318,6 +309,7 @@ bool vm_is_unrestricted_guest(struct kvm
 
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
+unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 uint64_t vm_get_max_gfn(struct kvm_vm *vm);
 int vm_get_fd(struct kvm_vm *vm);
 
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2282,6 +2282,11 @@ unsigned int vm_get_page_shift(struct kv
 	return vm->page_shift;
 }
 
+unsigned long __attribute__((weak)) vm_compute_max_gfn(struct kvm_vm *vm)
+{
+	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
+}
+
 uint64_t vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;


