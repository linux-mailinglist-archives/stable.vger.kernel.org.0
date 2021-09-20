Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AEF4120A9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345233AbhITR4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355346AbhITRyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB9B661C48;
        Mon, 20 Sep 2021 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158025;
        bh=qSPVq1QYb/17JQhpAL26QqVNXC4IyuIV763pmjtzeQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+wwj8R3yB+9E6YBnh/Ez8jmmCkppb2ei1sFo7Sk9gYTkq2n/Z9OuCaRSOgwUgwY5
         dM0KtWKVuwI7zcY1hVuhO8johUhyssJouZ1Ik6yj0GZFeW+csqpi5gNr7zELI/xdwK
         csfjvkNN6zk98eMD3bax89UbCd7Pg7c5GJ/+D9LA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 261/293] net/l2tp: Fix reference count leak in l2tp_udp_recv_core
Date:   Mon, 20 Sep 2021 18:43:43 +0200
Message-Id: <20210920163942.327638881@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 9b6ff7eb666415e1558f1ba8a742f5db6a9954de upstream.

The reference count leak issue may take place in an error handling
path. If both conditions of tunnel->version == L2TP_HDR_VER_3 and the
return value of l2tp_v3_ensure_opt_in_linear is nonzero, the function
would directly jump to label invalid, without decrementing the reference
count of the l2tp_session object session increased earlier by
l2tp_tunnel_get_session(). This may result in refcount leaks.

Fix this issue by decrease the reference count before jumping to the
label invalid.

Fixes: 4522a70db7aa ("l2tp: fix reading optional fields of L2TPv3")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -889,8 +889,10 @@ static int l2tp_udp_recv_core(struct l2t
 	}
 
 	if (tunnel->version == L2TP_HDR_VER_3 &&
-	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
+	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr)) {
+		l2tp_session_dec_refcount(session);
 		goto error;
+	}
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length);
 	l2tp_session_dec_refcount(session);


