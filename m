Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8AA39722A
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 13:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhFALOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 07:14:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6113 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbhFALOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 07:14:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvTw90gBQzYmrR;
        Tue,  1 Jun 2021 19:10:17 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 19:13:00 +0800
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 19:13:00 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <maz@kernel.org>, <alexandru.elisei@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: [PATCH stable-5.12.y backport 2/2] KVM: arm64: Resolve all pending PC updates before immediate exit
Date:   Tue, 1 Jun 2021 19:12:38 +0800
Message-ID: <20210601111238.1059-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20210601111238.1059-1-yuzenghui@huawei.com>
References: <20210601111238.1059-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e3e880bb1518eb10a4b4bb4344ed614d6856f190 upstream.

Commit 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before
returning to userspace") fixed the PC updating issue by forcing an explicit
synchronisation of the exception state on vcpu exit to userspace.

However, we forgot to take into account the case where immediate_exit is
set by userspace and KVM_RUN will exit immediately. Fix it by resolving all
pending PC updates before returning to userspace.

Since __kvm_adjust_pc() relies on a loaded vcpu context, I moved the
immediate_exit checking right after vcpu_load(). We will get some overhead
if immediate_exit is true (which should hopefully be rare).

Fixes: 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before returning to userspace")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210526141831.1662-1-yuzenghui@huawei.com
Cc: stable@vger.kernel.org # 5.11
---
 arch/arm64/kvm/arm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c18740a1e541..7730b81aad6d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -715,11 +715,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	if (run->immediate_exit)
-		return -EINTR;
-
 	vcpu_load(vcpu);
 
+	if (run->immediate_exit) {
+		ret = -EINTR;
+		goto out;
+	}
+
 	kvm_sigset_activate(vcpu);
 
 	ret = 1;
@@ -892,6 +894,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
+out:
 	/*
 	 * In the unlikely event that we are returning to userspace
 	 * with pending exceptions or PC adjustment, commit these
-- 
2.19.1

