Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8002F1625
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbhAKNtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbhAKNKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FD122ADF;
        Mon, 11 Jan 2021 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370561;
        bh=IA7TGggmcx72d5tLxSAIGgYIs0Fwt8X87wfoKNTEucM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWLwjUP2l5KPNOmVNoCjWLXF7C5z6mwEaZiq1VD8v03hpKdBA69rgjWhfQbj8EY5S
         TqWiZDyFJaIFk2STv9ZCn7PtLdd+gjAcdmxzhjYntzPj3+o1oNUGvIYtHY80d4Huvq
         BpA672Z7kmUfh8kaVKfTZQlBhT0mm2YFhMpoinhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 77/77] KVM: x86: fix shift out of bounds reported by UBSAN
Date:   Mon, 11 Jan 2021 14:02:26 +0100
Message-Id: <20210111130040.114612273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 2f80d502d627f30257ba7e3655e71c373b7d1a5a upstream.

Since we know that e >= s, we can reassociate the left shift,
changing the shifted number from 1 to 2 in exchange for
decreasing the right hand side by 1.

Reported-by: syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -53,7 +53,7 @@ static inline u64 rsvd_bits(int s, int e
 	if (e < s)
 		return 0;
 
-	return ((1ULL << (e - s + 1)) - 1) << s;
+	return ((2ULL << (e - s)) - 1) << s;
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value);


