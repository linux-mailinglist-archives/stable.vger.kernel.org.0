Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0764511F75
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244164AbiD0RlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 13:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244154AbiD0RlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 13:41:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A7CD42EFB
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 10:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651081083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FOuPsZmttscCUzrdgCT+bpLiEl9kjRC6zlmWOVhms7w=;
        b=bbrPctrWOdVWcSfYQsvGryoDxnSwAScnG9+bpgB86ZZhZsUcsYlKQVRKqbSzUfJGkxKF3O
        HQvpIotZgdzmqgcrxWePl3rZWxrE5paN36GZVfhX9nyfIO/u7wWkJxIlzTm4hmXRJlZs3X
        cDZqE15k7Q4nfMyFQh4RgYM5wXyhPz4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-KmlYmgC8PMGzPe8kMGlFLw-1; Wed, 27 Apr 2022 13:37:59 -0400
X-MC-Unique: KmlYmgC8PMGzPe8kMGlFLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F56C86B8A5;
        Wed, 27 Apr 2022 17:37:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46CAD407DEC3;
        Wed, 27 Apr 2022 17:37:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: a vCPU with a pending triple fault is runnable
Date:   Wed, 27 Apr 2022 13:37:57 -0400
Message-Id: <20220427173758.517087-3-pbonzini@redhat.com>
In-Reply-To: <20220427173758.517087-1-pbonzini@redhat.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e73607b02bd..d563812ca229 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12187,6 +12187,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	    kvm_x86_ops.nested_ops->has_events(vcpu))
 		return true;
 
+	if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
+		return true;
+
 	return false;
 }
 
-- 
2.31.1


