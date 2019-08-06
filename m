Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B0834BE
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbfHFPJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:09:42 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43101 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFPJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:09:42 -0400
Received: by mail-ed1-f66.google.com with SMTP id e3so82625245edr.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 08:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0KRXkc5Spl8OZB4lKafjVku3bAnCDm0qJrnAs6tQRg4=;
        b=DF5oXDqDMDUs3QX131GnVNDkTXrOIz7JlraffnzcvbhL4q4rqWX7GncztDGx4j/8L1
         6npbqW0UG56gTTggwMH2N0zgMYipDnbvu9yb5tL9fb260OcwfxwxtNnAdiK+s5aNhhf5
         TPkRBQrFP9O4Y4w/AylFK1yGotITdDTjQo6d2XYvdLq2x1HV+KlWYXQubirvqdxg9RAB
         y+wg/95snfP+BFYXe7oAHkx/BXTTW09EkSbJa98GKiDlnBfZFoWmHWt2AycQ0l0B4sy4
         pIE8MSN96ezD1OiTSL253Vr7bupyvdusH7FtztNEqk6YcSExg9dvdw3d76iqcRomw8lF
         oUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0KRXkc5Spl8OZB4lKafjVku3bAnCDm0qJrnAs6tQRg4=;
        b=pKs2mJXNgx0C6n5GbSBbohTG+qWS9JW+3/WbwMKfg0KwTCNjmEPfmNisfnAlS8jSMx
         mecZ0uHuLxNbv1JDJjagWbhUgwPDXGR5YLKDf/oCfkhHg28grW4STEOfmQOwT9mSp/ow
         jnAm8uBs9UBJFPFhnqn7F01CK4r96tjkYX3ItncxzKoUoIo9uN+aHcMiGlYMiikS+PjU
         3ko9UQa9PoZWXB36bvgC8Hncwn51/7tQz4stXupSqiG7KTSqDMOL7JZJFH9Kklk9/oiH
         IaNtFBF96FYmSlC4NWUjSMV+v83LDmSChNLFbk+ZAZlVmAxP0jdHtJC5fZMK93Ze0U4n
         3hOw==
X-Gm-Message-State: APjAAAUA0w62hooftRxT72TSd1F6P+hQfgMxk5uiiBg9ds+Zie0nk5BH
        a/prMcPaezAX4KY/uqU6HAorrFi+7TxxRQ==
X-Google-Smtp-Source: APXvYqwn02LehkWcB68XjuB+LA8ZvaTd2ehTi4UY5zfbf0z1jpfrcVaVY+N9oj5/NrPn3KMpLfVQHQ==
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr4255512edv.11.1565104179996;
        Tue, 06 Aug 2019 08:09:39 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id w35sm20663750edd.32.2019.08.06.08.09.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 08:09:38 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Eric Dumazet <edumazet@google.com>,
        Andrew Prout <aprout@ll.mit.edu>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jonathan Looney <jtl@netflix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH] tcp: be more careful in tcp_fragment()
Date:   Tue,  6 Aug 2019 17:09:14 +0200
Message-Id: <20190806150914.8797-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
References: <CANn89iKr7vYoLD_o-zhR72rQ8a4OQr=VW6oVRCYBDi1kmN6=dg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b617158dc096709d8600c53b6052144d12b89fab upstream.

Some applications set tiny SO_SNDBUF values and expect
TCP to just work. Recent patches to address CVE-2019-11478
broke them in case of losses, since retransmits might
be prevented.

We should allow these flows to make progress.

This patch allows the first and last skb in retransmit queue
to be split even if memory limits are hit.

It also adds the some room due to the fact that tcp_sendmsg()
and tcp_sendpage() might overshoot sk_wmem_queued by about one full
TSO skb (64KB size). Note this allowance was already present
in stable backports for kernels < 4.15

Note for < 4.15 backports :
 tcp_rtx_queue_tail() will probably look like :

static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
{
	struct sk_buff *skb = tcp_send_head(sk);

	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
}

Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Andrew Prout <aprout@ll.mit.edu>
Tested-by: Andrew Prout <aprout@ll.mit.edu>
Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Tested-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Christoph Paasch <cpaasch@apple.com>
Cc: Jonathan Looney <jtl@netflix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---

Notes:
    Hello,
    
    Here is the backport for linux-4.14.y branch simply by implementing
    functions written by Eric here in the commit message and in this email
    thread. It might be valid for older versions, I didn't check.
    
    In my setup with MPTCP, I had the same bug other had where TCP flows
    were stalled. The initial fix b6653b3629e5 (tcp: refine memory limit
    test in tcp_fragment()) from Eric was helping but the backport in
    < 4.15 was not looking safe: 1bc13903773b (tcp: refine memory limit
    test in tcp_fragment()).
    
    I then decided to test the new fix and it is working fine in my test
    environment, no stalled TCP flows in a few hours.
    
    In this email thread I see that Eric will push a patch for v4.14. I
    absolutely do not want to add pressure or steal his work but because I
    have the patch here and it is tested, I was thinking it could be a good
    idea to share it with others. Feel free to ignore this patch if needed.
    But if this patch can reduce a tiny bit Eric's workload, I would be
    very glad if it helps :)
    Because at the end, it is Eric's work, feel free to change my
    "Signed-off-by" by "Tested-By" if it is how it work or nothing if you
    prefer to wait for Eric's patch.
    
    Cheers,
    Matt

 include/net/tcp.h     | 17 +++++++++++++++++
 net/ipv4/tcp_output.c | 11 ++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0b477a1e1177..7994e569644e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1688,6 +1688,23 @@ static inline void tcp_check_send_head(struct sock *sk, struct sk_buff *skb_unli
 		tcp_sk(sk)->highest_sack = NULL;
 }
 
+static inline struct sk_buff *tcp_rtx_queue_head(const struct sock *sk)
+{
+	struct sk_buff *skb = tcp_write_queue_head(sk);
+
+	if (skb == tcp_send_head(sk))
+		skb = NULL;
+
+	return skb;
+}
+
+static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
+{
+	struct sk_buff *skb = tcp_send_head(sk);
+
+	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
+}
+
 static inline void __tcp_add_write_queue_tail(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_queue_tail(&sk->sk_write_queue, skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a5960b9b6741..a99086bf26ea 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1264,6 +1264,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
 	int nsize, old_factor;
+	long limit;
 	int nlen;
 	u8 flags;
 
@@ -1274,7 +1275,15 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
+	/* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
+	 * We need some allowance to not penalize applications setting small
+	 * SO_SNDBUF values.
+	 * Also allow first and last skb in retransmit queue to be split.
+	 */
+	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
+	if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
+		     skb != tcp_rtx_queue_head(sk) &&
+		     skb != tcp_rtx_queue_tail(sk))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
-- 
2.20.1

