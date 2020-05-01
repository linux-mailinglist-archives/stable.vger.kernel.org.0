Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518471C1568
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgEAN1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgEAN1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 527EE24955;
        Fri,  1 May 2020 13:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339620;
        bh=bFzTwxNpNnXKW5y0Ld8IcgIJN0YnBTHn+0HciPjoj/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gq37U9jn0X8hPrt/P8FkapXV4TX/9OmG5QBuRF23MsH3NlqbdghaFyV6xQ+ooDdw8
         8kkVF5z7eyMmQ8IpKNF+MLe9AdDFGdjrT1DrND+cUZZ+h05/YqtGNGBuw/SUNpR+Yi
         Wsa+16i+GybYYwnrMZaYVem0MKKEt0SsTzk+/7Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 55/70] sctp: use right member as the param of list_for_each_entry
Date:   Fri,  1 May 2020 15:21:43 +0200
Message-Id: <20200501131530.005417399@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit a8dd397903a6e57157f6265911f7d35681364427 upstream.

Commit d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues
when migrating a sock") made a mistake that using 'list' as the param of
list_for_each_entry to traverse the retransmit, sacked and abandoned
queues, while chunks are using 'transmitted_list' to link into these
queues.

It could cause NULL dereference panic if there are chunks in any of these
queues when peeling off one asoc.

So use the chunk member 'transmitted_list' instead in this patch.

Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sctp/socket.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -185,13 +185,13 @@ static void sctp_for_each_tx_datachunk(s
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
 			cb(chunk);
 
-	list_for_each_entry(chunk, &q->retransmit, list)
+	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
 		cb(chunk);
 
-	list_for_each_entry(chunk, &q->sacked, list)
+	list_for_each_entry(chunk, &q->sacked, transmitted_list)
 		cb(chunk);
 
-	list_for_each_entry(chunk, &q->abandoned, list)
+	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
 		cb(chunk);
 
 	list_for_each_entry(chunk, &q->out_chunk_list, list)


