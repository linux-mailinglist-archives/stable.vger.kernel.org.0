Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1866DEF78
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjDLIvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjDLIvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569E19741
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBD86317F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FD4C433D2;
        Wed, 12 Apr 2023 08:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289439;
        bh=sddEuKU4VUbzVx0wQNn1BnzPMxQ388nNWKkeANiIyi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pl3GCL6zJzGsH/ozIbkC8R+TJKu8Gtl4b7g7uf0+AHsMF6ci87jUkLmc7SDhJjFfM
         x+iurvl57XsikYERRPZf57mxuaO7Ps1mi0NKX5OCk6oVhNMsNlCYGXJ1CdhnExYU3Y
         sWpcpSdMN3Jgm3i83jm8/V5uFE1MitUPOWN5Elqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.2 100/173] KVM: nVMX: Do not report error code when synthesizing VM-Exit from Real Mode
Date:   Wed, 12 Apr 2023 10:33:46 +0200
Message-Id: <20230412082842.119583117@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 80962ec912db56d323883154efc2297473e692cb upstream.

Don't report an error code to L1 when synthesizing a nested VM-Exit and
L2 is in Real Mode.  Per Intel's SDM, regarding the error code valid bit:

  This bit is always 0 if the VM exit occurred while the logical processor
  was in real-address mode (CR0.PE=0).

The bug was introduced by a recent fix for AMD's Paged Real Mode, which
moved the error code suppression from the common "queue exception" path
to the "inject exception" path, but missed VMX's "synthesize VM-Exit"
path.

Fixes: b97f07458373 ("KVM: x86: determine if an exception has an error code only when injecting it.")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230322143300.2209476-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3873,7 +3873,12 @@ static void nested_vmx_inject_exception_
 		exit_qual = 0;
 	}
 
-	if (ex->has_error_code) {
+	/*
+	 * Unlike AMD's Paged Real Mode, which reports an error code on #PF
+	 * VM-Exits even if the CPU is in Real Mode, Intel VMX never sets the
+	 * "has error code" flags on VM-Exit if the CPU is in Real Mode.
+	 */
+	if (ex->has_error_code && is_protmode(vcpu)) {
 		/*
 		 * Intel CPUs do not generate error codes with bits 31:16 set,
 		 * and more importantly VMX disallows setting bits 31:16 in the


