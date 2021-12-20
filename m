Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3986047AC11
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhLTOlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbhLTOkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:40:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0CCC061376;
        Mon, 20 Dec 2021 06:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D04CECE0F8B;
        Mon, 20 Dec 2021 14:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ED0C36AE7;
        Mon, 20 Dec 2021 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011196;
        bh=48/jgRIBy02u66DWKKXNm7Dxh9MN79IBdPpos9alzCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3nii8r+Z503eRog01nFut92N+tpNf45dmiF0fy5to/U4X+T6FslI78M919OjG8/h
         XNIX4yLnD/3zQDjShAkwyeAWOcsmVgO+xyJg6xn3mueJwQ0m4rbTbYCs+RT1WyTADu
         gB/vBYRAs1l57wPPacAkqF3TWvfd33KNs6qc5wso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+709412e651e55ed96498@syzkaller.appspotmail.com,
        syzbot+54f39d6ab58f39720a55@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Connor OBrien <connoro@google.com>
Subject: [PATCH 4.14 08/45] bpf: fix panic due to oob in bpf_prog_test_run_skb
Date:   Mon, 20 Dec 2021 15:34:03 +0100
Message-Id: <20211220143022.544815365@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 6e6fddc78323533be570873abb728b7e0ba7e024 upstream.

sykzaller triggered several panics similar to the below:

  [...]
  [  248.851531] BUG: KASAN: use-after-free in _copy_to_user+0x5c/0x90
  [  248.857656] Read of size 985 at addr ffff8808017ffff2 by task a.out/1425
  [...]
  [  248.865902] CPU: 1 PID: 1425 Comm: a.out Not tainted 4.18.0-rc4+ #13
  [  248.865903] Hardware name: Supermicro SYS-5039MS-H12TRF/X11SSE-F, BIOS 2.1a 03/08/2018
  [  248.865905] Call Trace:
  [  248.865910]  dump_stack+0xd6/0x185
  [  248.865911]  ? show_regs_print_info+0xb/0xb
  [  248.865913]  ? printk+0x9c/0xc3
  [  248.865915]  ? kmsg_dump_rewind_nolock+0xe4/0xe4
  [  248.865919]  print_address_description+0x6f/0x270
  [  248.865920]  kasan_report+0x25b/0x380
  [  248.865922]  ? _copy_to_user+0x5c/0x90
  [  248.865924]  check_memory_region+0x137/0x190
  [  248.865925]  kasan_check_read+0x11/0x20
  [  248.865927]  _copy_to_user+0x5c/0x90
  [  248.865930]  bpf_test_finish.isra.8+0x4f/0xc0
  [  248.865932]  bpf_prog_test_run_skb+0x6a0/0xba0
  [...]

After scrubbing the BPF prog a bit from the noise, turns out it called
bpf_skb_change_head() for the lwt_xmit prog with headroom of 2. Nothing
wrong in that, however, this was run with repeat >> 0 in bpf_prog_test_run_skb()
and the same skb thus keeps changing until the pskb_expand_head() called
from skb_cow() keeps bailing out in atomic alloc context with -ENOMEM.
So upon return we'll basically have 0 headroom left yet blindly do the
__skb_push() of 14 bytes and keep copying data from there in bpf_test_finish()
out of bounds. Fix to check if we have enough headroom and if pskb_expand_head()
fails, bail out with error.

Another bug independent of this fix (but related in triggering above) is
that BPF_PROG_TEST_RUN should be reworked to reset the skb/xdp buffer to
it's original state from input as otherwise repeating the same test in a
loop won't work for benchmarking when underlying input buffer is getting
changed by the prog each time and reused for the next run leading to
unexpected results.

Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
Reported-by: syzbot+709412e651e55ed96498@syzkaller.appspotmail.com
Reported-by: syzbot+54f39d6ab58f39720a55@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[connoro: drop test_verifier.c changes not applicable to 4.14]
Signed-off-by: Connor O'Brien <connoro@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c                          |   17 ++++++++++++++---
 tools/testing/selftests/bpf/test_verifier.c |   18 ++++++++++++++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -96,6 +96,7 @@ int bpf_prog_test_run_skb(struct bpf_pro
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	u32 retval, duration;
+	int hh_len = ETH_HLEN;
 	struct sk_buff *skb;
 	void *data;
 	int ret;
@@ -131,12 +132,22 @@ int bpf_prog_test_run_skb(struct bpf_pro
 	skb_reset_network_header(skb);
 
 	if (is_l2)
-		__skb_push(skb, ETH_HLEN);
+		__skb_push(skb, hh_len);
 	if (is_direct_pkt_access)
 		bpf_compute_data_end(skb);
 	retval = bpf_test_run(prog, skb, repeat, &duration);
-	if (!is_l2)
-		__skb_push(skb, ETH_HLEN);
+	if (!is_l2) {
+		if (skb_headroom(skb) < hh_len) {
+			int nhead = HH_DATA_ALIGN(hh_len - skb_headroom(skb));
+
+			if (pskb_expand_head(skb, nhead, 0, GFP_USER)) {
+				kfree_skb(skb);
+				return -ENOMEM;
+			}
+		}
+		memset(__skb_push(skb, hh_len), 0, hh_len);
+	}
+
 	size = skb->len;
 	/* bpf program can never convert linear skb to non-linear */
 	if (WARN_ON_ONCE(skb_is_nonlinear(skb)))
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -4335,6 +4335,24 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_LWT_XMIT,
 	},
 	{
+		"make headroom for LWT_XMIT",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+			BPF_MOV64_IMM(BPF_REG_2, 34),
+			BPF_MOV64_IMM(BPF_REG_3, 0),
+			BPF_EMIT_CALL(BPF_FUNC_skb_change_head),
+			/* split for s390 to succeed */
+			BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+			BPF_MOV64_IMM(BPF_REG_2, 42),
+			BPF_MOV64_IMM(BPF_REG_3, 0),
+			BPF_EMIT_CALL(BPF_FUNC_skb_change_head),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.result = ACCEPT,
+		.prog_type = BPF_PROG_TYPE_LWT_XMIT,
+	},
+	{
 		"invalid access of tc_classid for LWT_IN",
 		.insns = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,


