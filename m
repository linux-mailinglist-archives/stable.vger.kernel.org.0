Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AA51DBB57
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 19:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgETRYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 13:24:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36793 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727123AbgETRWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 13:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Q+b6NQYzxi9xQtxvdZVxdcLNZ7D1Hncrtt81Kk0DSak=;
        b=W3yYSNzhzd6OIIMlj2Nin5504P5jfxNnYqh/UXBwRc0vX9BsZDtWXg+ZOW8unSj9Upke0O
        2eEG4SImsIlV+Jrk7fVdgSAhzvBkUpdaJk2ApeAkUkO0+3DoHSkNFwBKSb9gNwtQA1aNWV
        tGs96kNxEnDiwFiDLnK6XgIBR82ejEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-DG15L6McMBqg3yiYId3LCw-1; Wed, 20 May 2020 13:21:59 -0400
X-MC-Unique: DG15L6McMBqg3yiYId3LCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20CD019200F7;
        Wed, 20 May 2020 17:21:48 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CA6560C20;
        Wed, 20 May 2020 17:21:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH 02/24] KVM: nSVM: leave ASID aside in copy_vmcb_control_area
Date:   Wed, 20 May 2020 13:21:23 -0400
Message-Id: <20200520172145.23284-3-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Restoring the ASID from the hsave area on VMEXIT is wrong, because its
value depends on the handling of TLB flushes.  Just skipping the field in
copy_vmcb_control_area will do.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f4cd2d0cc360..d544cce4f964 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -150,7 +150,7 @@ static void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb
 	dst->iopm_base_pa         = from->iopm_base_pa;
 	dst->msrpm_base_pa        = from->msrpm_base_pa;
 	dst->tsc_offset           = from->tsc_offset;
-	dst->asid                 = from->asid;
+	/* asid not copied, it is handled manually for svm->vmcb.  */
 	dst->tlb_ctl              = from->tlb_ctl;
 	dst->int_ctl              = from->int_ctl;
 	dst->int_vector           = from->int_vector;
-- 
2.18.2


