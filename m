Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9F44FD55F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377613AbiDLHuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359410AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E232C11F;
        Tue, 12 Apr 2022 00:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C4376153F;
        Tue, 12 Apr 2022 07:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD39C385A1;
        Tue, 12 Apr 2022 07:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748171;
        bh=2R3Jg6wuXoD3K4IfpFwi6Rua3esT/XHSYiQeLfWGfd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+LzTD1xcfleitD28IwW1X+U+9QMweDkDl2BkmHJCTTDLLbfgGba6wwuIJ6AogXqW
         lWqNNTPYMzR416syDqGfIFMOOvn7l66s1UPFLiDOaXqLe+48eDQDwE/Li48ARzVJgL
         iu2g4IaQDn0wSUO5Fi5da9Tny+X/iK9YSDYUsNZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 325/343] KVM: avoid NULL pointer dereference in kvm_dirty_ring_push
Date:   Tue, 12 Apr 2022 08:32:23 +0200
Message-Id: <20220412063000.702105259@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 5593473a1e6c743764b08e3b6071cb43b5cfa6c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -439,8 +439,8 @@ static void kvm_vcpu_init(struct kvm_vcp
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes


