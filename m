Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743A16130F3
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiJaHDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJaHDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:03:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8FF3A3
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 111C4B810B2
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A20EC433C1;
        Mon, 31 Oct 2022 07:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199807;
        bh=zTdu88MzWJfUvab9yQqqAnC1Ye7HEEk7Ir+WjaKooR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6MLx/xbxGZjRcR7ivZ0WyIvgUlCFh/F5pj+faxLlndF2WbDgcqn3WURrUItFk0QK
         mBV/iRqW76gVTpr/ydEm7cKpIHXix1XHfJogzCKpb6nQ79F3+RIi8EDkrErEIUtwf1
         8ZH3NQT1vO0Kt3dFIH2uv3EW2wCM3/Go5FKLHWzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 26/34] KVM: VMX: Fix IBRS handling after vmexit
Date:   Mon, 31 Oct 2022 08:02:59 +0100
Message-Id: <20221031070140.728020420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/vmx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -9781,8 +9781,13 @@ u64 __always_inline vmx_spec_ctrl_restor
 
 	/*
 	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 *
+	 * For legacy IBRS, the IBRS bit always needs to be written after
+	 * transitioning from a less privileged predictor mode, regardless of
+	 * whether the guest/host values differ.
 	 */
-	if (guestval != hostval)
+	if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) ||
+	    guestval != hostval)
 		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
 
 	barrier_nospec();


