Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D700520637
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfEPLsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbfEPLjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:39:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCB5720833;
        Thu, 16 May 2019 11:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006794;
        bh=0te2/MatERJ1D9RAWwRpgHkRIsAxhubHijqTPPdWFPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCeWWz6x4tX2vvvDAwjjXQpMKee6aGf8pVyVGz1P4BJoIpZfm85km713YJopl2IZ4
         Z5XN9X8kVUziujj3qVzGxA8Ji7UIJ9wZnAWCToIXsWvvLRdHOFCnjrcUDEj59tjUGS
         ouf8FiUmuUJG8+uVT+FAwGA0BvHXKzhiKzGhPMbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 17/34] x86: kvm: hyper-v: deal with buggy TLB flush requests from WS2012
Date:   Thu, 16 May 2019 07:39:14 -0400
Message-Id: <20190516113932.8348-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit da66761c2d93a46270d69001abb5692717495a68 ]

It was reported that with some special Multi Processor Group configuration,
e.g:
 bcdedit.exe /set groupsize 1
 bcdedit.exe /set maxgroup on
 bcdedit.exe /set groupaware on
for a 16-vCPU guest WS2012 shows BSOD on boot when PV TLB flush mechanism
is in use.

Tracing kvm_hv_flush_tlb immediately reveals the issue:

 kvm_hv_flush_tlb: processor_mask 0x0 address_space 0x0 flags 0x2

The only flag set in this request is HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES,
however, processor_mask is 0x0 and no HV_FLUSH_ALL_PROCESSORS is specified.
We don't flush anything and apparently it's not what Windows expects.

TLFS doesn't say anything about such requests and newer Windows versions
seem to be unaffected. This all feels like a WS2012 bug, which is, however,
easy to workaround in KVM: let's flush everything when we see an empty
flush request, over-flushing doesn't hurt.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 371c669696d70..610c0f1fbdd71 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1371,7 +1371,16 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
 
 		valid_bank_mask = BIT_ULL(0);
 		sparse_banks[0] = flush.processor_mask;
-		all_cpus = flush.flags & HV_FLUSH_ALL_PROCESSORS;
+
+		/*
+		 * Work around possible WS2012 bug: it sends hypercalls
+		 * with processor_mask = 0x0 and HV_FLUSH_ALL_PROCESSORS clear,
+		 * while also expecting us to flush something and crashing if
+		 * we don't. Let's treat processor_mask == 0 same as
+		 * HV_FLUSH_ALL_PROCESSORS.
+		 */
+		all_cpus = (flush.flags & HV_FLUSH_ALL_PROCESSORS) ||
+			flush.processor_mask == 0;
 	} else {
 		if (unlikely(kvm_read_guest(kvm, ingpa, &flush_ex,
 					    sizeof(flush_ex))))
-- 
2.20.1

