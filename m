Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90B163D58F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiK3M0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiK3M0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:26:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420D573BB2
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F38A6B81B2F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C67C433D6;
        Wed, 30 Nov 2022 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669811165;
        bh=7lLvZiFDIS4YGX23V638e3mHnVf+zmgW7SgfUiL6RUE=;
        h=Subject:To:Cc:From:Date:From;
        b=HkRd+db2VeZWrX92R7EYg69nQ8YsBHVtAFLtKmd617/l1PG2piBsK7+xP172/Mham
         gNNtY3gnReyFFWuKnwa4Z2QWmFDonasTdtPTbpT5IL+2GBAOWiruCPs8gxhIsi+Tmx
         h3ObOzaJRNi7JWPf5vwBo9ahZPjZa8+jAMmk5Xds=
Subject: FAILED: patch "[PATCH] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02" failed to apply to 5.10-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:26:02 +0100
Message-ID: <16698111621095@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

16ae56d7e052 ("KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 16ae56d7e0528559bf8dc9070e3bfd8ba3de80df Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Thu, 3 Nov 2022 16:13:44 +0200
Subject: [PATCH] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02
 while still in use

Make sure that KVM uses vmcb01 before freeing nested state, and warn if
that is not the case.

This is a minimal fix for CVE-2022-3344 making the kernel print a warning
instead of a kernel panic.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-3-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230..b02a3a1792f1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1125,6 +1125,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 	if (!svm->nested.initialized)
 		return;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
+		svm_switch_vmcb(svm, &svm->vmcb01);
+
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 

