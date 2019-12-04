Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3881133F7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfLDSVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730162AbfLDSH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:27 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A0C120675;
        Wed,  4 Dec 2019 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482847;
        bh=em/d8aYF1bMtjXSLVU4kj2JcBOP0Eed2tRCO1S+7JDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bukLjOdVPzrVA3NsJkT+23QIR14Cuv64vUMuHOSI+1Qp894+Hx+8GkSghbTUDY37z
         OKay1JR9NO8ihUt75MwD/fiAFqOt7X5VouPHJCO2Axfv64Vv2zcs8jcwNRQhuCv0x8
         w/9hZ54XrUXnJqgaisBcCnJUBUPq3RLnoF96ke6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Stojek <marcin.stojek@nokia.com>,
        Maciej Kwiecien <maciej.kwiecien@nokia.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/209] sctp: dont compare hb_timer expire date before starting it
Date:   Wed,  4 Dec 2019 18:55:53 +0100
Message-Id: <20191204175333.019542367@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Kwiecien <maciej.kwiecien@nokia.com>

[ Upstream commit d1f20c03f48102e52eb98b8651d129b83134cae4 ]

hb_timer might not start at all for a particular transport because its
start is conditional. In a result a node is not sending heartbeats.

Function sctp_transport_reset_hb_timer has two roles:
    - initial start of hb_timer for a given transport,
    - update expire date of hb_timer for a given transport.
The function is optimized to update timer's expire only if it is before
a new calculated one but this comparison is invalid for a timer which
has not yet started. Such a timer has expire == 0 and if a new expire
value is bigger than (MAX_JIFFIES / 2 + 2) then "time_before" macro will
fail and timer will not start resulting in no heartbeat packets send by
the node.

This was found when association was initialized within first 5 mins
after system boot due to jiffies init value which is near to MAX_JIFFIES.

Test kernel version: 4.9.154 (ARCH=arm)
hb_timer.expire = 0;                //initialized, not started timer
new_expire = MAX_JIFFIES / 2 + 2;   //or more
time_before(hb_timer.expire, new_expire) == false

Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
Reported-by: Marcin Stojek <marcin.stojek@nokia.com>
Tested-by: Marcin Stojek <marcin.stojek@nokia.com>
Signed-off-by: Maciej Kwiecien <maciej.kwiecien@nokia.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 43105cf04bc45..274df899e7bfa 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -210,7 +210,8 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if (time_before(transport->hb_timer.expires, expires) &&
+	if ((time_before(transport->hb_timer.expires, expires) ||
+	     !timer_pending(&transport->hb_timer)) &&
 	    !mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
-- 
2.20.1



