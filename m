Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DB45005DB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 08:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiDNGXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 02:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbiDNGXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 02:23:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14404D24A;
        Wed, 13 Apr 2022 23:21:11 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so3867418plg.5;
        Wed, 13 Apr 2022 23:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=v6BSL8VhVmwIej2fDS4fILub4T69woLAa8tFuzppLBk=;
        b=myoGwm2G1MSWxH52mFS6PB//GYIp24Zl7kzfWhLsbgDggF7p3Uq899B13XQH5s71gu
         HHFqo6T+QWWaM66hqv+AyVlDLgA/ey/zDE2HM5L7WTYH4D2kU2LDq9fB6nM1HjNmFtCp
         hEqP6Z0xmeWKJqmVJ2bT6wT/f9FTWcSfZT1ed9mXOqC/ZtcS0ppQJyMNs4teGiBy2J3R
         nGsG4/HlF/Up6SkA56i2FJJZzhjZLHyUV95Ii+3tbh5yryu0XvRuWwPUFVqgq9b+ij1o
         A54iIEeEkJ81az7JwRj8iFxQMs2XOc+AC/ZlQRYtkaZZIUz1liYyXYTwdzsiLOPqesFB
         Glmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v6BSL8VhVmwIej2fDS4fILub4T69woLAa8tFuzppLBk=;
        b=13dzXlrVJkwyOBkNc1y7IPQcywIMm3woZQcKbkDOKa7EtCkYMSini3AOaN/HMqQthp
         X/f0GooRlanmIR/YiqrqGnLRgLlN1O5A51cRVF6qwsPJ2u9oFL8W02y4Qobg1tGkix4K
         tCVOoO9mRcdpXhVe7sSFIW0iGmTtj4+IETHVk07B9auikQBEVe/FlJGZUK0dC+HvLLyD
         cJ1n2HRJ0/yar2g4Vghx+uyfi+CqYmjehLvS2XA/E6/d6VbP98hkzHSdS9U7E/txgcI8
         6iJfyj4WG2B3R0O2infPBmMeeNp+94bfFdlO3jW+3WjxABuC7NES88cKd8PIUOq2rX8a
         HlRQ==
X-Gm-Message-State: AOAM532ggi1s5ONqX3eODP269Ue7cHc2Xnp+lbCn32gXqTWUNlIEmUPN
        UwsvVvT6DZj2AAuGsijVCYE=
X-Google-Smtp-Source: ABdhPJx/+VfCKqnYmadJUeIHFXxCThNG7ojieyEdrIdWyLC4NUzoCeJQJbvhMw0o07fEgwbpqK4R8g==
X-Received: by 2002:a17:90b:314a:b0:1cd:3a73:3a99 with SMTP id ip10-20020a17090b314a00b001cd3a733a99mr2641203pjb.189.1649917270729;
        Wed, 13 Apr 2022 23:21:10 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id nl17-20020a17090b385100b001c70883f6ccsm5042588pjb.36.2022.04.13.23.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 23:21:10 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        akpm@linux-foundation.org, liam.howlett@oracle.com,
        david@redhat.com, maz@kernel.org, Felix.Kuehling@amd.com,
        maciej.szmigiero@oracle.com, apopple@nvidia.com,
        bharata@linux.ibm.com, linuxram@us.ibm.com
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [RESEND][PATCH] KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator
Date:   Thu, 14 Apr 2022 14:21:03 +0800
Message-Id: <20220414062103.8153-1-xiam0nd.tong@gmail.com>
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

