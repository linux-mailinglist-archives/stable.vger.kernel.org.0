Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1EF47272A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhLMJ66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:43698 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbhLMJzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:55:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96974CE0DDE;
        Mon, 13 Dec 2021 09:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ACFC34600;
        Mon, 13 Dec 2021 09:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389338;
        bh=fUVGyH+XIPMZ1nlNIXBaTxUODMScq46yKspBYddh4gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEZTc5nEhBpcPh9dzxhPDC5HQYIbuonHrSEncpi9422w9cmyVRrEvTt9Qh/lXysAo
         Tlt4ILzBWdre1rjKQfbvb+F0G8huTHzWlx9ljEgYh2sT/obAadfxnBcKtdAZDaO639
         lFxm6A/XX59rHvPZG862jmv0sMFWxApY0CQpEVlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 058/171] KVM: x86: Ignore sparse banks size for an "all CPUs", non-sparse IPI req
Date:   Mon, 13 Dec 2021 10:29:33 +0100
Message-Id: <20211213092947.030664742@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 3244867af8c065e51969f1bffe732d3ebfd9a7d2 upstream.

Do not bail early if there are no bits set in the sparse banks for a
non-sparse, a.k.a. "all CPUs", IPI request.  Per the Hyper-V spec, it is
legal to have a variable length of '0', e.g. VP_SET's BankContents in
this case, if the request can be serviced without the extra info.

  It is possible that for a given invocation of a hypercall that does
  accept variable sized input headers that all the header input fits
  entirely within the fixed size header. In such cases the variable sized
  input header is zero-sized and the corresponding bits in the hypercall
  input should be set to zero.

Bailing early results in KVM failing to send IPIs to all CPUs as expected
by the guest.

Fixes: 214ff83d4473 ("KVM: x86: hyperv: implement PV IPI send hypercalls")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211207220926.718794-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/hyperv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1922,11 +1922,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 
 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
 
+		if (all_cpus)
+			goto check_and_send_ipi;
+
 		if (!sparse_banks_len)
 			goto ret_success;
 
-		if (!all_cpus &&
-		    kvm_read_guest(kvm,
+		if (kvm_read_guest(kvm,
 				   hc->ingpa + offsetof(struct hv_send_ipi_ex,
 							vp_set.bank_contents),
 				   sparse_banks,
@@ -1934,6 +1936,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vc
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
 
+check_and_send_ipi:
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 


