Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B01582F65
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbiG0RZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242135AbiG0RYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F81F7B789;
        Wed, 27 Jul 2022 09:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A101B821C5;
        Wed, 27 Jul 2022 16:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A684DC433C1;
        Wed, 27 Jul 2022 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940364;
        bh=Waml6J/VeBRBz7TwxuUTAlIY34ndmXwlkyv6V9eG/6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztKNkuYEWiUvqUTW52jxn/84ccyrs7HMULRvc+PMdx64//zCxafCMsm2bgpgZj9MZ
         n7KP9NR+vEY5FHAP0Ekk3YB2RQM4tAE3U236Hkrcd0LNR9N+qbaOZACkhKdFXu6t1i
         srLGKHuNONFe6lK+KlzpgwTsrVphl9wVhw/3f7fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 198/201] KVM: x86: fix typo in __try_cmpxchg_user causing non-atomicness
Date:   Wed, 27 Jul 2022 18:11:42 +0200
Message-Id: <20220727161035.989812551@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 33fbe6befa622c082f7d417896832856814bdde0 upstream.

This shows up as a TDP MMU leak when running nested.  Non-working cmpxchg on L0
relies makes L1 install two different shadow pages under same spte, and one of
them is leaked.

Fixes: 1c2361f667f36 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220512101420.306759-1-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6933,7 +6933,7 @@ static int emulator_cmpxchg_emulated(str
 		goto emul_write;
 
 	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
-	if (kvm_is_error_hva(addr))
+	if (kvm_is_error_hva(hva))
 		goto emul_write;
 
 	hva += offset_in_page(gpa);


