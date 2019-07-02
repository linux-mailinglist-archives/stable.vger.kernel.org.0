Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CADF5CB21
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfGBIK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbfGBIKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:10:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118C320665;
        Tue,  2 Jul 2019 08:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562055018;
        bh=M8uNbf5C5Dv07j5Z0jsDVLzZ4LOS6A5mloiQFrU7MXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVxOG4tSuDET+y5c0c/mTM928jiopGknvBr5m///qvHK5lI2AFj4d6HnlgQ1mYuZ1
         c/8HSm5gwxHB71D9fPN/ZMSWjrll5gJOm0teyAc9wBOrs9qIR/RieniPkZXdFw5JUP
         Rc3QLeTyxGRBRHxCCtbup2TlerksGfv55AYtSb+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Craig Gallek <kraig@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 39/43] bpf: udp: ipv6: Avoid running reuseports bpf_prog from __udp6_lib_err
Date:   Tue,  2 Jul 2019 10:02:19 +0200
Message-Id: <20190702080125.937515818@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

commit 4ac30c4b3659efac031818c418beb51e630d512d upstream.

__udp6_lib_err() may be called when handling icmpv6 message. For example,
the icmpv6 toobig(type=2).  __udp6_lib_lookup() is then called
which may call reuseport_select_sock().  reuseport_select_sock() will
call into a bpf_prog (if there is one).

reuseport_select_sock() is expecting the skb->data pointing to the
transport header (udphdr in this case).  For example, run_bpf_filter()
is pulling the transport header.

However, in the __udp6_lib_err() path, the skb->data is pointing to the
ipv6hdr instead of the udphdr.

One option is to pull and push the ipv6hdr in __udp6_lib_err().
Instead of doing this, this patch follows how the original
commit 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF")
was done in IPv4, which has passed a NULL skb pointer to
reuseport_select_sock().

Fixes: 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF")
Cc: Craig Gallek <kraig@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Craig Gallek <kraig@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -506,7 +506,7 @@ void __udp6_lib_err(struct sk_buff *skb,
 	struct net *net = dev_net(skb->dev);
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
-			       inet6_iif(skb), 0, udptable, skb);
+			       inet6_iif(skb), 0, udptable, NULL);
 	if (!sk) {
 		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev),
 				  ICMP6_MIB_INERRORS);


