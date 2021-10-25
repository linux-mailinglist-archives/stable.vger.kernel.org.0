Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31143A2D2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhJYTxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238656AbhJYTu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D998860F9B;
        Mon, 25 Oct 2021 19:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190962;
        bh=Y732O1lxj+halw2WJiGRr2uq8g81Vo5/Ubj/Be0jxpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxWau5a4EMm0p0M21BJGWx/wLBDVdTkq4wyk8dEB1jM35O2z9zoxWjASqZmTbxxMG
         g9gpmcteh/Z00iP6PqVMGl6i0xOfA4+0a6MeNQzilYn20iaVkHRvsVKjEGWPOQitaY
         m+d4E/eaa1GpmC0HGUzu9eoteBzQ/IC86cAO3a/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 112/169] KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
Date:   Mon, 25 Oct 2021 21:14:53 +0200
Message-Id: <20211025191032.208466232@linuxfoundation.org>
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

commit 0d33b1baeb6ca7165d5ed4fdd1a8f969985e35b9 upstream.

Currently emulator_pio_in clears vcpu->arch.pio.count twice if
emulator_pio_in_out performs kernel PIO.  Move the clear into
emulator_pio_out where it is actually necessary.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6915,10 +6915,8 @@ static int emulator_pio_in_out(struct kv
 	vcpu->arch.pio.count  = count;
 	vcpu->arch.pio.size = size;
 
-	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
-		vcpu->arch.pio.count = 0;
+	if (!kernel_pio(vcpu, vcpu->arch.pio_data))
 		return 1;
-	}
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -6964,9 +6962,16 @@ static int emulator_pio_out(struct kvm_v
 			    unsigned short port, const void *val,
 			    unsigned int count)
 {
+	int ret;
+
 	memcpy(vcpu->arch.pio_data, val, size * count);
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	if (ret)
+                vcpu->arch.pio.count = 0;
+
+        return ret;
+
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,


