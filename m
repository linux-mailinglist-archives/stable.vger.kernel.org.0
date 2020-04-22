Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650231B3FB0
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgDVKjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbgDVKVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACCD42075A;
        Wed, 22 Apr 2020 10:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550874;
        bh=nW6ZITNHnrJvpwoENRnTK7zuEUJpfMTYYeAfMuYD/hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4JC0oZ3IYclzvLZFzhhOHhN4qcK0AG18ctXFAoI389izxEspbzutuHDXsInUucZu
         a+jWMgTvQFJq1mgtqHM/0+AHkjGuCVjwvVYcxrL2o6P6koWSMg+TTTf1zPMZG7UwxX
         7fMPX9e7fp4GzeVB+rGbg21Qc5L1H8Jq/BDipY00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.6 010/166] arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0
Date:   Wed, 22 Apr 2020 11:55:37 +0200
Message-Id: <20200422095049.307292453@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit bb9562cf5c67813034c96afb50bd21130a504441 upstream.

The current arm BPF JIT does not correctly compile RSH or ARSH when the
immediate shift amount is 0. This causes the "rsh64 by 0 imm" and "arsh64
by 0 imm" BPF selftests to hang the kernel by reaching an instruction
the verifier determines to be unreachable.

The root cause is in how immediate right shifts are encoded on arm.
For LSR and ASR (logical and arithmetic right shift), a bit-pattern
of 00000 in the immediate encodes a shift amount of 32. When the BPF
immediate is 0, the generated code shifts by 32 instead of the expected
behavior (a no-op).

This patch fixes the bugs by adding an additional check if the BPF
immediate is 0. After the change, the above mentioned BPF selftests pass.

Fixes: 39c13c204bb11 ("arm: eBPF JIT compiler")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200408181229.10909-1-luke.r.nels@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/net/bpf_jit_32.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -929,7 +929,11 @@ static inline void emit_a32_rsh_i64(cons
 	rd = arm_bpf_get_reg64(dst, tmp, ctx);
 
 	/* Do LSR operation */
-	if (val < 32) {
+	if (val == 0) {
+		/* An immediate value of 0 encodes a shift amount of 32
+		 * for LSR. To shift by 0, don't do anything.
+		 */
+	} else if (val < 32) {
 		emit(ARM_MOV_SI(tmp2[1], rd[1], SRTYPE_LSR, val), ctx);
 		emit(ARM_ORR_SI(rd[1], tmp2[1], rd[0], SRTYPE_ASL, 32 - val), ctx);
 		emit(ARM_MOV_SI(rd[0], rd[0], SRTYPE_LSR, val), ctx);
@@ -955,7 +959,11 @@ static inline void emit_a32_arsh_i64(con
 	rd = arm_bpf_get_reg64(dst, tmp, ctx);
 
 	/* Do ARSH operation */
-	if (val < 32) {
+	if (val == 0) {
+		/* An immediate value of 0 encodes a shift amount of 32
+		 * for ASR. To shift by 0, don't do anything.
+		 */
+	} else if (val < 32) {
 		emit(ARM_MOV_SI(tmp2[1], rd[1], SRTYPE_LSR, val), ctx);
 		emit(ARM_ORR_SI(rd[1], tmp2[1], rd[0], SRTYPE_ASL, 32 - val), ctx);
 		emit(ARM_MOV_SI(rd[0], rd[0], SRTYPE_ASR, val), ctx);


