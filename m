Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1625B4FDAD0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356063AbiDLHeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354602AbiDLH02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330146165;
        Tue, 12 Apr 2022 00:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D6061748;
        Tue, 12 Apr 2022 07:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9452DC36B17;
        Tue, 12 Apr 2022 07:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747181;
        bh=ueCG/4U08Yns50W24hGz63YxADmJDJ9yGaJ7Tmf5doA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf6mDUBv4y/EXeWR84J0o5eUSgQctwLgRbJjL6vnkeWUFgClk0wLrxoJlyV44YyTj
         cJ9JKNdbKfUKuVG5de7av4ikR94RmDO4/XU+/xOrnMJzOqzB/1q6IbdNHcslIPe8Ut
         usQuOptFU/oiBdIMs2EdAGw2NYw669fW7JENIzL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 272/285] KVM: avoid NULL pointer dereference in kvm_dirty_ring_push
Date:   Tue, 12 Apr 2022 08:32:09 +0200
Message-Id: <20220412062951.507981108@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes


