Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B67C91B6
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfJBTLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35768 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729295AbfJBTIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:15 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyu-00035x-EP; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003gR-Dh; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Neil Horman" <nhorman@redhat.com>,
        "Xin Long" <lucien.xin@gmail.com>,
        syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.95333315@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 82/87] sctp: change to hold sk after auth shkey is
 created successfully
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit 25bff6d5478b2a02368097015b7d8eb727c87e16 upstream.

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/endpointola.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -126,10 +126,6 @@ static struct sctp_endpoint *sctp_endpoi
 	/* Initialize the bind addr area */
 	sctp_bind_addr_init(&ep->base.bind_addr, 0);
 
-	/* Remember who we are attached to.  */
-	ep->base.sk = sk;
-	sock_hold(ep->base.sk);
-
 	/* Create the lists of associations.  */
 	INIT_LIST_HEAD(&ep->asocs);
 
@@ -165,6 +161,10 @@ static struct sctp_endpoint *sctp_endpoi
 	ep->auth_hmacs_list = auth_hmacs;
 	ep->auth_chunk_list = auth_chunks;
 
+	/* Remember who we are attached to.  */
+	ep->base.sk = sk;
+	sock_hold(ep->base.sk);
+
 	return ep;
 
 nomem_hmacs:

