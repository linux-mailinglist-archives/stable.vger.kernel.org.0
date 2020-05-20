Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8591DBB21
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgETRVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:21:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40946 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726881AbgETRVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 13:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=WrBR4w78uBBs4VQ3VrdJAzQ/9ZZhP1UKmnG9BOpHw14=;
        b=H4GEgyJd3w2q0KzQkgvps93B28szy69FPpqtFjw5IUCPUdaTcs1dJPXdHjRKQ6EHAJE8lS
        +9vYo0OlzXZgOkonsUX1cMZQU3TGrgDMChOoV8Mc028Z8CX8OXmAxT59QX15KxSv/n/zr+
        M/p5BEMRlaMy5X9C2pZh8do6P6WUU+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-Z5e_C_Z6Obud2Kubqpe_6Q-1; Wed, 20 May 2020 13:21:48 -0400
X-MC-Unique: Z5e_C_Z6Obud2Kubqpe_6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80443A0BE6;
        Wed, 20 May 2020 17:21:47 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0434E60610;
        Wed, 20 May 2020 17:21:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH 01/24] KVM: nSVM: fix condition for filtering async PF
Date:   Wed, 20 May 2020 13:21:22 -0400
Message-Id: <20200520172145.23284-2-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Async page faults have to be trapped in the host (L1 in this case),
since the APF reason was passed from L0 to L1 and stored in the L1 APF
data page.  This was completely reversed: the page faults were passed
to the guest, a L2 hypervisor.

Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a89a166d1cb8..f4cd2d0cc360 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -880,8 +880,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 			return NESTED_EXIT_HOST;
 		break;
 	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
-		/* When we're shadowing, trap PFs, but not async PF */
-		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_reason == 0)
+		/* Trap async PF even if not shadowing */
+		if (!npt_enabled || svm->vcpu.arch.apf.host_apf_reason)
 			return NESTED_EXIT_HOST;
 		break;
 	default:
-- 
2.18.2


