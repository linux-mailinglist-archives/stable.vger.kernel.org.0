Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF69451160
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243931AbhKOTGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:06:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243466AbhKOTC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20CED6336A;
        Mon, 15 Nov 2021 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000119;
        bh=GyYmGbkAXRTl1I03I/5AeZXYavZxW5PJcjlgh5DESnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmjnwJWuZbeAS2xY8RMggTIb6YJTm60j9e/IZxirpWHK3IZqw6LU50lqYBy9Uu6wY
         ufSfBy56D/FLkMa/F8OqsN67kNgEDGfK/astXIe3xv/bNJOOhhNo8nyxrakBK35Kb9
         Z80KeAoQ6rv/C9vTRZRmGjhev9Dwj1EKMEgQT46s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 545/849] skmsg: Lose offset info in sk_psock_skb_ingress
Date:   Mon, 15 Nov 2021 18:00:28 +0100
Message-Id: <20211115165438.698223318@linuxfoundation.org>
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 7303524e04af49a47991e19f895c3b8cdc3796c7 ]

If sockmap enable strparser, there are lose offset info in
sk_psock_skb_ingress(). If the length determined by parse_msg function is not
skb->len, the skb will be converted to sk_msg multiple times, and userspace
app will get the data multiple times.

Fix this by get the offset and length from strp_msg. And as Cong suggested,
add one bit in skb->_sk_redir to distinguish enable or disable strparser.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20211029141216.211899-1-liujian56@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 18 ++++++++++++++++--
 net/core/skmsg.c      | 43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14ab0c0bc9241..94e2a1f6e58db 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -508,8 +508,22 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 
 #if IS_ENABLED(CONFIG_NET_SOCK_MSG)
 
-/* We only have one bit so far. */
-#define BPF_F_PTR_MASK ~(BPF_F_INGRESS)
+#define BPF_F_STRPARSER	(1UL << 1)
+
+/* We only have two bits so far. */
+#define BPF_F_PTR_MASK ~(BPF_F_INGRESS | BPF_F_STRPARSER)
+
+static inline bool skb_bpf_strparser(const struct sk_buff *skb)
+{
+	unsigned long sk_redir = skb->_sk_redir;
+
+	return sk_redir & BPF_F_STRPARSER;
+}
+
+static inline void skb_bpf_set_strparser(struct sk_buff *skb)
+{
+	skb->_sk_redir |= BPF_F_STRPARSER;
+}
 
 static inline bool skb_bpf_ingress(const struct sk_buff *skb)
 {
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b289284..9701a1404ccb2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -494,6 +494,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
+					u32 off, u32 len,
 					struct sk_psock *psock,
 					struct sock *sk,
 					struct sk_msg *msg)
@@ -507,11 +508,11 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	 */
 	if (skb_linearize(skb))
 		return -EAGAIN;
-	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
+	num_sge = skb_to_sgvec(skb, msg->sg.data, off, len);
 	if (unlikely(num_sge < 0))
 		return num_sge;
 
-	copied = skb->len;
+	copied = len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
 	msg->sg.end = num_sge;
@@ -522,9 +523,11 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 	return copied;
 }
 
-static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb);
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
+				     u32 off, u32 len);
 
-static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
+static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
+				u32 off, u32 len)
 {
 	struct sock *sk = psock->sk;
 	struct sk_msg *msg;
@@ -535,7 +538,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * correctly.
 	 */
 	if (unlikely(skb->sk == sk))
-		return sk_psock_skb_ingress_self(psock, skb);
+		return sk_psock_skb_ingress_self(psock, skb, off, len);
 	msg = sk_psock_create_ingress_msg(sk, skb);
 	if (!msg)
 		return -EAGAIN;
@@ -547,7 +550,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	 * into user buffers.
 	 */
 	skb_set_owner_r(skb, sk);
-	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
 		kfree(msg);
 	return err;
@@ -557,7 +560,8 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
  * skb. In this case we do not need to check memory limits or skb_set_owner_r
  * because the skb is already accounted for here.
  */
-static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb)
+static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
+				     u32 off, u32 len)
 {
 	struct sk_msg *msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	struct sock *sk = psock->sk;
@@ -567,7 +571,7 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
 		return -EAGAIN;
 	sk_msg_init(msg);
 	skb_set_owner_r(skb, sk);
-	err = sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
+	err = sk_psock_skb_ingress_enqueue(skb, off, len, psock, sk, msg);
 	if (err < 0)
 		kfree(msg);
 	return err;
@@ -581,7 +585,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			return -EAGAIN;
 		return skb_send_sock(psock->sk, skb, off, len);
 	}
-	return sk_psock_skb_ingress(psock, skb);
+	return sk_psock_skb_ingress(psock, skb, off, len);
 }
 
 static void sk_psock_skb_state(struct sk_psock *psock,
@@ -624,6 +628,12 @@ static void sk_psock_backlog(struct work_struct *work)
 	while ((skb = skb_dequeue(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
+		if (skb_bpf_strparser(skb)) {
+			struct strp_msg *stm = strp_msg(skb);
+
+			off = stm->offset;
+			len = stm->full_len;
+		}
 start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
@@ -863,6 +873,7 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	 * return code, but then didn't set a redirect interface.
 	 */
 	if (unlikely(!sk_other)) {
+		skb_bpf_redirect_clear(skb);
 		sock_drop(from->sk, skb);
 		return -EIO;
 	}
@@ -930,6 +941,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 {
 	struct sock *sk_other;
 	int err = 0;
+	u32 len, off;
 
 	switch (verdict) {
 	case __SK_PASS:
@@ -937,6 +949,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		sk_other = psock->sk;
 		if (sock_flag(sk_other, SOCK_DEAD) ||
 		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
+			skb_bpf_redirect_clear(skb);
 			goto out_free;
 		}
 
@@ -949,7 +962,15 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		 * retrying later from workqueue.
 		 */
 		if (skb_queue_empty(&psock->ingress_skb)) {
-			err = sk_psock_skb_ingress_self(psock, skb);
+			len = skb->len;
+			off = 0;
+			if (skb_bpf_strparser(skb)) {
+				struct strp_msg *stm = strp_msg(skb);
+
+				off = stm->offset;
+				len = stm->full_len;
+			}
+			err = sk_psock_skb_ingress_self(psock, skb, off, len);
 		}
 		if (err < 0) {
 			spin_lock_bh(&psock->ingress_lock);
@@ -1015,6 +1036,8 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
+		if (ret == SK_PASS)
+			skb_bpf_set_strparser(skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-- 
2.33.0



