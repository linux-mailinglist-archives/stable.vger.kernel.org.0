Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB21A621F2
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbfGHPUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbfGHPUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC47A2182B;
        Mon,  8 Jul 2019 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599250;
        bh=lXgYJ88QjOuOoYufTSd5UBKHmsWzYrpuGVb1Luvt/P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHFKlfurHW1qWXoR0GEVYkFz7WDLzEjTEr5d6r3suORi7KzEOljVfUgmwq+kAnNV3
         6ad0vLDU1BTGVCWYXhT65uaeHjmEwVqamMBbxucr+BixB9LC8kuRnwEReWyYlRUXSm
         3Dn5hbfA63uD0B/wNrFjz/temhJt9RJ8scaLNO4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com,
        syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 054/102] sctp: change to hold sk after auth shkey is created successfully
Date:   Mon,  8 Jul 2019 17:12:47 +0200
Message-Id: <20190708150529.248380860@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 25bff6d5478b2a02368097015b7d8eb727c87e16 ]

Now in sctp_endpoint_init(), it holds the sk then creates auth
shkey. But when the creation fails, it doesn't release the sk,
which causes a sk defcnf leak,

Here to fix it by only holding the sk when auth shkey is created
successfully.

Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/endpointola.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -125,10 +125,6 @@ static struct sctp_endpoint *sctp_endpoi
 	/* Initialize the bind addr area */
 	sctp_bind_addr_init(&ep->base.bind_addr, 0);
 
-	/* Remember who we are attached to.  */
-	ep->base.sk = sk;
-	sock_hold(ep->base.sk);
-
 	/* Create the lists of associations.  */
 	INIT_LIST_HEAD(&ep->asocs);
 
@@ -165,6 +161,10 @@ static struct sctp_endpoint *sctp_endpoi
 	ep->auth_chunk_list = auth_chunks;
 	ep->prsctp_enable = net->sctp.prsctp_enable;
 
+	/* Remember who we are attached to.  */
+	ep->base.sk = sk;
+	sock_hold(ep->base.sk);
+
 	return ep;
 
 nomem_hmacs:


