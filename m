Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0349015C1E0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgBMP1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729360AbgBMP1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:19 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B75924676;
        Thu, 13 Feb 2020 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607638;
        bh=0Wyzm8prTXdxcC5qKMuthwEvTdxOmhJ2ohgnlYe8qGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgGmTP7QYcDr+iKJYS8Cb5W1FQBv+lIs6Oyffc+o+mD8c4xgef5SxQl7ZJSeN/SJo
         xfubhQYDFShLV0vYK3GafsBTIf6mys5BGVsXhbozMroVFMs/94hMS2vi8+WB+j6MAf
         d/69td3WSUSHonM56AltCOCeDKASifKlyjcffR3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 5.4 26/96] bpf, sockmap: Check update requirements after locking
Date:   Thu, 13 Feb 2020 07:20:33 -0800
Message-Id: <20200213151849.209731823@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit 85b8ac01a421791d66c3a458a7f83cfd173fe3fa upstream.

It's currently possible to insert sockets in unexpected states into
a sockmap, due to a TOCTTOU when updating the map from a syscall.
sock_map_update_elem checks that sk->sk_state == TCP_ESTABLISHED,
locks the socket and then calls sock_map_update_common. At this
point, the socket may have transitioned into another state, and
the earlier assumptions don't hold anymore. Crucially, it's
conceivable (though very unlikely) that a socket has become unhashed.
This breaks the sockmap's assumption that it will get a callback
via sk->sk_prot->unhash.

Fix this by checking the (fixed) sk_type and sk_protocol without the
lock, followed by a locked check of sk_state.

Unfortunately it's not possible to push the check down into
sock_(map|hash)_update_common, since BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB
run before the socket has transitioned from TCP_SYN_RECV into
TCP_ESTABLISHED.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20200207103713.28175-1-lmb@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/sock_map.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -417,14 +417,16 @@ static int sock_map_update_elem(struct b
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_map_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
 	sock_map_sk_acquire(sk);
-	ret = sock_map_update_common(map, idx, sk, flags);
+	if (sk->sk_state != TCP_ESTABLISHED)
+		ret = -EOPNOTSUPP;
+	else
+		ret = sock_map_update_common(map, idx, sk, flags);
 	sock_map_sk_release(sk);
 out:
 	fput(sock->file);
@@ -740,14 +742,16 @@ static int sock_hash_update_elem(struct
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_map_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
 	sock_map_sk_acquire(sk);
-	ret = sock_hash_update_common(map, key, sk, flags);
+	if (sk->sk_state != TCP_ESTABLISHED)
+		ret = -EOPNOTSUPP;
+	else
+		ret = sock_hash_update_common(map, key, sk, flags);
 	sock_map_sk_release(sk);
 out:
 	fput(sock->file);


