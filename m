Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6144F2D29
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353758AbiDEKJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345428AbiDEJWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE124A91A;
        Tue,  5 Apr 2022 02:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C617661527;
        Tue,  5 Apr 2022 09:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3642C385A0;
        Tue,  5 Apr 2022 09:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149855;
        bh=8VTJKxnFGmJl+q+s6XaRFXc08iUt6ahkmVP/NwzLsz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqjil2mu7Wxd+r7uitqcaBGx7BS5gNWwy+XQ+oeS/1g6otGQTv0Ax9av9QVfxD11Z
         4JDfuzcdsZtPb7cL4cokdPasUOi493gKwKBpS+x7xGo+8S+krKL/nSOOLsoNTWkuhM
         8VsxG1A9eITg+lcYjfzvZvcNfEikhCAqbsuonM7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 0864/1017] KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast TLB flush hypercalls
Date:   Tue,  5 Apr 2022 09:29:37 +0200
Message-Id: <20220405070419.881405296@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 7321f47eada53a395fb3086d49297eebb19e8e58 upstream.

When TLB flush hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}_EX are
issued in 'XMM fast' mode, the maximum number of allowed sparse_banks is
not 'HV_HYPERCALL_MAX_XMM_REGISTERS - 1' (5) but twice as many (10) as each
XMM register is 128 bit long and can hold two 64 bit long banks.

Cc: stable@vger.kernel.org # 5.14.x
Fixes: 5974565bc26d ("KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220222154642.684285-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1819,7 +1819,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 
 		if (!all_cpus) {
 			if (hc->fast) {
-				if (sparse_banks_len > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
+				/* XMM0 is already consumed, each XMM holds two sparse banks. */
+				if (sparse_banks_len > 2 * (HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
 					return HV_STATUS_INVALID_HYPERCALL_INPUT;
 				for (i = 0; i < sparse_banks_len; i += 2) {
 					sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);


