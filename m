Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85566548ABC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381530AbiFMOIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380948AbiFMODH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:03:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20A58DDE3;
        Mon, 13 Jun 2022 04:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C28A7B80EA7;
        Mon, 13 Jun 2022 11:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF2DC34114;
        Mon, 13 Jun 2022 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120300;
        bh=j+uAT323+KaJj7UMoqr4xyarKUVNsQL7xM52Y8ib5w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zq3RLXS+29TORsDQ2ldRTznfIMPzf1kRvrwj42pABC44qp5AKCBO+lGcwhFvTYAgZ
         jg4/BwAwGUfo3oZKaLlJ2wMbpDWBmo7OL4Tx3w7RCshH7+3adAbDrdxL2UOxZOtzu7
         DRomr/c8CxC2w6OqQRYd55PHGVQUg1wSFSv7BvVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaoqin Huang <shaoqin.huang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 305/339] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Mon, 13 Jun 2022 12:12:10 +0200
Message-Id: <20220613094936.010226301@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

commit cf4a8693d97a51dccf5a1557248d12d6d8be4b9e upstream.

When freeing obsolete previous roots, check prev_roots as intended, not
the current root.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")
Message-Id: <20220607005905.2933378-1-shaoqin.huang@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5168,7 +5168,7 @@ static void __kvm_mmu_free_obsolete_root
 		roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
-		if (is_obsolete_root(kvm, mmu->root.hpa))
+		if (is_obsolete_root(kvm, mmu->prev_roots[i].hpa))
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 


