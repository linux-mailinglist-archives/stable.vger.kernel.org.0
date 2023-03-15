Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312D46BB1F6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjCOMbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjCOMbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833A2898D5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD0FDB81DFC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F53C4339B;
        Wed, 15 Mar 2023 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883444;
        bh=0TaenCG7Yd1K/L9+Ul+Gcy8+ltW7YHzECarslru7gB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Afoa112YxMDc9RL4hkQVrikXdWuijAlP3tO/eWcMVWmOGuPmeIqNjuXPMfYwnQ9mq
         SjRQx3F4Fc7/3s5lUpvGNN3U4nkqTrsTG2VmLagQy5zo3BRupsp5afiYCFC3L+UWr+
         fstuJJ1kh6jIIeO+6lnHsTp9x3YqWnFKPwDefZvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaohe Lin <linmiaohe@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 139/145] KVM: fix memoryleak in kvm_init()
Date:   Wed, 15 Mar 2023 13:13:25 +0100
Message-Id: <20230315115743.505499630@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
@@ -5649,7 +5649,7 @@ int kvm_init(void *opaque, unsigned vcpu
 
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free_5;
+		goto out_free_4;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
@@ -5682,10 +5682,9 @@ err_register:
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


