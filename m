Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1568C469EC7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391041AbhLFPoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389884AbhLFPlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:41:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A35C061D7F;
        Mon,  6 Dec 2021 07:25:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F0ABB8111C;
        Mon,  6 Dec 2021 15:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C837C34900;
        Mon,  6 Dec 2021 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804325;
        bh=Yqhpzb6SWwIY9NoHHa1efjNLEYdbawPk2KqyVpft0mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/HiSFM7l3HIwDtNFBcBkmYqDBqeCir4T9P+S2XJ/LQUlR4CrxJ9ReL4zFo12ycDL
         SsEDq5WY0oH607KmduWjOmQZSBKcfGGX4H8V/e0wYYR5MES/elycpaUFnwXFiDQ1/O
         a195EoHr6Dww8deJ3GJ57+ukNdzouhJ/W+VARLFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 074/207] KVM: x86: ignore APICv if LAPIC is not enabled
Date:   Mon,  6 Dec 2021 15:55:28 +0100
Message-Id: <20211206145612.794974254@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 78311a514099932cd8434d5d2194aa94e56ab67c upstream.

Synchronize the two calls to kvm_x86_sync_pir_to_irr.  The one
in the reenter-guest fast path invoked the callback unconditionally
even if LAPIC is present but disabled.  In this case, there are
no interrupts to deliver, and therefore posted interrupts can
be ignored.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9723,7 +9723,7 @@ static int vcpu_enter_guest(struct kvm_v
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-		if (vcpu->arch.apicv_active)
+		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
 			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 		if (unlikely(kvm_vcpu_exit_request(vcpu))) {


