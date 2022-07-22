Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535FC57DE0B
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiGVJN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbiGVJMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:12:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AB23C8ED;
        Fri, 22 Jul 2022 02:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5CF861F4D;
        Fri, 22 Jul 2022 09:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CEDC341C6;
        Fri, 22 Jul 2022 09:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481023;
        bh=XYlx/CGlMFklOfXxJVZihlVrGPOesdPtbd4itWoo9GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5zQKoMkjsQnPwbYBGnxKjEvKXRojVmF+gklvOqC6Rp+p0G2arg63mHyDEUxslaMG
         Qkc8IPXzHm5/suSnzjOBYiQQtEXCMcL1y9gEXvY4tYInd8Dr32hgFaLlm5m1CbD4sS
         HIdGA0QA2S9h3BgHX/pU0A7Kjt9AoHgUbfAo1inI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 50/70] KVM: VMX: Fix IBRS handling after vmexit
Date:   Fri, 22 Jul 2022 11:07:45 +0200
Message-Id: <20220722090653.521629173@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit bea7e31a5caccb6fe8ed989c065072354f0ecb52 upstream.

For legacy IBRS to work, the IBRS bit needs to be always re-written
after vmexit, even if it's already on.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6845,8 +6845,13 @@ void noinstr vmx_spec_ctrl_restore_host(
 
 	/*
 	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 *
+	 * For legacy IBRS, the IBRS bit always needs to be written after
+	 * transitioning from a less privileged predictor mode, regardless of
+	 * whether the guest/host values differ.
 	 */
-	if (vmx->spec_ctrl != hostval)
+	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	    vmx->spec_ctrl != hostval)
 		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
 
 	barrier_nospec();


