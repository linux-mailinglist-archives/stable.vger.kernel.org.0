Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BBD63DEBA
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiK3SkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiK3SkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:40:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C8897019
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:40:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DCD7B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6369C433D6;
        Wed, 30 Nov 2022 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833606;
        bh=3C2evLwJp8RYVdmmaW/it9wtHBC9bZeNsmjCwKkBpIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5ShP/wF2mwjJuzNJLSKVNcAlcYeziSiaSTkSW9KtBBEn2et9CxJ6Bz0TuBPRc6WA
         jAaaOyH4ehW6BinjkwycBYSKyBBDHKxe/FADiXbeL2dE2+oW2Lc/z/v6msYHThbjCD
         BXmAq+o2FRQDIY7MtWCFsFZp6Bs6rnM/iX1d8hJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 156/206] KVM: x86: nSVM: leave nested mode on vCPU free
Date:   Wed, 30 Nov 2022 19:23:28 +0100
Message-Id: <20221130180537.003871916@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 917401f26a6af5756d89b550a8e1bd50cf42b07e upstream.

If the VM was terminated while nested, we free the nested state
while the vCPU still is in nested mode.

Soon a warning will be added for this condition.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1427,6 +1427,7 @@ static void svm_free_vcpu(struct kvm_vcp
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	sev_free_vcpu(vcpu);


