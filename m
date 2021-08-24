Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698EC3F6678
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbhHXRYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240468AbhHXRV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A44261AEE;
        Tue, 24 Aug 2021 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824613;
        bh=7ZCbB3rASuiNB/XTXga+uvpULdbDwNN9G8lPhSb0r9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+fYBQqWD3Z1XrlHFO0+C+zIX+SDJbZ5ZeMjHchqzhm6vfSRV0my2f3GlYA/3YvIL
         +h+esphSZQukyOiwixatoFBtRvOP1bXemTzBxRJRfxJC3q7WxpY/HBAky6ZhvXM5sI
         BSqfbDL0ZjT8f9YwCT4eul0ZUhLQUd2vfAxUxXeFc0A/9hMfHUGNH3j7jv7NKbulqr
         9i0jA74wh1PQ8BsK8uxGWwfZ31pKAP+U8EMhIN7JsEBQJt6OPG7GWV+9iF54B7KebA
         pFQY7VzJ1SxSHKTChvYsq84csDxel2vl0WclhoF3oHOrCPQt0KMN0mu5vU8WSpxODo
         IQLTf9howIcrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 42/84] KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
Date:   Tue, 24 Aug 2021 13:02:08 -0400
Message-Id: <20210824170250.710392-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ upstream commit c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc ]

If L1 disables VMLOAD/VMSAVE intercepts, and doesn't enable
Virtual VMLOAD/VMSAVE (currently not supported for the nested hypervisor),
then VMLOAD/VMSAVE must operate on the L1 physical memory, which is only
possible by making L0 intercept these instructions.

Failure to do so allowed the nested guest to run VMLOAD/VMSAVE unintercepted,
and thus read/write portions of the host physical memory.

Fixes: 89c8a4984fc9 ("KVM: SVM: Enable Virtual VMLOAD VMSAVE feature")

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 72d729f34437..9673ddb3d7a0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -513,6 +513,9 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_dr = h->intercept_dr | g->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
 	c->intercept = h->intercept | g->intercept;
+
+	c->intercept |= (1ULL << INTERCEPT_VMLOAD);
+	c->intercept |= (1ULL << INTERCEPT_VMSAVE);
 }
 
 static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
-- 
2.30.2

