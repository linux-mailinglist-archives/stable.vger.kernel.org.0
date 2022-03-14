Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E134D82D6
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240715AbiCNMLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242788AbiCNMKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:10:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C752FFD8;
        Mon, 14 Mar 2022 05:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E0326130D;
        Mon, 14 Mar 2022 12:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB79C340EC;
        Mon, 14 Mar 2022 12:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259780;
        bh=nK0fHhUPWtbyhA90lBEgj/JeM/L8D0Uaf85ZTdj+OQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrAyqss/n6dCN9gcOqXtEHoEKdqADVti7fLkVwq53URpBLE4Y51Qszy/0FkugprHc
         NehWa5i2IBHc0Crobw4cwpP3mbsQGetz6QJMfV4y8W8L6sK21xGDbc7k5TiKYpf1lr
         VgMscDKj6CahxDgJZtIn37KwSLBnGOs9nz0U0zmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrei Vagin <avagin@gmail.com>
Subject: [PATCH 5.15 088/110] KVM: x86/mmu: kvm_faultin_pfn has to return false if pfh is returned
Date:   Mon, 14 Mar 2022 12:54:30 +0100
Message-Id: <20220314112745.487207310@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

commit a7cc099f2ec3117678adeb69749bef7e9dde3148 upstream.

This looks like a typo in 8f32d5e563cb. This change didn't intend to do
any functional changes.

The problem was caught by gVisor tests.

Fixes: 8f32d5e563cb ("KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Message-Id: <20211015163221.472508-1-avagin@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3967,6 +3967,7 @@ static bool kvm_faultin_pfn(struct kvm_v
 
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
 				    write, writable, hva);
+	return false;
 
 out_retry:
 	*r = RET_PF_RETRY;


