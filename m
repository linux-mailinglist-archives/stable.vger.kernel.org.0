Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB81273068
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgIUREr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgIUQfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3984239D4;
        Mon, 21 Sep 2020 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706096;
        bh=X+QW1FOneFzIH0kaQ1QCDdLusiHrL4/oJ/oKlDIDMlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/G7C28x7bbTREV2sYwLjrmUd/fhXJs6zfrGvvi+a/S4SDTqULCAdQC+nCuGQqBfa
         4ZkvdXJrGADRiEQpMgamiRx++p3pObEzUvAAnEOS05KOUgD7LxW1WTeDFj3z6Ldk69
         HafFJdz6RUUFHs9sg73WGm/qqzsF/MoI1GyXw7yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 38/70] KVM: VMX: Dont freeze guest when event delivery causes an APIC-access exit
Date:   Mon, 21 Sep 2020 18:27:38 +0200
Message-Id: <20200921162036.859510599@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 99b82a1437cb31340dbb2c437a2923b9814a7b15 upstream.

According to SDM 27.2.4, Event delivery causes an APIC-access VM exit.
Don't report internal error and freeze guest when event delivery causes
an APIC-access exit, it is handleable and the event will be re-injected
during the next vmentry.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1597827327-25055-2-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8606,6 +8606,7 @@ static int vmx_handle_exit(struct kvm_vc
 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
 			exit_reason != EXIT_REASON_PML_FULL &&
+			exit_reason != EXIT_REASON_APIC_ACCESS &&
 			exit_reason != EXIT_REASON_TASK_SWITCH)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;


