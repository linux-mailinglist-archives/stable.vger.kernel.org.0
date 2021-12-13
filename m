Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D41472EDC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhLMOUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbhLMOUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4688FC061574;
        Mon, 13 Dec 2021 06:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13988B8106C;
        Mon, 13 Dec 2021 14:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62E3C34602;
        Mon, 13 Dec 2021 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405217;
        bh=NHNsv+IvqipAutdz45tYJ2eyGvjjQd/vCVH+dR1o/6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6ypXCzh8lD0vPqoizeeFpFygytH59zCddynyRD2q0z1QznEYDEondiOFuF1StNCi
         bwR0qFdXeiXEfYcYDG6xTIJCY1Vy1N1+ocAlpKJ5zg+iG5py2ly6dBrnVOljgPbG6X
         BqXmCop9HrsaloA1cMPk1lczLysxP/qPkd4sDyEZ8cZg+qCZKdJvqUVV7IGrsKPX4d
         KCN+lnSFfbDh9GwRNFRQHgskd89GE6uIZPjykoSUrw7CnXIXGfra8MQfM5uvphjt0x
         L5tnyzWJCLq4DAwfyrgVxUVEZhgYiFUDoGO/XNPo/7aY4uLYv2CqCcBdRVyikqYqGP
         k6JKQza/kEC8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 9/9] x86/kvm: remove unused ack_notifier callbacks
Date:   Mon, 13 Dec 2021 09:19:42 -0500
Message-Id: <20211213141944.352249-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213141944.352249-1-sashal@kernel.org>
References: <20211213141944.352249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 9dba4d24cbb5524dd39ab1e08886373b17f07ff2 ]

Commit f52447261bc8c2 ("KVM: irq ack notification") introduced an
ack_notifier() callback in struct kvm_pic and in struct kvm_ioapic
without using them anywhere. Remove those callbacks again.

Signed-off-by: Juergen Gross <jgross@suse.com>
Message-Id: <20211117071617.19504-1-jgross@suse.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/ioapic.h | 1 -
 arch/x86/kvm/irq.h    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 27e61ff3ac3e8..f1b2b2a6ff4db 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -81,7 +81,6 @@ struct kvm_ioapic {
 	unsigned long irq_states[IOAPIC_NUM_PINS];
 	struct kvm_io_device dev;
 	struct kvm *kvm;
-	void (*ack_notifier)(void *opaque, int irq);
 	spinlock_t lock;
 	struct rtc_status rtc_status;
 	struct delayed_work eoi_inject;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 650642b18d151..c2d7cfe82d004 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -56,7 +56,6 @@ struct kvm_pic {
 	struct kvm_io_device dev_master;
 	struct kvm_io_device dev_slave;
 	struct kvm_io_device dev_elcr;
-	void (*ack_notifier)(void *opaque, int irq);
 	unsigned long irq_states[PIC_NUM_PINS];
 };
 
-- 
2.33.0

