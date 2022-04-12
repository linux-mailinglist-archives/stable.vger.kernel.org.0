Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D474FD96C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiDLHVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351807AbiDLHM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01B260D2;
        Mon, 11 Apr 2022 23:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 497426149D;
        Tue, 12 Apr 2022 06:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F62AC385A1;
        Tue, 12 Apr 2022 06:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746380;
        bh=YbIKFM7y60MKoj8g2fObDLCsX6eNMh481mfKZ8yaewM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwcG+jSg2/MfuoA7A3t2bwlk4/cSUl0OIvXGXLGT6OOSEFW5Fas/C32HyViU4SHWd
         cuIBs2B/XnVk9xvlzTYoK0VA2+LzyKs+C3y8mhtrPr7/3dr5V4mEn8H/bFB312ROQP
         FW5JNQLIjn0d31uO3Rejba6G7mr6FFK0Cpdyg/CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 261/277] KVM: avoid NULL pointer dereference in kvm_dirty_ring_push
Date:   Tue, 12 Apr 2022 08:31:04 +0200
Message-Id: <20220412062949.597891763@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
@@ -431,8 +431,8 @@ static void kvm_vcpu_init(struct kvm_vcp
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes


