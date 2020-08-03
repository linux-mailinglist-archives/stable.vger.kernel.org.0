Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BB623A5DA
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgHCMma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbgHCMbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:31:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C169E204EC;
        Mon,  3 Aug 2020 12:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457863;
        bh=x8SQ6fLnmFmHi/7O0TIoixVz2StNQj93pC7LpaYtCec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEUKfXjfXIrohnYXnRoqvaa7mxKFCc7JRjOFuWG9GQFa9erCy7JzG9joBRLkqw5VA
         QNmL2rXacWu7aAF+RUd6QHQRbmcEGtrGY92IxD2HNZtjZn1M1KD0o+Fq7DyMGM9lAl
         f2ViM4NQnf13qkeGEBKylWV+ZF+YIMgwOlHt7E6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/56] sctp: implement memory accounting on tx path
Date:   Mon,  3 Aug 2020 14:19:25 +0200
Message-Id: <20200803121850.821743926@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1033990ac5b2ab6cee93734cb6d301aa3a35bcaa ]

Now when sending packets, sk_mem_charge() and sk_mem_uncharge() have been
used to set sk_forward_alloc. We just need to call sk_wmem_schedule() to
check if the allocated should be raised, and call sk_mem_reclaim() to
check if the allocated should be reduced when it's under memory pressure.

If sk_wmem_schedule() returns false, which means no memory is allowed to
allocate, it will block and wait for memory to become available.

Note different from tcp, sctp wait_for_buf happens before allocating any
skb, so memory accounting check is done with the whole msg_len before it
too.

Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c93be3ba5df29..df4a7d7c5ec04 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1931,7 +1931,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (sctp_wspace(asoc) <= 0) {
+	if (sk_under_memory_pressure(sk))
+		sk_mem_reclaim(sk);
+
+	if (sctp_wspace(asoc) <= 0 || !sk_wmem_schedule(sk, msg_len)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
@@ -8515,7 +8518,10 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if ((int)msg_len <= sctp_wspace(asoc))
+		if (sk_under_memory_pressure(sk))
+			sk_mem_reclaim(sk);
+		if ((int)msg_len <= sctp_wspace(asoc) &&
+		    sk_wmem_schedule(sk, msg_len))
 			break;
 
 		/* Let another process have a go.  Since we are going
-- 
2.25.1



