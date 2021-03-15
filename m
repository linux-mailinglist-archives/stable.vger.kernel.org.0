Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B260F33BC46
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhCOOYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238154AbhCOOWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA64A64F39;
        Mon, 15 Mar 2021 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615818167;
        bh=jybnSoroDpQIksoHUrxyeI85+0ptC0keTTMH2Tab5to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAl/tuR01DiLcr55L8ZC4oL/b5hnLJAOV9PKCtM382gotr+iQ3ZuDvg6q1WAfqQ+0
         9oB271ttZXdQaFHfFrwEbThDnUNrBVHpU+UbOZWWI33t16C/soJwOhqSUmKeSVaYLB
         dJMKKBK426WTMzykavqMgJ+qdtg4P8nifVZciMas=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Zhang <Howard.Zhang@arm.com>,
        Will Deacon <will@kernel.org>, Jia He <justin.he@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 278/290] KVM: arm64: Fix range alignment when walking page tables
Date:   Mon, 15 Mar 2021 15:22:28 +0100
Message-Id: <20210315135551.421409997@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135551.391322899@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135551.391322899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jia He <justin.he@arm.com>

commit 357ad203d45c0f9d76a8feadbd5a1c5d460c638b upstream.

When walking the page tables at a given level, and if the start
address for the range isn't aligned for that level, we propagate
the misalignment on each iteration at that level.

This results in the walker ignoring a number of entries (depending
on the original misalignment) on each subsequent iteration.

Properly aligning the address before the next iteration addresses
this issue.

Cc: stable@vger.kernel.org
Reported-by: Howard Zhang <Howard.Zhang@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Jia He <justin.he@arm.com>
Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
[maz: rewrite commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210303024225.2591-1-justin.he@arm.com
Message-Id: <20210305185254.3730990-9-maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -225,6 +225,7 @@ static inline int __kvm_pgtable_visit(st
 		goto out;
 
 	if (!table) {
+		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
 		goto out;
 	}


