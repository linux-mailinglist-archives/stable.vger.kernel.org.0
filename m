Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438AF47AEF7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbhLTPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241188AbhLTPFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:05:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21011C08EAE5;
        Mon, 20 Dec 2021 06:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E7FB80EE2;
        Mon, 20 Dec 2021 14:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D253BC36AE9;
        Mon, 20 Dec 2021 14:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011966;
        bh=NHNsv+IvqipAutdz45tYJ2eyGvjjQd/vCVH+dR1o/6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIESl+p149RMYVzI/naUR/lfF89NsVCnVgBqMwB3Loo5cGNt+xVIKN4HCu9FJEs1c
         c6XLwPCoEn6zgYXZidHYT+g1MiO6VNkCFreybTxMUSL2t+T+0ViApD6bRQ0JyiTd7v
         VJ7EQY8JwXAhr5FTHm2DLCeE16dG6VZiivEP3WoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/177] x86/kvm: remove unused ack_notifier callbacks
Date:   Mon, 20 Dec 2021 15:32:35 +0100
Message-Id: <20211220143040.246944657@linuxfoundation.org>
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



