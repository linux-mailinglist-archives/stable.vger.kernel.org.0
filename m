Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384867F48E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390971AbfHBJa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390933AbfHBJaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:30:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE982182B;
        Fri,  2 Aug 2019 09:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738254;
        bh=EYH+wJq5Jh9eumxxBMFQEpp0HWPkNeHhXg02xGdpNlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp7JLMmlnEDYrTp2k04yJz1cjAeUeQqy9efArqPgNiFbILC5q75tqFuCF/5wWUh1V
         tUmikBRSAxLUA5PhPvHDzi7vqsE7vjOciuria08bkAs7Tk2/frrmY+FcLCem2EQatU
         KhLEit35WKribvqkzikky+Xa5U1DIbEwGFk+tVOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com,
        Jeremy Sowden <jeremy@azazel.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 015/158] af_key: fix leaks in key_pol_get_resp and dump_sp.
Date:   Fri,  2 Aug 2019 11:27:16 +0200
Message-Id: <20190802092206.551843224@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7c80eb1c7e2b8420477fbc998971d62a648035d9 ]

In both functions, if pfkey_xfrm_policy2msg failed we leaked the newly
allocated sk_buff.  Free it on error.

Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
Reported-by: syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 3ba903ff2bb0..36db179d848e 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2463,8 +2463,10 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
 		goto out;
 	}
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		goto out;
+	}
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = hdr->sadb_msg_version;
@@ -2717,8 +2719,10 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
 		return PTR_ERR(out_skb);
 
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		return err;
+	}
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = pfk->dump.msg_version;
-- 
2.20.1



