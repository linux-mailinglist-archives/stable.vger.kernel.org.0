Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6F3AEE53
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhFUQ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhFUQ0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:26:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D38C761164;
        Mon, 21 Jun 2021 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292540;
        bh=hiPF+RosvCLDuD/Y/PuMlF+/+Zt7YBkW3724fIap3sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k90br6+Gk3ROt8hUfxZnL4kEwaLMvxqmEX8xSqkNgFnazNKsYOIqmbc2VgPAM6GzN
         s4fdcjrpDBlCRDNdrrihcSkGSkVhttCo3pI7eMMhnfGvlRHTlspF6VytHHC20me+XG
         rN08I5ulY/JmzvSCZh5B9VcM4jGbCY7r+Im6+Z7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/146] kvm: LAPIC: Restore guard to prevent illegal APIC register access
Date:   Mon, 21 Jun 2021 18:14:00 +0200
Message-Id: <20210621154911.603988175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 218bf772bddd221489c38dde6ef8e917131161f6 ]

Per the SDM, "any access that touches bytes 4 through 15 of an APIC
register may cause undefined behavior and must not be executed."
Worse, such an access in kvm_lapic_reg_read can result in a leak of
kernel stack contents. Prior to commit 01402cf81051 ("kvm: LAPIC:
write down valid APIC registers"), such an access was explicitly
disallowed. Restore the guard that was removed in that commit.

Fixes: 01402cf81051 ("kvm: LAPIC: write down valid APIC registers")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Message-Id: <20210602205224.3189316-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5759eb075d2f..677d21082454 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1405,6 +1405,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
 
+	if (alignment + len > 4)
+		return 1;
+
 	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
 		return 1;
 
-- 
2.30.2



