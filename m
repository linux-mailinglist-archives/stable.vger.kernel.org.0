Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5CB1D8673
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgERRqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730022AbgERRqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB5E20657;
        Mon, 18 May 2020 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823964;
        bh=JS5+hmvc0xkMPZIL1DRSWYsqF1q6mRp78PlRsc1ctZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glRrbu3UCHm0XqMTZIFx4k3L7/bFv9aYNLFqfNAWinVSqY+XwsHndiA2dce5IY6F+
         Shz6zPIy3zDP220KUqbnHka1bZszTMYHzZmbFBRxNG45gGLUGj4FcbdHaowcqd9YLa
         qTjpM3jpxkJv+x9xvpBRm9fg4MQ1Vo8yYB/nftZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 017/114] geneve: only configure or fill UDP_ZERO_CSUM6_RX/TX info when CONFIG_IPV6
Date:   Mon, 18 May 2020 19:35:49 +0200
Message-Id: <20200518173506.795255584@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit f9094b7603c011d27db7ba109e69881c72fa611d upstream.

Stefano pointed that configure or show UDP_ZERO_CSUM6_RX/TX info doesn't
make sense if we haven't enabled CONFIG_IPV6. Fix it by adding
if IS_ENABLED(CONFIG_IPV6) check.

Fixes: abe492b4f50c ("geneve: UDP checksum configuration via netlink")
Fixes: fd7eafd02121 ("geneve: fix fill_info when link down")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/geneve.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1369,21 +1369,33 @@ static int geneve_nl2info(struct nlattr
 	}
 
 	if (data[IFLA_GENEVE_UDP_ZERO_CSUM6_TX]) {
+#if IS_ENABLED(CONFIG_IPV6)
 		if (changelink) {
 			attrtype = IFLA_GENEVE_UDP_ZERO_CSUM6_TX;
 			goto change_notsup;
 		}
 		if (nla_get_u8(data[IFLA_GENEVE_UDP_ZERO_CSUM6_TX]))
 			info->key.tun_flags &= ~TUNNEL_CSUM;
+#else
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_UDP_ZERO_CSUM6_TX],
+				    "IPv6 support not enabled in the kernel");
+		return -EPFNOSUPPORT;
+#endif
 	}
 
 	if (data[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]) {
+#if IS_ENABLED(CONFIG_IPV6)
 		if (changelink) {
 			attrtype = IFLA_GENEVE_UDP_ZERO_CSUM6_RX;
 			goto change_notsup;
 		}
 		if (nla_get_u8(data[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]))
 			*use_udp6_rx_checksums = false;
+#else
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_UDP_ZERO_CSUM6_RX],
+				    "IPv6 support not enabled in the kernel");
+		return -EPFNOSUPPORT;
+#endif
 	}
 
 	return 0;
@@ -1559,11 +1571,13 @@ static int geneve_fill_info(struct sk_bu
 		goto nla_put_failure;
 
 	if (metadata && nla_put_flag(skb, IFLA_GENEVE_COLLECT_METADATA))
-			goto nla_put_failure;
+		goto nla_put_failure;
 
+#if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, IFLA_GENEVE_UDP_ZERO_CSUM6_RX,
 		       !geneve->use_udp6_rx_checksums))
 		goto nla_put_failure;
+#endif
 
 	return 0;
 


