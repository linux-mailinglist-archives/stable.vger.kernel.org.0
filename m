Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE0343A2D4
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhJYTxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237176AbhJYTvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59A8F610D2;
        Mon, 25 Oct 2021 19:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190970;
        bh=dMm0c36jhVP2kmnmO/Kv1dL2mOS6lCfp27SNnoJrt7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PghqIdX15IxjZLDHITYbAouDJn9s8vyxLYh3OEoTiWl4wO0cd0nNcsvNJTMvuVT9g
         LIOt2DQ6A6uGlhroe8yyK4/o6osG5jebjm0RIb0Vh6McGRxo8p3lGyB+NTzytNnyrc
         b2+yqrW9Qb4zGiFdg+1Urh/ML602PzMCfyUsZDp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 114/169] KVM: x86: split the two parts of emulator_pio_in
Date:   Mon, 25 Oct 2021 21:14:55 +0200
Message-Id: <20211025191032.421237349@linuxfoundation.org>
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

commit 3b27de27183911d461afedf50c6fa30c59740c07 upstream.

emulator_pio_in handles both the case where the data is pending in
vcpu->arch.pio.count, and the case where I/O has to be done via either
an in-kernel device or a userspace exit.  For SEV-ES we would like
to split these, to identify clearly the moment at which the
sev_pio_data is consumed.  To this end, create two different
functions: __emulator_pio_in fills in vcpu->arch.pio.count, while
complete_emulator_pio_in clears it and releases vcpu->arch.pio.data.

Because this patch has to be backported, things are left a bit messy.
kernel_pio() operates on vcpu->arch.pio, which leads to emulator_pio_in()
having with two calls to complete_emulator_pio_in().  It will be fixed
in the next release.

While at it, remove the unused void* val argument of emulator_pio_in_out.
The function currently hardcodes vcpu->arch.pio_data as the
source/destination buffer, which sucks but will be fixed after the more
severe SEV-ES buffer overflow.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6907,7 +6907,7 @@ static int kernel_pio(struct kvm_vcpu *v
 }
 
 static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
-			       unsigned short port, void *val,
+			       unsigned short port,
 			       unsigned int count, bool in)
 {
 	vcpu->arch.pio.port = port;
@@ -6928,26 +6928,38 @@ static int emulator_pio_in_out(struct kv
 	return 0;
 }
 
-static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			   unsigned short port, void *val, unsigned int count)
+static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+			     unsigned short port, unsigned int count)
 {
-	int ret;
+	WARN_ON(vcpu->arch.pio.count);
+	memset(vcpu->arch.pio_data, 0, size * count);
+	return emulator_pio_in_out(vcpu, size, port, count, true);
+}
 
-	if (vcpu->arch.pio.count)
-		goto data_avail;
+static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+				    unsigned short port, void *val)
+{
+	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
+	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
+	vcpu->arch.pio.count = 0;
+}
 
-	memset(vcpu->arch.pio_data, 0, size * count);
+static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+			   unsigned short port, void *val, unsigned int count)
+{
+	if (vcpu->arch.pio.count) {
+		/* Complete previous iteration.  */
+	} else {
+		int r = __emulator_pio_in(vcpu, size, port, count);
+		if (!r)
+			return r;
 
-	ret = emulator_pio_in_out(vcpu, size, port, val, count, true);
-	if (ret) {
-data_avail:
-		memcpy(val, vcpu->arch.pio_data, size * count);
-		trace_kvm_pio(KVM_PIO_IN, port, size, count, vcpu->arch.pio_data);
-		vcpu->arch.pio.count = 0;
-		return 1;
+		/* Results already available, fall through.  */
 	}
 
-	return 0;
+	WARN_ON(count != vcpu->arch.pio.count);
+	complete_emulator_pio_in(vcpu, size, port, val);
+	return 1;
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -6966,12 +6978,11 @@ static int emulator_pio_out(struct kvm_v
 
 	memcpy(vcpu->arch.pio_data, val, size * count);
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
-	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
+	ret = emulator_pio_in_out(vcpu, size, port, count, false);
 	if (ret)
                 vcpu->arch.pio.count = 0;
 
         return ret;
-
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,


