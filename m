Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F393452383
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354994AbhKPB0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243406AbhKOTCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B099963357;
        Mon, 15 Nov 2021 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000095;
        bh=zJy991Q6d5PUwah5OI4Kf82wnINpswc90gVR3xJV0Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MJoNx3INfeWd6pwkcwQ5f9NaUdt+M6Lp0k2da4L4WsAVQS4UITQaZCwJbeOjLilL
         asgysk7B3h3q/p3+7xIcFHvZqD2/m+OtGX08SgdRXkUIXStdnO8BwiW/r1NzKqbw1h
         H+DdVJRQOOTYje4ihX3gLUcQu5tX1bvMMTqc/eIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 503/849] KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm
Date:   Mon, 15 Nov 2021 17:59:46 +0100
Message-Id: <20211115165437.295720358@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 1e2aa46de526a5adafe580bca4c25856bb06f09e ]

When the system is heavily overcommitted, kvm_s390_pv_init_vm might
generate stall notifications.

Fix this by using uv_call_sched instead of just uv_call. This is ok because
we are not holding spinlocks.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210920132502.36111-4-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 0a854115100b4..00d272d134c24 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -195,7 +195,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
 	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
 
-	cc = uv_call(0, (u64)&uvcb);
+	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
-- 
2.33.0



