Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4164F6ADD
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiDFUKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiDFUKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33D3C3F8A9
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 10:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649265565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=s7v+/Smwki1rqF8Y2TeWuoafwlE31yyfXOgyMdnzrfM=;
        b=YsCsBov02r9LrvXnJYvhVvxprg/LJOEIpEFPJHC9bcGGcQzV9Aj9q3kwlUOPccheElqk2L
        5MY1y5/wgA6OYL7qX7YzEfM4xwdxzXNvhVpfYpjk1eDMWdWADPFE/YuJxyftd270mxfqRj
        UWflSbh+cx2i4WNf4j8UGsl7S287JDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-pCbAu8F3M_OzppVhmOgOSA-1; Wed, 06 Apr 2022 13:19:24 -0400
X-MC-Unique: pCbAu8F3M_OzppVhmOgOSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F28171C01700;
        Wed,  6 Apr 2022 17:19:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47A33401E77;
        Wed,  6 Apr 2022 17:19:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Qiuhao Li <qiuhao@sysec.org>, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>, stable@vger.kernel.org
Subject: [PATCH] KVM: avoid NULL pointer dereference in kvm_dirty_ring_push
Date:   Wed,  6 Apr 2022 13:19:23 -0400
Message-Id: <20220406171923.14712-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kvm_vcpu_release() will call kvm_dirty_ring_free(), freeing
ring->dirty_gfns and setting it to NULL.  Afterwards, it calls
kvm_arch_vcpu_destroy().

However, if closing the file descriptor races with KVM_RUN in such away
that vcpu->arch.st.preempted == 0, the following call stack leads to a
NULL pointer dereference in kvm_dirty_run_push():

 mark_page_dirty_in_slot+0x192/0x270 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3171
 kvm_steal_time_set_preempted arch/x86/kvm/x86.c:4600 [inline]
 kvm_arch_vcpu_put+0x34e/0x5b0 arch/x86/kvm/x86.c:4618
 vcpu_put+0x1b/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:211
 vmx_free_vcpu+0xcb/0x130 arch/x86/kvm/vmx/vmx.c:6985
 kvm_arch_vcpu_destroy+0x76/0x290 arch/x86/kvm/x86.c:11219
 kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]

The fix is to release the dirty page ring after kvm_arch_vcpu_destroy
has run.

Reported-by: Qiuhao Li <qiuhao@sysec.org>
Reported-by: Gaoning Pan <pgn@zju.edu.cn>
Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..b22f380e3347 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -434,8 +434,8 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes
-- 
2.31.1

