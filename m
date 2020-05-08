Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4236A1CAF46
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgEHNQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgEHMo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20282145D;
        Fri,  8 May 2020 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941897;
        bh=RcBs7OXOISL3/zxdhrJ/BCk5YFJhN/ifvMWPZ3AI0WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMBvHif1T1+m/Y1HxZYx0SxwzuHU93rf0cFIAMFANG69XZgqoS7PT4j0/nBmVh3vW
         MJa0+bG4VdLjqW6IVnweMVqlg6LobaQgfFxxU3U9glev4i8tRP47cWzwvVnvE7Cxy2
         ZXdV5HlierlxBqokbYcCG8gbJMk4GsJhqq3P8+CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 189/312] ipv4: fix checksum annotation in udp4_csum_init
Date:   Fri,  8 May 2020 14:33:00 +0200
Message-Id: <20200508123137.760014097@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit b46d9f625b07f843c706c2c7d0210a90ccdf143b upstream.

Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tom Herbert <tom@herbertland.com>
Fixes: 4068579e1e098fa ("net: Implmement RFC 6936 (zero RX csums for UDP/IPv6")
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/udp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1754,8 +1754,11 @@ static inline int udp4_csum_init(struct
 		}
 	}
 
-	return skb_checksum_init_zero_check(skb, proto, uh->check,
-					    inet_compute_pseudo);
+	/* Note, we are only interested in != 0 or == 0, thus the
+	 * force to int.
+	 */
+	return (__force int)skb_checksum_init_zero_check(skb, proto, uh->check,
+							 inet_compute_pseudo);
 }
 
 /*


