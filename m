Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460264CFAC5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbiCGKWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbiCGKVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:21:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF2D90FC2;
        Mon,  7 Mar 2022 01:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A2FD60BBD;
        Mon,  7 Mar 2022 09:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F340AC340E9;
        Mon,  7 Mar 2022 09:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647085;
        bh=73Vr+GDyU9LAMXh+p+pjMnENcOtKhUYiW0DCLtICgo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN8jWhAbeLrRowOdeaBf1VqaE6kdgLf1Op7KT9biiGHM65bYW1PKORYOykyZN0BUA
         C1IgVmh5ioBRko9CgBjxxdQNg/pCLqOFWcx/slf1OqP/HrUHroYpIH0PFFnSUmwe2Y
         hhoQZeMqPN5w4vXMmq4QUAja3+PE6Eyysniu5evs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 186/186] KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()
Date:   Mon,  7 Mar 2022 10:20:24 +0100
Message-Id: <20220307091659.282066868@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

commit c6c937d673aaa1d603f62f134e1ca9c173eeeed3 upstream.

Just like on the optional mmu_alloc_direct_roots() path, once shadow
path reaches "r = -EIO" somewhere, the caller needs to know the actual
state in order to enter error handling and avoid something worse.

Fixes: 4a38162ee9f1 ("KVM: MMU: load PDPTRs outside mmu_lock")
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220301124941.48412-1-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3573,7 +3573,7 @@ set_root_pgd:
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	return 0;
+	return r;
 }
 
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)


