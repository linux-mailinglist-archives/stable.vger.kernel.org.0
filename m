Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146B368D90B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjBGNPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbjBGNPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:15:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1DE3C2A3
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B3A2CE1DA2
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887E8C433D2;
        Tue,  7 Feb 2023 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775685;
        bh=DwlcFkKoGLezM0ljw0M51wlhSRxHOwceXToLasPEvgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcGA1wolUaYyhTmzcFfiRC6F0v77LZZPbZdl43dkubqeJ/8B1H1umwQ/uUvNvuLXy
         u3LuN3xrGLXiHo1ZvLwzF/pVt9DENMRas4edifoiogMC19Y3++tIADpiv4uTMETE1m
         vByq8XigFy+efD2oy6jbRg93FhmoWFhXXPU472ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hengqi Chen <hengqi.chen@gmail.com>,
        Yonghong Song <yhs@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.15 110/120] bpf: Do not reject when the stack read size is different from the tracked scalar size
Date:   Tue,  7 Feb 2023 13:58:01 +0100
Message-Id: <20230207125623.455375398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

From: Martin KaFai Lau <kafai@fb.com>

commit f30d4968e9aee737e174fc97942af46cfb49b484 upstream.

Below is a simplified case from a report in bcc [0]:

  r4 = 20
  *(u32 *)(r10 -4) = r4
  *(u32 *)(r10 -8) = r4  /* r4 state is tracked */
  r4 = *(u64 *)(r10 -8)  /* Read more than the tracked 32bit scalar.
			  * verifier rejects as 'corrupted spill memory'.
			  */

After commit 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill"),
the 8-byte aligned 32bit spill is also tracked by the verifier and the
register state is stored.

However, if 8 bytes are read from the stack instead of the tracked 4 byte
scalar, then verifier currently rejects the program as "corrupted spill
memory". This patch fixes this case by allowing it to read but marks the
register as unknown.

Also note that, if the prog is trying to corrupt/leak an earlier spilled
pointer by spilling another <8 bytes register on top, this has already
been rejected in the check_stack_write_fixed_off().

  [0] https://github.com/iovisor/bcc/pull/3683

Fixes: 354e8f1970f8 ("bpf: Support <8-byte scalar spill and refill")
Reported-by: Hengqi Chen <hengqi.chen@gmail.com>
Reported-by: Yonghong Song <yhs@gmail.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211102064535.316018-1-kafai@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2930,9 +2930,12 @@ static int check_stack_read_fixed_off(st
 	reg = &reg_state->stack[spi].spilled_ptr;
 
 	if (is_spilled_reg(&reg_state->stack[spi])) {
-		if (size != BPF_REG_SIZE) {
-			u8 scalar_size = 0;
+		u8 spill_size = 1;
 
+		for (i = BPF_REG_SIZE - 1; i > 0 && stype[i - 1] == STACK_SPILL; i--)
+			spill_size++;
+
+		if (size != BPF_REG_SIZE || spill_size != BPF_REG_SIZE) {
 			if (reg->type != SCALAR_VALUE) {
 				verbose_linfo(env, env->insn_idx, "; ");
 				verbose(env, "invalid size of register fill\n");
@@ -2943,10 +2946,7 @@ static int check_stack_read_fixed_off(st
 			if (dst_regno < 0)
 				return 0;
 
-			for (i = BPF_REG_SIZE; i > 0 && stype[i - 1] == STACK_SPILL; i--)
-				scalar_size++;
-
-			if (!(off % BPF_REG_SIZE) && size == scalar_size) {
+			if (!(off % BPF_REG_SIZE) && size == spill_size) {
 				/* The earlier check_reg_arg() has decided the
 				 * subreg_def for this insn.  Save it first.
 				 */
@@ -2970,12 +2970,6 @@ static int check_stack_read_fixed_off(st
 			state->regs[dst_regno].live |= REG_LIVE_WRITTEN;
 			return 0;
 		}
-		for (i = 1; i < BPF_REG_SIZE; i++) {
-			if (stype[(slot - i) % BPF_REG_SIZE] != STACK_SPILL) {
-				verbose(env, "corrupted spill memory\n");
-				return -EACCES;
-			}
-		}
 
 		if (dst_regno >= 0) {
 			/* restore register state from stack */


