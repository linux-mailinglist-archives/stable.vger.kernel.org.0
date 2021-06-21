Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47593AED93
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFUQVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhFUQU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6960B6128A;
        Mon, 21 Jun 2021 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292293;
        bh=QCo9LUr1jp2cGyDlX+ktQS2q+vgJ6CS/qTUdVpASKTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qtc8RBIa7p8sjpRgBIziCEz2dtkA5Ei+wRzahP35DGb/uZtg4Uet7Sn7Yzc5GvNPm
         b4MCR5SLM2a5qKZFuBoaRRO+/bRbs72V0j2vlgcSESGKPhQ/86P+c+2QyEwkiZIbMP
         mSnPmSabqPKwyFdLJyyUPaRPWRxU1utBXtWZ0ua0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/90] kvm: LAPIC: Restore guard to prevent illegal APIC register access
Date:   Mon, 21 Jun 2021 18:14:41 +0200
Message-Id: <20210621154904.367716440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
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
index 3f6b866c644d..eea2d6f10f59 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1332,6 +1332,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
 
+	if (alignment + len > 4)
+		return 1;
+
 	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
 		return 1;
 
-- 
2.30.2



