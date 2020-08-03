Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C823A688
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgHCMsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727996AbgHCMYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F24720738;
        Mon,  3 Aug 2020 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457463;
        bh=CG5oTrDbM26ezVVrh+6VKhc8fQZjKbyO8JMPbOnvVKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Om4YTKKnMH7juZuVLVE+mgwzJ9n/ERc7QEdEttClw5fkUgqXLr8kWhymqZxxHBo1w
         8UHXUwKMz6eLdZzBkwBCiHtCmBjHhUtEqZAIfnRMVQEnBNRw0owEerXmSUnwuNrnRa
         ewM98D6nXHW6oA4ChR5ZkWKvw7l+4u2VdMCGHVB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cagney <cagney@libreswan.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 077/120] espintcp: handle short messages instead of breaking the encap socket
Date:   Mon,  3 Aug 2020 14:18:55 +0200
Message-Id: <20200803121906.574767719@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit fadd1a63a7b4df295a01fa50b2f4e447542bee59 ]

Currently, short messages (less than 4 bytes after the length header)
will break the stream of messages. This is unnecessary, since we can
still parse messages even if they're too short to contain any usable
data. This is also bogus, as keepalive messages (a single 0xff byte),
though not needed with TCP encapsulation, should be allowed.

This patch changes the stream parser so that short messages are
accepted and dropped in the kernel. Messages that contain a valid SPI
or non-ESP header are processed as before.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Andrew Cagney <cagney@libreswan.org>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/espintcp.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 024470fb2d856..19396f3655c05 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -41,9 +41,32 @@ static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	struct espintcp_ctx *ctx = container_of(strp, struct espintcp_ctx,
 						strp);
 	struct strp_msg *rxm = strp_msg(skb);
+	int len = rxm->full_len - 2;
 	u32 nonesp_marker;
 	int err;
 
+	/* keepalive packet? */
+	if (unlikely(len == 1)) {
+		u8 data;
+
+		err = skb_copy_bits(skb, rxm->offset + 2, &data, 1);
+		if (err < 0) {
+			kfree_skb(skb);
+			return;
+		}
+
+		if (data == 0xff) {
+			kfree_skb(skb);
+			return;
+		}
+	}
+
+	/* drop other short messages */
+	if (unlikely(len <= sizeof(nonesp_marker))) {
+		kfree_skb(skb);
+		return;
+	}
+
 	err = skb_copy_bits(skb, rxm->offset + 2, &nonesp_marker,
 			    sizeof(nonesp_marker));
 	if (err < 0) {
@@ -83,7 +106,7 @@ static int espintcp_parse(struct strparser *strp, struct sk_buff *skb)
 		return err;
 
 	len = be16_to_cpu(blen);
-	if (len < 6)
+	if (len < 2)
 		return -EINVAL;
 
 	return len;
-- 
2.25.1



