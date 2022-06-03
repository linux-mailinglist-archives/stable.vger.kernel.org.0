Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D253CF82
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345620AbiFCRxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346215AbiFCRux (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18905A08F;
        Fri,  3 Jun 2022 10:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 336C6B823B0;
        Fri,  3 Jun 2022 17:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A13AC385A9;
        Fri,  3 Jun 2022 17:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278432;
        bh=64b60f8+CF+lQiNlhXAdnNtTZB8o0DTFOS04/xU40G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrFetdNMGXc/S0IJNfpbEkCPtE5Ap/DPzVKD1i8Jcg/ebbsdohjJ5C93w44h+NF1G
         eMHQ5cKE4Y8lJeF8W8ip67KJVO0mZANW5xjmFKJcKK0+nxroDl2pLDgZ66ram+NK6l
         4t2vuSFnC5GlO/F6y5Z/GXamk7AcLRTe1Tx1b6Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 31/53] KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator
Date:   Fri,  3 Jun 2022 19:43:16 +0200
Message-Id: <20220603173819.628510060@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 300981abddcb13f8f06ad58f52358b53a8096775 upstream.

The bug is here:
	if (!p)
                return ret;

The list iterator value 'p' will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found.

To fix the bug, Use a new value 'iter' as the list iterator, while use
the old value 'p' as a dedicated variable to point to the found element.

Fixes: dfaa973ae960 ("KVM: PPC: Book3S HV: In H_SVM_INIT_DONE, migrate remaining normal-GFNs to secure-GFNs")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220414062103.8153-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -359,13 +359,15 @@ static bool kvmppc_gfn_is_uvmem_pfn(unsi
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


