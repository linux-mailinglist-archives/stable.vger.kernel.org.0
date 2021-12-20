Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC98747AEF8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbhLTPHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbhLTPFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2766C08EAE6;
        Mon, 20 Dec 2021 06:52:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AE1BB80EE2;
        Mon, 20 Dec 2021 14:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43C1C36AE7;
        Mon, 20 Dec 2021 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011969;
        bh=/e1/8L6SPgUqiP2xGp6++0q396mEYNwghRExm8AVqno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/0MNTvTCkK81zj35BHdQcIVwPDlBjGdgxqdLOBTX1zy65IthndsVzaRSskBZ4JNf
         vF/10iqYTOXd9+aO/9NWQn4+hXr6F3ubAqcaRQAPZPJviVruC1KckUc5GDFQC7/Pyz
         8aXmOgB1bX4b/OgQh6oC7dVJbBnnTEGB07zo6H+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/177] KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()
Date:   Mon, 20 Dec 2021 15:32:36 +0100
Message-Id: <20211220143040.290107332@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit e45e9e3998f0001079b09555db5bb3b4257f6746 ]

The KVM doesn't know whether any TLB for a specific pcid is cached in
the CPU when tdp is enabled.  So it is better to flush all the guest
TLB when invalidating any single PCID context.

The case is very rare or even impossible since KVM generally doesn't
intercept CR3 write or INVPCID instructions when tdp is enabled, so the
fix is mostly for the sake of overall robustness.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211019110154.4091-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eff065ce6f8e8..3c9e2d236830c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1091,6 +1091,18 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	unsigned long roots_to_free = 0;
 	int i;
 
+	/*
+	 * MOV CR3 and INVPCID are usually not intercepted when using TDP, but
+	 * this is reachable when running EPT=1 and unrestricted_guest=0,  and
+	 * also via the emulator.  KVM's TDP page tables are not in the scope of
+	 * the invalidation, but the guest's TLB entries need to be flushed as
+	 * the CPU may have cached entries in its TLB for the target PCID.
+	 */
+	if (unlikely(tdp_enabled)) {
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
+	}
+
 	/*
 	 * If neither the current CR3 nor any of the prev_roots use the given
 	 * PCID, then nothing needs to be done here because a resync will
-- 
2.33.0



