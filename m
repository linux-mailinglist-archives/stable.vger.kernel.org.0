Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D102C664A41
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbjAJSbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbjAJSar (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DE4F1E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7473FCE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B16CC433EF;
        Tue, 10 Jan 2023 18:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375149;
        bh=bD3heCiKQg8hcd0ERuongXvepuXNgMdHBxGBC3y33rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRLycioZOjDMtvUnjybZ6jfwCAmXwe7gFWzbwwoJV5vNm6dpET+XGGi2BPm6pJZax
         rcxZDnOu/R1LEODLBkhOewerfumJ8f9/68KWJ00s621LazHUAy7MsHVctX2yCyNvmX
         3bl3s66YbwD5nhF65pZMkKUtnVpIJqoOMd7oIl20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 093/290] KVM: VMX: Resume guest immediately when injecting #GP on ECREATE
Date:   Tue, 10 Jan 2023 19:03:05 +0100
Message-Id: <20230110180034.832350755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit eb3992e833d3a17f9b0a3e0371d0b1d3d566f740 upstream.

Resume the guest immediately when injecting a #GP on ECREATE due to an
invalid enclave size, i.e. don't attempt ECREATE in the host.  The #GP is
a terminal fault, e.g. skipping the instruction if ECREATE is successful
would result in KVM injecting #GP on the instruction following ECREATE.

Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Cc: stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/r/20220930233132.1723330-1-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/sgx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -188,8 +188,10 @@ static int __handle_encls_ecreate(struct
 	/* Enforce CPUID restriction on max enclave size. */
 	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
 							    sgx_12_0->edx;
-	if (size >= BIT_ULL(max_size_log2))
+	if (size >= BIT_ULL(max_size_log2)) {
 		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
 
 	/*
 	 * sgx_virt_ecreate() returns:


