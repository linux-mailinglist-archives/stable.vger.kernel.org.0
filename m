Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BFA451298
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346962AbhKOTh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244901AbhKOTSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 024326342C;
        Mon, 15 Nov 2021 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000720;
        bh=YXG8FlXnmCiMIWi6EEdqpqFNEupLxdNoSVRYiwAWTv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgtTrbHVDxBzaO1bZW1FH9saa8HVVVfn1PQWEezy7tfGNVRTu2lYRNt5oaGJ1VwSP
         55uh7AlWHneziDYSojyg+V1STdwCIPpCPRwtSs6gXNtFZl4sJBJ/7W5XLlSV13HPS5
         abpRa+0OXBZ2UGuVMQ7UZvlJSrnX9Y9qKgK5NkUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 766/849] bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg
Date:   Mon, 15 Nov 2021 18:04:09 +0100
Message-Id: <20211115165446.176460427@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

[ Upstream commit b2c4618162ec615a15883a804cce7e27afecfa58 ]

The current conversion of skb->data_end reads like this:

  ; data_end = (void*)(long)skb->data_end;
   559: (79) r1 = *(u64 *)(r2 +200)   ; r1  = skb->data
   560: (61) r11 = *(u32 *)(r2 +112)  ; r11 = skb->len
   561: (0f) r1 += r11
   562: (61) r11 = *(u32 *)(r2 +116)
   563: (1f) r1 -= r11

But similar to the case in 84f44df664e9 ("bpf: sock_ops sk access may stomp
registers when dst_reg = src_reg"), the code will read an incorrect skb->len
when src == dst. In this case we end up generating this xlated code:

  ; data_end = (void*)(long)skb->data_end;
   559: (79) r1 = *(u64 *)(r1 +200)   ; r1  = skb->data
   560: (61) r11 = *(u32 *)(r1 +112)  ; r11 = (skb->data)->len
   561: (0f) r1 += r11
   562: (61) r11 = *(u32 *)(r1 +116)
   563: (1f) r1 -= r11

... where line 560 is the reading 4B of (skb->data + 112) instead of the
intended skb->len Here the skb pointer in r1 gets set to skb->data and the
later deref for skb->len ends up following skb->data instead of skb.

This fixes the issue similarly to the patch mentioned above by creating an
additional temporary variable and using to store the register when dst_reg =
src_reg. We name the variable bpf_temp_reg and place it in the cb context for
sk_skb. Then we restore from the temp to ensure nothing is lost.

Fixes: 16137b09a66f2 ("bpf: Compute data_end dynamically with JIT code")
Signed-off-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20211103204736.248403-6-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/strparser.h |  4 ++++
 net/core/filter.c       | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index bec1439bd3be6..732b7097d78e4 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -66,6 +66,10 @@ struct sk_skb_cb {
 #define SK_SKB_CB_PRIV_LEN 20
 	unsigned char data[SK_SKB_CB_PRIV_LEN];
 	struct _strp_msg strp;
+	/* temp_reg is a temporary register used for bpf_convert_data_end_access
+	 * when dst_reg == src_reg.
+	 */
+	u64 temp_reg;
 };
 
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
diff --git a/net/core/filter.c b/net/core/filter.c
index e0b0ff681e68d..58ec74f012930 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9655,22 +9655,46 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 static struct bpf_insn *bpf_convert_data_end_access(const struct bpf_insn *si,
 						    struct bpf_insn *insn)
 {
-	/* si->dst_reg = skb->data */
+	int reg;
+	int temp_reg_off = offsetof(struct sk_buff, cb) +
+			   offsetof(struct sk_skb_cb, temp_reg);
+
+	if (si->src_reg == si->dst_reg) {
+		/* We need an extra register, choose and save a register. */
+		reg = BPF_REG_9;
+		if (si->src_reg == reg || si->dst_reg == reg)
+			reg--;
+		if (si->src_reg == reg || si->dst_reg == reg)
+			reg--;
+		*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg, temp_reg_off);
+	} else {
+		reg = si->dst_reg;
+	}
+
+	/* reg = skb->data */
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data),
-			      si->dst_reg, si->src_reg,
+			      reg, si->src_reg,
 			      offsetof(struct sk_buff, data));
 	/* AX = skb->len */
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
 			      BPF_REG_AX, si->src_reg,
 			      offsetof(struct sk_buff, len));
-	/* si->dst_reg = skb->data + skb->len */
-	*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
+	/* reg = skb->data + skb->len */
+	*insn++ = BPF_ALU64_REG(BPF_ADD, reg, BPF_REG_AX);
 	/* AX = skb->data_len */
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data_len),
 			      BPF_REG_AX, si->src_reg,
 			      offsetof(struct sk_buff, data_len));
-	/* si->dst_reg = skb->data + skb->len - skb->data_len */
-	*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_AX);
+
+	/* reg = skb->data + skb->len - skb->data_len */
+	*insn++ = BPF_ALU64_REG(BPF_SUB, reg, BPF_REG_AX);
+
+	if (si->src_reg == si->dst_reg) {
+		/* Restore the saved register */
+		*insn++ = BPF_MOV64_REG(BPF_REG_AX, si->src_reg);
+		*insn++ = BPF_MOV64_REG(si->dst_reg, reg);
+		*insn++ = BPF_LDX_MEM(BPF_DW, reg, BPF_REG_AX, temp_reg_off);
+	}
 
 	return insn;
 }
-- 
2.33.0



