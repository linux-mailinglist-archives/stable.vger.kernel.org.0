Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55243A2EA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhJYTym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237218AbhJYTvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C98A66115B;
        Mon, 25 Oct 2021 19:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190975;
        bh=x7FdPGNgdlQfZVlHo+wv44F7iyvy7qD7oVU94eQ3Bmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFTAu23jz8/nddCLyY0FzIiNdIQKD3umwpYE1CMM6gX6UiRUnRsWYL6FIbAisbDo3
         8g4Y/YjJtdsRbhaiZrKNRN5kz4AkeCqWY+bLIjK56pd+PtjkS784qXGiyGelMFxUfy
         bFGFwKUIc1Yg4E/iuO8t/nkCL8BHBJbX6Fw2aqpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 115/169] KVM: x86: remove unnecessary arguments from complete_emulator_pio_in
Date:   Mon, 25 Oct 2021 21:14:56 +0200
Message-Id: <20211025191032.536826293@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 6b5efc930bbc8c97e4a1fe2ccb9a6f286365a56d upstream.

complete_emulator_pio_in can expect that vcpu->arch.pio has been filled in,
and therefore does not need the size and count arguments.  This makes things
nicer when the function is called directly from a complete_userspace_io
callback.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6936,11 +6936,12 @@ static int __emulator_pio_in(struct kvm_
 	return emulator_pio_in_out(vcpu, size, port, count, true);
 }
 
-static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-				    unsigned short port, void *val)
+static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
 {
-	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
-	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
+	int size = vcpu->arch.pio.size;
+	unsigned count = vcpu->arch.pio.count;
+	memcpy(val, vcpu->arch.pio_data, size * count);
+	trace_kvm_pio(KVM_PIO_IN, vcpu->arch.pio.port, size, count, vcpu->arch.pio_data);
 	vcpu->arch.pio.count = 0;
 }
 
@@ -6958,7 +6959,7 @@ static int emulator_pio_in(struct kvm_vc
 	}
 
 	WARN_ON(count != vcpu->arch.pio.count);
-	complete_emulator_pio_in(vcpu, size, port, val);
+	complete_emulator_pio_in(vcpu, val);
 	return 1;
 }
 


