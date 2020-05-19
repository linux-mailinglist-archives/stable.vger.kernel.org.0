Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082E51D9ED0
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgESSHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 14:07:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50170 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726059AbgESSHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 14:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589911667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=megtxqWXyglz/CqjKs2x/itHX3lBYfTYHJlMu70hZuI=;
        b=hpEnHFsZWae2flxOrgbMzvuAA5joLJ2OsqLpVung+PRaqwsiILYJEmHdV9tZyCnORLjmfi
        EIW1WVZIBOwmmcU62gEDmI1q9eYxHrIQXCUL2QbqAqq2eKfrD+QKAu1QkSwKjkbxpHFDIp
        JCZIBcIKvmih9VvXt6qHvHwc+m+1CXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-8zS8eI4HPqOnJYwKbtq5eQ-1; Tue, 19 May 2020 14:07:46 -0400
X-MC-Unique: 8zS8eI4HPqOnJYwKbtq5eQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECE9A107ACCA;
        Tue, 19 May 2020 18:07:44 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6367410016EB;
        Tue, 19 May 2020 18:07:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     oupton@google.com, stable@vger.kernel.org
Subject: [PATCH] KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
Date:   Tue, 19 May 2020 14:07:43 -0400
Message-Id: <20200519180743.89974-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The migration functionality was left incomplete in commit 5ef8acbdd687
("KVM: nVMX: Emulate MTF when performing instruction emulation", 2020-02-23),
fix it.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f55a44951c3..0001b2addc66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4626,7 +4626,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		if (kvm_state.flags &
 		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
-		      | KVM_STATE_NESTED_EVMCS))
+		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
 			break;
 
 		/* nested_run_pending implies guest_mode.  */
-- 
2.18.2

