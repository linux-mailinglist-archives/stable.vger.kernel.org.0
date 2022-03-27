Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E2C4E85DF
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiC0FSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbiC0FSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:18:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FCB13FB7;
        Sat, 26 Mar 2022 22:16:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w8so12084648pll.10;
        Sat, 26 Mar 2022 22:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=v6BSL8VhVmwIej2fDS4fILub4T69woLAa8tFuzppLBk=;
        b=p1RRPdi5pT7hK/9+H4XP2JjJHVZf5LxJOg8oRMScYDqznggSSt6DW7OpAdLqP4W8AO
         QWWXECWxX9RPOiBmnLcGSoeUAuH1F+eyyngCzsyhHkZijHQoVL9KbaZwV9fGF305+GcJ
         KQ3lX6EwP13jR2+yq49xM5HsChFGhq36v/XvVksErbSWaX6jJWgE1FVl4GfE6ZGDp/ME
         zuCOEEjiXqpFYeQgPcQWuFdbX097X4/JPAM0o/UjSHybVTDj/5lDfa+2lsiPJUw6JxuM
         exi7XYluIPx9OcyFwBgAHJMqZ3Sg1+1ssX6ot4argKFyWxlQSjKuvG+YfQKY4uDl0/u6
         BxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v6BSL8VhVmwIej2fDS4fILub4T69woLAa8tFuzppLBk=;
        b=cU7Qp9vKXqvMRS73ELCec5O95MjonHDNhMdZGG1UhVf0l10wTWWe4P0Pr4VH9QF6aT
         XczTUSk1B4vSAvnA4sx6oKhUQX3P59WXyL4jjgpcedqI8navp+7juikgjP5YFm/jD01y
         q7yHwaWO09RzyDZSz8ej/tY8W9/1SZWjTedM3Az9ZqifgcLzRUP0897Xef3lTtmzl6Dz
         wAV0/rPyGbZiK1GZeDMhPFAqDqgFZ7tU8axmHG2LTr1vUqEK4lgd9NhaqulrIgxK4QS+
         cmAvGs0hwGSUytdHYqLiraOfb/aNDR7hABQTomUlHB8f12lx9tRK4byBXkQ9D0g8gTmE
         MbRA==
X-Gm-Message-State: AOAM532UQXTs3IBpjI+NwbcNoaBfZIlVLjMdeScS+2EVQNC7KrliRR1A
        XEUoTE7AyWTWYnHRegrTt28=
X-Google-Smtp-Source: ABdhPJy4t0oQf/ADzsmcEEOjd/bCRxwrxMcaQ4ZDD2+D52Gbr5tPv/h47XDsREiddKHMcr1Fn6Xu5w==
X-Received: by 2002:a17:902:b906:b0:14f:76a0:ad48 with SMTP id bf6-20020a170902b90600b0014f76a0ad48mr20445815plb.79.1648358215837;
        Sat, 26 Mar 2022 22:16:55 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id d11-20020a056a00198b00b004fa7da68465sm11290361pfl.60.2022.03.26.22.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:16:55 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     mpe@ellerman.id.au
Cc:     benh@kernel.crashing.org, paulus@samba.org,
        akpm@linux-foundation.org, liam.howlett@oracle.com,
        david@redhat.com, maz@kernel.org, Felix.Kuehling@amd.com,
        maciej.szmigiero@oracle.com, apopple@nvidia.com,
        bharata@linux.ibm.com, linuxram@us.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] kvm: fix incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 13:16:46 +0800
Message-Id: <20220327051646.1856-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!p)
                return ret;

The list iterator value 'p' will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found.

To fix the bug, Use a new value 'iter' as the list iterator, while use
the old value 'p' as a dedicated variable to point to the found element.

Cc: stable@vger.kernel.org
Fixes: dfaa973ae9605 ("KVM: PPC: Book3S HV: In H_SVM_INIT_DONE, migrate remaining normal-GFNs to secure-GFNs")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e414ca44839f..0cb20ee6a632 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -360,13 +360,15 @@ static bool kvmppc_gfn_is_uvmem_pfn(unsigned long gfn, struct kvm *kvm,
 static bool kvmppc_next_nontransitioned_gfn(const struct kvm_memory_slot *memslot,
 		struct kvm *kvm, unsigned long *gfn)
 {
-	struct kvmppc_uvmem_slot *p;
+	struct kvmppc_uvmem_slot *p = NULL, *iter;
 	bool ret = false;
 	unsigned long i;
 
-	list_for_each_entry(p, &kvm->arch.uvmem_pfns, list)
-		if (*gfn >= p->base_pfn && *gfn < p->base_pfn + p->nr_pfns)
+	list_for_each_entry(iter, &kvm->arch.uvmem_pfns, list)
+		if (*gfn >= iter->base_pfn && *gfn < iter->base_pfn + iter->nr_pfns) {
+			p = iter;
 			break;
+		}
 	if (!p)
 		return ret;
 	/*
-- 
2.17.1

