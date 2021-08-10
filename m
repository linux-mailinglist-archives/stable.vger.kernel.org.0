Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055663E823A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbhHJSGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39803 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238030AbhHJSDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E056140A;
        Tue, 10 Aug 2021 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617675;
        bh=pkLd3vYHaCyyw7w8YG3IbB20GwhjgQULNI4nMHqedAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3OEpIQq0LxA9kEWszg/RbEft1ATszFTm4xHVnVJUnRKAtbgKWaIHlT8Zpwg1e4iT
         1fdr6DaX7Uq72oyg2Kl5CAaQUVmyGAI6O/eZOkp2FCFkYdG109Z1fDkfnxBR9bHoxF
         4t0cd4ACFWifEaRuizVth2YLkfXmbUyscF2Lw7kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.13 136/175] net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
Date:   Tue, 10 Aug 2021 19:30:44 +0200
Message-Id: <20210810173005.418432501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

commit 4e9505064f58d1252805952f8547a5b7dbc5c111 upstream.

The attribute-translator has to take in mind maxtype, that is
xfrm_link::nla_max. When it is set, attributes are not of xfrm_attr_type_t.
Currently, they can be only XFRMA_SPD_MAX (message XFRM_MSG_NEWSPDINFO),
their UABI is the same for 64/32-bit, so just copy them.

Thanks to YueHaibing for reporting this:
In xfrm_user_rcv_msg_compat() if maxtype is not zero and less than
XFRMA_MAX, nlmsg_parse_deprecated() do not initialize attrs array fully.
xfrm_xlate32() will access uninit 'attrs[i]' while iterating all attrs
array.

KASAN: probably user-memory-access in range [0x0000000041b58ab0-0x0000000041b58ab7]
CPU: 0 PID: 15799 Comm: syz-executor.2 Tainted: G        W         5.14.0-rc1-syzkaller #0
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:410 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:532 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:577
[...]
Call Trace:
 xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:702 [inline]

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Cc: <stable@kernel.org>
Reported-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_compat.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -298,8 +298,16 @@ static int xfrm_xlate64(struct sk_buff *
 	len = nlmsg_attrlen(nlh_src, xfrm_msg_min[type]);
 
 	nla_for_each_attr(nla, attrs, len, remaining) {
-		int err = xfrm_xlate64_attr(dst, nla);
+		int err;
 
+		switch (type) {
+		case XFRM_MSG_NEWSPDINFO:
+			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
+			break;
+		default:
+			err = xfrm_xlate64_attr(dst, nla);
+			break;
+		}
 		if (err)
 			return err;
 	}
@@ -341,7 +349,8 @@ static int xfrm_alloc_compat(struct sk_b
 
 /* Calculates len of translated 64-bit message. */
 static size_t xfrm_user_rcv_calculate_len64(const struct nlmsghdr *src,
-					    struct nlattr *attrs[XFRMA_MAX+1])
+					    struct nlattr *attrs[XFRMA_MAX + 1],
+					    int maxtype)
 {
 	size_t len = nlmsg_len(src);
 
@@ -358,10 +367,20 @@ static size_t xfrm_user_rcv_calculate_le
 	case XFRM_MSG_POLEXPIRE:
 		len += 8;
 		break;
+	case XFRM_MSG_NEWSPDINFO:
+		/* attirbutes are xfrm_spdattr_type_t, not xfrm_attr_type_t */
+		return len;
 	default:
 		break;
 	}
 
+	/* Unexpected for anything, but XFRM_MSG_NEWSPDINFO, please
+	 * correct both 64=>32-bit and 32=>64-bit translators to copy
+	 * new attributes.
+	 */
+	if (WARN_ON_ONCE(maxtype))
+		return len;
+
 	if (attrs[XFRMA_SA])
 		len += 4;
 	if (attrs[XFRMA_POLICY])
@@ -440,7 +459,8 @@ static int xfrm_xlate32_attr(void *dst,
 
 static int xfrm_xlate32(struct nlmsghdr *dst, const struct nlmsghdr *src,
 			struct nlattr *attrs[XFRMA_MAX+1],
-			size_t size, u8 type, struct netlink_ext_ack *extack)
+			size_t size, u8 type, int maxtype,
+			struct netlink_ext_ack *extack)
 {
 	size_t pos;
 	int i;
@@ -520,6 +540,25 @@ static int xfrm_xlate32(struct nlmsghdr
 	}
 	pos = dst->nlmsg_len;
 
+	if (maxtype) {
+		/* attirbutes are xfrm_spdattr_type_t, not xfrm_attr_type_t */
+		WARN_ON_ONCE(src->nlmsg_type != XFRM_MSG_NEWSPDINFO);
+
+		for (i = 1; i <= maxtype; i++) {
+			int err;
+
+			if (!attrs[i])
+				continue;
+
+			/* just copy - no need for translation */
+			err = xfrm_attr_cpy32(dst, &pos, attrs[i], size,
+					nla_len(attrs[i]), nla_len(attrs[i]));
+			if (err)
+				return err;
+		}
+		return 0;
+	}
+
 	for (i = 1; i < XFRMA_MAX + 1; i++) {
 		int err;
 
@@ -564,7 +603,7 @@ static struct nlmsghdr *xfrm_user_rcv_ms
 	if (err < 0)
 		return ERR_PTR(err);
 
-	len = xfrm_user_rcv_calculate_len64(h32, attrs);
+	len = xfrm_user_rcv_calculate_len64(h32, attrs, maxtype);
 	/* The message doesn't need translation */
 	if (len == nlmsg_len(h32))
 		return NULL;
@@ -574,7 +613,7 @@ static struct nlmsghdr *xfrm_user_rcv_ms
 	if (!h64)
 		return ERR_PTR(-ENOMEM);
 
-	err = xfrm_xlate32(h64, h32, attrs, len, type, extack);
+	err = xfrm_xlate32(h64, h32, attrs, len, type, maxtype, extack);
 	if (err < 0) {
 		kvfree(h64);
 		return ERR_PTR(err);


