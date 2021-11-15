Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244D5451E5C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbhKPAfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344844AbhKOTZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65A58633E3;
        Mon, 15 Nov 2021 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003131;
        bh=Tn8u4nF7bDab+LpSuV856WOTCjSPFfJvp+G9i53U/bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsYyub1J6OkhIEu+4SdGG/KViHs96N+TZbceM/BtQt3vNL7i2ok6/PSihg5ClEpag
         qrsoVZ0g78t7vCeiwiQaG9YCDRB6HdiPLP0QUSl7qHG+k2sC/C7xPQcZ0cRlsRzbuM
         z50L4qVMPDQKNZw8XD5GsVimTxoXXqNH7f0ni1tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 823/917] bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding
Date:   Mon, 15 Nov 2021 18:05:18 +0100
Message-Id: <20211115165456.966958605@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit e0dc3b93bd7bcff8c3813d1df43e0908499c7cf0 ]

Strparser is reusing the qdisc_skb_cb struct to stash the skb message handling
progress, e.g. offset and length of the skb. First this is poorly named and
inherits a struct from qdisc that doesn't reflect the actual usage of cb[] at
this layer.

But, more importantly strparser is using the following to access its metadata.

  (struct _strp_msg *)((void *)skb->cb + offsetof(struct qdisc_skb_cb, data))

Where _strp_msg is defined as:

  struct _strp_msg {
        struct strp_msg            strp;                 /*     0     8 */
        int                        accum_len;            /*     8     4 */

        /* size: 12, cachelines: 1, members: 2 */
        /* last cacheline: 12 bytes */
  };

So we use 12 bytes of ->data[] in struct. However in BPF code running parser
and verdict the user has read capabilities into the data[] array as well. Its
not too problematic, but we should not be exposing internal state to BPF
program. If its really needed then we can use the probe_read() APIs which allow
reading kernel memory. And I don't believe cb[] layer poses any API breakage by
moving this around because programs can't depend on cb[] across layers.

In order to fix another issue with a ctx rewrite we need to stash a temp
variable somewhere. To make this work cleanly this patch builds a cb struct
for sk_skb types called sk_skb_cb struct. Then we can use this consistently
in the strparser, sockmap space. Additionally we can start allowing ->cb[]
write access after this.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jussi Maki <joamaki@gmail.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20211103204736.248403-5-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/strparser.h   | 16 +++++++++++++++-
 net/core/filter.c         | 22 ++++++++++++++++++++++
 net/strparser/strparser.c | 10 +---------
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index 1d20b98493a10..bec1439bd3be6 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -54,10 +54,24 @@ struct strp_msg {
 	int offset;
 };
 
+struct _strp_msg {
+	/* Internal cb structure. struct strp_msg must be first for passing
+	 * to upper layer.
+	 */
+	struct strp_msg strp;
+	int accum_len;
+};
+
+struct sk_skb_cb {
+#define SK_SKB_CB_PRIV_LEN 20
+	unsigned char data[SK_SKB_CB_PRIV_LEN];
+	struct _strp_msg strp;
+};
+
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
 {
 	return (struct strp_msg *)((void *)skb->cb +
-		offsetof(struct qdisc_skb_cb, data));
+		offsetof(struct sk_skb_cb, strp));
 }
 
 /* Structure for an attached lower socket */
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c4690..23a9bf92b5bb9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9761,11 +9761,33 @@ static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
 				     struct bpf_prog *prog, u32 *target_size)
 {
 	struct bpf_insn *insn = insn_buf;
+	int off;
 
 	switch (si->off) {
 	case offsetof(struct __sk_buff, data_end):
 		insn = bpf_convert_data_end_access(si, insn);
 		break;
+	case offsetof(struct __sk_buff, cb[0]) ...
+	     offsetofend(struct __sk_buff, cb[4]) - 1:
+		BUILD_BUG_ON(sizeof_field(struct sk_skb_cb, data) < 20);
+		BUILD_BUG_ON((offsetof(struct sk_buff, cb) +
+			      offsetof(struct sk_skb_cb, data)) %
+			     sizeof(__u64));
+
+		prog->cb_access = 1;
+		off  = si->off;
+		off -= offsetof(struct __sk_buff, cb[0]);
+		off += offsetof(struct sk_buff, cb);
+		off += offsetof(struct sk_skb_cb, data);
+		if (type == BPF_WRITE)
+			*insn++ = BPF_STX_MEM(BPF_SIZE(si->code), si->dst_reg,
+					      si->src_reg, off);
+		else
+			*insn++ = BPF_LDX_MEM(BPF_SIZE(si->code), si->dst_reg,
+					      si->src_reg, off);
+		break;
+
+
 	default:
 		return bpf_convert_ctx_access(type, si, insn_buf, prog,
 					      target_size);
diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index 9c0343568d2a0..1a72c67afed5e 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -27,18 +27,10 @@
 
 static struct workqueue_struct *strp_wq;
 
-struct _strp_msg {
-	/* Internal cb structure. struct strp_msg must be first for passing
-	 * to upper layer.
-	 */
-	struct strp_msg strp;
-	int accum_len;
-};
-
 static inline struct _strp_msg *_strp_msg(struct sk_buff *skb)
 {
 	return (struct _strp_msg *)((void *)skb->cb +
-		offsetof(struct qdisc_skb_cb, data));
+		offsetof(struct sk_skb_cb, strp));
 }
 
 /* Lower lock held */
-- 
2.33.0



