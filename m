Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1750E68D908
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjBGNPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjBGNPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:15:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74833BD91
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:14:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E90A56140D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE568C433EF;
        Tue,  7 Feb 2023 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775674;
        bh=jEIoTRgOzjgIaneIfD0c2qqBpwTDDmZO80CD6QZlwjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtY6tzOaqz9yCtO+IlMQ1SomFsteusDJpCfERKM9Bnrb7BLT5vcrrIjmMIoUh/n2U
         N9wRjhSW90ejKYKXEUazY+LbkWa8pZxNzyarz2lC7xtw96mQqJDma/2AwB/cXyiECw
         OfBw0iLhkOS46yTXAWp8uRHL6bJEuBcMVqv+P3ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com,
        Hao Sun <sunhao.th@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.15 120/120] bpf: Skip invalid kfunc call in backtrack_insn
Date:   Tue,  7 Feb 2023 13:58:11 +0100
Message-Id: <20230207125623.896876762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Sun <sunhao.th@gmail.com>

commit d3178e8a434b58678d99257c0387810a24042fb6 upstream.

The verifier skips invalid kfunc call in check_kfunc_call(), which
would be captured in fixup_kfunc_call() if such insn is not eliminated
by dead code elimination. However, this can lead to the following
warning in backtrack_insn(), also see [1]:

  ------------[ cut here ]------------
  verifier backtracking bug
  WARNING: CPU: 6 PID: 8646 at kernel/bpf/verifier.c:2756 backtrack_insn
  kernel/bpf/verifier.c:2756
	__mark_chain_precision kernel/bpf/verifier.c:3065
	mark_chain_precision kernel/bpf/verifier.c:3165
	adjust_reg_min_max_vals kernel/bpf/verifier.c:10715
	check_alu_op kernel/bpf/verifier.c:10928
	do_check kernel/bpf/verifier.c:13821 [inline]
	do_check_common kernel/bpf/verifier.c:16289
  [...]

So make backtracking conservative with this by returning ENOTSUPP.

  [1] https://lore.kernel.org/bpf/CACkBjsaXNceR8ZjkLG=dT3P=4A8SBsg0Z5h5PWLryF5=ghKq=g@mail.gmail.com/

Reported-by: syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20230104014709.9375-1-sunhao.th@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2261,6 +2261,12 @@ static int backtrack_insn(struct bpf_ver
 		if (opcode == BPF_CALL) {
 			if (insn->src_reg == BPF_PSEUDO_CALL)
 				return -ENOTSUPP;
+			/* kfunc with imm==0 is invalid and fixup_kfunc_call will
+			 * catch this error later. Make backtracking conservative
+			 * with ENOTSUPP.
+			 */
+			if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL && insn->imm == 0)
+				return -ENOTSUPP;
 			/* regular helper call sets R0 */
 			*reg_mask &= ~1;
 			if (*reg_mask & 0x3f) {


