Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC2F17FFE4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCJOMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:12:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726761AbgCJOMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 10:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583849537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=gnhQmTAqEc+aNjZCijFVs1ugGLdqmBHMWeVgZresAf8=;
        b=fMRoqQsXbNzot9IBBKPV4J5VSQshYmkPfPUdCQJd+HDkmpYN23cSpu4MGXZJNTUhFurIe5
        o3BTKcWW+wSGd+Os6WS0M2PqovCff6MWqaMOVPF/NpUNApl09X5AbkakjZWRAKsIFH/dVZ
        ApdG42Y0+BgJpLvyEkn5Z07BFvcjp8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-DvafcLjBPFyDlNcLvcmI9Q-1; Tue, 10 Mar 2020 10:12:16 -0400
X-MC-Unique: DvafcLjBPFyDlNcLvcmI9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5268913F9;
        Tue, 10 Mar 2020 14:12:15 +0000 (UTC)
Received: from jmaloy.com (ovpn-125-109.rdu2.redhat.com [10.10.125.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5178160BEE;
        Tue, 10 Mar 2020 14:12:14 +0000 (UTC)
From:   Jon Maloy <jmaloy@redhat.com>
To:     jmaloy@redhat.com, rhkernel-list@redhat.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Paul Lai <plai@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org,
        Oliver Upton <oupton@google.com>
Subject: [RHEL 8.2 virt PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
Date:   Tue, 10 Mar 2020 10:11:50 -0400
Message-Id: <20200310141152.29029-2-jmaloy@redhat.com>
In-Reply-To: <20200310141152.29029-1-jmaloy@redhat.com>
References: <20200310141152.29029-1-jmaloy@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

vmx_check_intercept is not yet fully implemented. To avoid emulating
instructions disallowed by the L1 hypervisor, refuse to emulate
instructions by default.

Cc: stable@vger.kernel.org
[Made commit, added commit msg - Oliver]
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

(cherry picked from commit 07721feee46b4b248402133228235318199b05ec)
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f6f98f7895bf..5e9c77c818a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7199,7 +7199,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	}
 
 	/* TODO: check more intercepts... */
-	return X86EMUL_CONTINUE;
+	return X86EMUL_UNHANDLEABLE;
 }
 
 #ifdef CONFIG_X86_64
-- 
2.18.1

