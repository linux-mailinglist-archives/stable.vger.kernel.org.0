Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B03917FFA4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJN6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:58:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39517 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbgCJN6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 09:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583848686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=gnhQmTAqEc+aNjZCijFVs1ugGLdqmBHMWeVgZresAf8=;
        b=PH+NFqIgIbBFVu0Bq9OlCNxiEbIL9aH9kR4CUnMDsGlwUKW49jeFyc2YaraXtqlL9J98ge
        RgOPmCmphsF8xnbAaQ0GF8jYfKXTor2EhYBgWdLlDIfTKq9aQffOv69w5XEx76k1hb/kv4
        AJFbVdnDk4suGOs7HQdmUYuaRR9oO00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-7s1RjQaHMf-NenxnNaJTLA-1; Tue, 10 Mar 2020 09:58:03 -0400
X-MC-Unique: 7s1RjQaHMf-NenxnNaJTLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D13C28010E3;
        Tue, 10 Mar 2020 13:58:02 +0000 (UTC)
Received: from jmaloy.com (ovpn-125-109.rdu2.redhat.com [10.10.125.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 213818C090;
        Tue, 10 Mar 2020 13:58:02 +0000 (UTC)
From:   Jon Maloy <jmaloy@redhat.com>
To:     jmaloy@redhat.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        Oliver Upton <oupton@google.com>
Subject: [RHEL 8.2 virt PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest mode
Date:   Tue, 10 Mar 2020 09:57:41 -0400
Message-Id: <20200310135743.27633-2-jmaloy@redhat.com>
In-Reply-To: <20200310135743.27633-1-jmaloy@redhat.com>
References: <20200310135743.27633-1-jmaloy@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

