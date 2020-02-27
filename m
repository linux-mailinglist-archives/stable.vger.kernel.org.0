Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BA9171A2D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbgB0Nvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:51:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731162AbgB0Nva (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:51:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42EC220578;
        Thu, 27 Feb 2020 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811489;
        bh=gYdai52U37RmyPM0NQABvNslU8zWV5vhBd978yIcdmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWRiJVZM0Vr9ActhuC0rhLYnEKdcuMEeMPs0HZcsXKAbjmmEG3TIQRLu3RQZlUrMk
         Gor+IaWXMhZ3b8Z6sqYor7CZphW1HgWxFuEVcDErR4c+cKmN+j0q5IDnwB9Gob2lSC
         0mcWH6BTrqPK1HDQQLrmdSICjoTYZMx5cmEFZsNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 152/165] KVM: apic: avoid calculating pending eoi from an uninitialized val
Date:   Thu, 27 Feb 2020 14:37:06 +0100
Message-Id: <20200227132252.910073462@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 23520b2def95205f132e167cf5b25c609975e959 upstream.

When pv_eoi_get_user() fails, 'val' may remain uninitialized and the return
value of pv_eoi_get_pending() becomes random. Fix the issue by initializing
the variable.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -532,9 +532,11 @@ static inline bool pv_eoi_enabled(struct
 static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
 {
 	u8 val;
-	if (pv_eoi_get_user(vcpu, &val) < 0)
+	if (pv_eoi_get_user(vcpu, &val) < 0) {
 		apic_debug("Can't read EOI MSR value: 0x%llx\n",
 			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
+		return false;
+	}
 	return val & 0x1;
 }
 


