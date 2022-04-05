Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968114F34F6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiDEJAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiDEIbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A01348392;
        Tue,  5 Apr 2022 01:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A72B81B13;
        Tue,  5 Apr 2022 08:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726F4C385AA;
        Tue,  5 Apr 2022 08:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146982;
        bh=8dWur2snVcJS4cdQqUfYAVt/38NBteIludl2uuzhNGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0ZCIJf21u9MXTshgwkE4T4nbVZF/UnW6acdNKGSpZDDuea6vtp2h0cEUCcdEabrW
         r2SApUafrEH06e5yuH9yVp3ZQ1ilYhFTL0lb219Lu6xnJ2gm6rvWm+uj5oboAZ6Bqr
         aZTxmrjaPkKE4gM57bAAl/mE3wkjA4aodYUWB+pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 0958/1126] KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast TLB flush hypercalls
Date:   Tue,  5 Apr 2022 09:28:25 +0200
Message-Id: <20220405070435.624123319@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1820,7 +1820,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_v
 
 		if (!all_cpus) {
 			if (hc->fast) {
-				if (sparse_banks_len > HV_HYPERCALL_MAX_XMM_REGISTERS - 1)
+				/* XMM0 is already consumed, each XMM holds two sparse banks. */
+				if (sparse_banks_len > 2 * (HV_HYPERCALL_MAX_XMM_REGISTERS - 1))
 					return HV_STATUS_INVALID_HYPERCALL_INPUT;
 				for (i = 0; i < sparse_banks_len; i += 2) {
 					sparse_banks[i] = sse128_lo(hc->xmm[i / 2 + 1]);


