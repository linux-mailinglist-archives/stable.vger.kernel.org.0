Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6AF278869
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgIYMzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729657AbgIYMzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:55:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B332072E;
        Fri, 25 Sep 2020 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038514;
        bh=/N8R8pe930A8Psal2Q5+o+U4C3yW6ZaKIoCVHjkSWmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goBLwTibJLlhfma+QkdqtxDLGmnhHKHK6l7PAu2SYsoZRoLHj9WVt/uh3uNoLEM51
         vmE162bYPxpN2TfNAVLiqG3Yt/ZZOwZVD8gZhXF8kyoE41OEmIEvz78DNzIEB54vQr
         jT/Pe7bc4fBQjORL2jD7w/+X2mMZsnHF8lB3lHLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        ChenNan Of Chaitin Security Research Lab 
        <whutchennan@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 07/37] hdlc_ppp: add range checks in ppp_cp_parse_cr()
Date:   Fri, 25 Sep 2020 14:48:35 +0200
Message-Id: <20200925124722.048612965@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 66d42ed8b25b64eb63111a2b8582c5afc8bf1105 ]

There are a couple bugs here:
1) If opt[1] is zero then this results in a forever loop.  If the value
   is less than 2 then it is invalid.
2) It assumes that "len" is more than sizeof(valid_accm) or 6 which can
   result in memory corruption.

In the case of LCP_OPTION_ACCM, then  we should check "opt[1]" instead
of "len" because, if "opt[1]" is less than sizeof(valid_accm) then
"nak_len" gets out of sync and it can lead to memory corruption in the
next iterations through the loop.  In case of LCP_OPTION_MAGIC, the
only valid value for opt[1] is 6, but the code is trying to log invalid
data so we should only discard the data when "len" is less than 6
because that leads to a read overflow.

Reported-by: ChenNan Of Chaitin Security Research Lab  <whutchennan@gmail.com>
Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/hdlc_ppp.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -386,11 +386,8 @@ static void ppp_cp_parse_cr(struct net_d
 	}
 
 	for (opt = data; len; len -= opt[1], opt += opt[1]) {
-		if (len < 2 || len < opt[1]) {
-			dev->stats.rx_errors++;
-			kfree(out);
-			return; /* bad packet, drop silently */
-		}
+		if (len < 2 || opt[1] < 2 || len < opt[1])
+			goto err_out;
 
 		if (pid == PID_LCP)
 			switch (opt[0]) {
@@ -398,6 +395,8 @@ static void ppp_cp_parse_cr(struct net_d
 				continue; /* MRU always OK and > 1500 bytes? */
 
 			case LCP_OPTION_ACCM: /* async control character map */
+				if (opt[1] < sizeof(valid_accm))
+					goto err_out;
 				if (!memcmp(opt, valid_accm,
 					    sizeof(valid_accm)))
 					continue;
@@ -409,6 +408,8 @@ static void ppp_cp_parse_cr(struct net_d
 				}
 				break;
 			case LCP_OPTION_MAGIC:
+				if (len < 6)
+					goto err_out;
 				if (opt[1] != 6 || (!opt[2] && !opt[3] &&
 						    !opt[4] && !opt[5]))
 					break; /* reject invalid magic number */
@@ -427,6 +428,11 @@ static void ppp_cp_parse_cr(struct net_d
 		ppp_cp_event(dev, pid, RCR_GOOD, CP_CONF_ACK, id, req_len, data);
 
 	kfree(out);
+	return;
+
+err_out:
+	dev->stats.rx_errors++;
+	kfree(out);
 }
 
 static int ppp_rx(struct sk_buff *skb)


