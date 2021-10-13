Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1124742C6EA
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbhJMQ6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237749AbhJMQ60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634144182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ji0DHYIVmqHsZ82Hlbwv2n1NxsEijCsgkA6TxAA1N8=;
        b=g/witjk7pKO5fJlJ8XCzQvewQo0tA0OfqS5tYZXQBSlFLxEM+0LzH2aYIsIrnS/3rdf/wr
        Y6Rs1JTiq7kMYfMXaFDzetGPcoqm+GLndUfLWjcq6IhY2kNRu31bC3zimLjrLcCWTq3Bui
        n4aHvHMCsAHfS7JGzk6kC8FGcnWkPmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-wK7zt24sNdWqOqLclLCajw-1; Wed, 13 Oct 2021 12:56:19 -0400
X-MC-Unique: wK7zt24sNdWqOqLclLCajw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EF851006AA2;
        Wed, 13 Oct 2021 16:56:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 953E85DA60;
        Wed, 13 Oct 2021 16:56:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Subject: [PATCH 1/8] KVM: SEV-ES: fix length of string I/O
Date:   Wed, 13 Oct 2021 12:56:09 -0400
Message-Id: <20211013165616.19846-2-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The size of the data in the scratch buffer is not divided by the size of
each port I/O operation, so vcpu->arch.pio.count ends up being larger
than it should be by a factor of size.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c36b5fe4c27c..e672493b5d8d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2583,7 +2583,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 		return -EINVAL;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len, in);
+				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)
-- 
2.27.0


