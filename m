Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2E915A42
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbfEGFmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbfEGFmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:42:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D1E9205ED;
        Tue,  7 May 2019 05:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207755;
        bh=7wkk1vZ2abeMSIJJ70JqNDlLC5lgQx5sWi8Cvheh+sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmINgI8OLfPkHpaFsLTeI0dqZk6PRlJk3vOqWZRTYvqs17929fOMK1qLPLBZBNA+L
         8ol3DF5wRXmZPjTQsETFr/3ZjU7lW9Q9rK1P9gpguttEynU20wqM7RTYCk/xDnPEZ3
         fJZ0SSq4Xyv5crtZf/LzfG5tCDVY+yiJU4Vy7MVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/14] KVM: x86: avoid misreporting level-triggered irqs as edge-triggered in tracing
Date:   Tue,  7 May 2019 01:42:10 -0400
Message-Id: <20190507054218.340-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507054218.340-1-sashal@kernel.org>
References: <20190507054218.340-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 7a223e06b1a411cef6c4cd7a9b9a33c8d225b10e ]

In __apic_accept_irq() interface trig_mode is int and actually on some code
paths it is set above u8:

kvm_apic_set_irq() extracts it from 'struct kvm_lapic_irq' where trig_mode
is u16. This is done on purpose as e.g. kvm_set_msi_irq() sets it to
(1 << 15) & e->msi.data

kvm_apic_local_deliver sets it to reg & (1 << 15).

Fix the immediate issue by making 'tm' into u16. We may also want to adjust
__apic_accept_irq() interface and use proper sizes for vector, level,
trig_mode but this is not urgent.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ab9ae67a80e4..0ec94c6b4757 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -434,13 +434,13 @@ TRACE_EVENT(kvm_apic_ipi,
 );
 
 TRACE_EVENT(kvm_apic_accept_irq,
-	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec),
+	    TP_PROTO(__u32 apicid, __u16 dm, __u16 tm, __u8 vec),
 	    TP_ARGS(apicid, dm, tm, vec),
 
 	TP_STRUCT__entry(
 		__field(	__u32,		apicid		)
 		__field(	__u16,		dm		)
-		__field(	__u8,		tm		)
+		__field(	__u16,		tm		)
 		__field(	__u8,		vec		)
 	),
 
-- 
2.20.1

