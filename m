Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBFF6D484A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbjDCO1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjDCO1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:27:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7393128B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82BE9B81C1E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED740C4339C;
        Mon,  3 Apr 2023 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532037;
        bh=+AqsdoXX1+zffDVznsRETyUkgvYlUZwBQXD6hT4DKaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlvMW30+LhlFvi5G2n8OdxSOqHQ3SdxmthfZ3OK3ZuMVbUqS6cwiP7GyWV7z0Hn3f
         O9K63yFctcPXPPpdDXykiTm08RLL7P8jNWcUzAVdaXl5H3iyaLFs0f8ulGmXNnMe3H
         LijvAFYcrjFXUs/SsXGAX+h1A8b0nicsW33U40ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaohe Lin <linmiaohe@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 102/173] KVM: fix memoryleak in kvm_init()
Date:   Mon,  3 Apr 2023 16:08:37 +0200
Message-Id: <20230403140417.736634661@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit 5a2a961be2ad6a16eb388a80442443b353c11d16 upstream.

When alloc_cpumask_var_node() fails for a certain cpu, there might be some
allocated cpumasks for percpu cpu_kick_mask. We should free these cpumasks
or memoryleak will occur.

Fixes: baff59ccdc65 ("KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Link: https://lore.kernel.org/r/20220823063414.59778-1-linmiaohe@huawei.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5014,7 +5014,7 @@ int kvm_init(void *opaque, unsigned vcpu
 
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free_5;
+		goto out_free_4;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
@@ -5047,10 +5047,9 @@ err_register:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
-out_free_5:
+out_free_4:
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
-out_free_4:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);


