Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C028A474ED5
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 01:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhLOADN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 19:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhLOADN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 19:03:13 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C858CC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 16:03:12 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 4-20020a621604000000b004a4ab765028so12567613pfw.13
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 16:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vwfM4mVFrBsuwBnok22oJftRQyunoO4FIfFqvCexbVU=;
        b=QRp3J2tt8xljPr+SzSf5+C+zKVKYvBwwgnFDtpuuALVuHRFCFb9IHMfoyT71gr4d5Y
         M3yvV+KPacK/AcTu/yDn5IM9HV0TTmfyAGlIEaa3ELnbBUfs1a6AY/TdJLWPzqLagpHo
         MtaWVMA+YSGCkmF55rPvSdZ3J9NLENx2/7eqqIDvGTQ75ndT73XFneLawX4y0dWmX9FZ
         UHaTvYl3j+xSmphg40ZrHqrNyI18tH1WbBSfV0XdmstDJmzAv2ZJVNVmQS1EWYgYtrvw
         8RENaIrPYtNaeXBY8lABw5hpmXn5j6QnG0BnDA4kM3E6ViozADEprsh9AH424bJhVEbv
         KJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vwfM4mVFrBsuwBnok22oJftRQyunoO4FIfFqvCexbVU=;
        b=dgB64rJyZQ26D/5cgdLiftdWSv+XV/UPiYYIzFTZ7tTLnvyPZfS0ei4o0/Wah3FN1F
         TWq6UQnwncLkNp8UWxsoE5hnpzDkW8nlq+mLIJJLTEiG0XxpOQ4NtzC+N/P2fFYziZK+
         kNzi9/wMpwPND4L/L2Udysak2M9pMFmMcK8TokmI81PMfof7TxeQxfgSMxC2RTD3m5tk
         pMaWSgBuqvGaA+J29Yp+zaKFVPywk+iG4CncqzfZQb4l+TpV24Zob8eid8chSGXjXkI3
         JSZiovwWgAzHSVWTEG87Gs94DNwRYDVsHRhnzBTdh2cNnnZxaeOk287sc185GmuTyxcI
         DW0Q==
X-Gm-Message-State: AOAM53103Bis9IT2luuiIgah/IPegPlslr8GAqwXDuXJy3p6bL/8IJn9
        uE3BtfLYjzDsUqGkUmsrLTggHvLZkhameJ2dAhGsDLCeIOC83kjm1mBiULjNtLgKPXcIFlAKH24
        TDKoUUwEYXKmOZMvx234ZkiTAPhJ1e0b8Ld7+U65ZtayRzrP2liAXbwXYM+LmubRW
X-Google-Smtp-Source: ABdhPJyKpsPc68Cr/LrTo9PQ11FKvszdZFQ0pCAlu2FbtzZxU1hg46bhd4KkcKAoTT/UrU3yIYLF5LGgPsKi
X-Received: from connoro.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:a99])
 (user=connoro job=sendgmr) by 2002:aa7:948b:0:b0:4b1:7b0:56ba with SMTP id
 z11-20020aa7948b000000b004b107b056bamr6536199pfk.54.1639526592139; Tue, 14
 Dec 2021 16:03:12 -0800 (PST)
Date:   Wed, 15 Dec 2021 00:03:10 +0000
Message-Id: <20211215000310.113753-1-connoro@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH] bpf: fix panic due to oob in bpf_prog_test_run_skb
From:   "Connor O'Brien" <connoro@google.com>
To:     stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "Connor O'Brien" <connoro@google.com>
Content-Type: text/plain; charset="UTF-8"
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
---
Hello,

This is a backport for the 4.14 stable tree.

Thanks,
Connor

 net/bpf/test_run.c                          | 17 ++++++++++++++---
 tools/testing/selftests/bpf/test_verifier.c | 18 ++++++++++++++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6be41a44d688..4f3c08583d8c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -96,6 +96,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	u32 retval, duration;
+	int hh_len = ETH_HLEN;
 	struct sk_buff *skb;
 	void *data;
 	int ret;
@@ -131,12 +132,22 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index d4f611546fc0..0846345fe1e5 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -4334,6 +4334,24 @@ static struct bpf_test tests[] = {
 		.result = ACCEPT,
 		.prog_type = BPF_PROG_TYPE_LWT_XMIT,
 	},
+	{
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
 	{
 		"invalid access of tc_classid for LWT_IN",
 		.insns = {
-- 
2.34.1.173.g76aa8bc2d0-goog

