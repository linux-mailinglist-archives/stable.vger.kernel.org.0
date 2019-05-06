Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4180814CB3
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfEFOnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbfEFOm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:42:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44D92053B;
        Mon,  6 May 2019 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153777;
        bh=dHv1sTr8OrIWKxnzeyKDgdjsfkIxGaEwHW++mE54M7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1i1b+NFGQj4wmwNnUDxX5kM1gkwntJuaYrtW5dEq05597HJvIuR2JGzegRCERKRCn
         aGQ42P0mEIBemgJBD/FRsfg7uuqyZdgSXdHHI3MBwALt7AV2HsU9yqco0G7GaJ1t58
         k+CW+TIZk8n49SeNR7poPJD/XJOuemOuMEGGza4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cfir Cohen <cfir@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 61/99] KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT overflow
Date:   Mon,  6 May 2019 16:32:34 +0200
Message-Id: <20190506143059.604447144@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b86bc2858b389255cd44555ce4b1e427b2b770c0 ]

This ensures that the address and length provided to DBG_DECRYPT and
DBG_ENCRYPT do not cause an overflow.

At the same time, pass the actual number of pages pinned in memory to
sev_unpin_memory() as a cleanup.

Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 813cb60eb401..8dd9208ae4de 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6789,7 +6789,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 	struct page **src_p, **dst_p;
 	struct kvm_sev_dbg debug;
 	unsigned long n;
-	int ret, size;
+	unsigned int size;
+	int ret;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
@@ -6797,6 +6798,11 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 	if (copy_from_user(&debug, (void __user *)(uintptr_t)argp->data, sizeof(debug)))
 		return -EFAULT;
 
+	if (!debug.len || debug.src_uaddr + debug.len < debug.src_uaddr)
+		return -EINVAL;
+	if (!debug.dst_uaddr)
+		return -EINVAL;
+
 	vaddr = debug.src_uaddr;
 	size = debug.len;
 	vaddr_end = vaddr + size;
@@ -6847,8 +6853,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 						     dst_vaddr,
 						     len, &argp->error);
 
-		sev_unpin_memory(kvm, src_p, 1);
-		sev_unpin_memory(kvm, dst_p, 1);
+		sev_unpin_memory(kvm, src_p, n);
+		sev_unpin_memory(kvm, dst_p, n);
 
 		if (ret)
 			goto err;
-- 
2.20.1



