Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0663579766
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390847AbfG2TwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390232AbfG2TwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:52:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56DB521655;
        Mon, 29 Jul 2019 19:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429926;
        bh=D+wHTJiRMiJ88ylMut11sxgu7HGtnJ59SmK4eK6b5+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFQY+4OV3TOVdJbjkC4pxBTCWmHJ92BVUgvxb2KW8zPHuYO0gQFKTJ+7in3Ha+bdt
         IY/udvUklcn0lLH/SQZY6viZlWeNP6XlDmouxPyKvsomSTyKpGJSzXZFU0mAAhCpQP
         CV7++LZOQIwsxAUytPghWlSHUVuKoXNpbT1BmnxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@oracle.com>,
        Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 140/215] rds: Accept peer connection reject messages due to incompatible version
Date:   Mon, 29 Jul 2019 21:22:16 +0200
Message-Id: <20190729190803.835561072@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c6166cfc9cd48e93d9176561e50b63cef4330d5 ]

Prior to
commit d021fabf525ff ("rds: rdma: add consumer reject")

function "rds_rdma_cm_event_handler_cmn" would always honor a rejected
connection attempt by issuing a "rds_conn_drop".

The commit mentioned above added a "break", eliminating
the "fallthrough" case and made the "rds_conn_drop" rather conditional:

Now it only happens if a "consumer defined" reject (i.e. "rdma_reject")
carries an integer-value of "1" inside "private_data":

  if (!conn)
    break;
    err = (int *)rdma_consumer_reject_data(cm_id, event, &len);
    if (!err || (err && ((*err) == RDS_RDMA_REJ_INCOMPAT))) {
      pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
              &conn->c_laddr, &conn->c_faddr);
              conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
              rds_conn_drop(conn);
    }
    rdsdebug("Connection rejected: %s\n",
             rdma_reject_msg(cm_id, event->status));
    break;
    /* FALLTHROUGH */
A number of issues are worth mentioning here:
   #1) Previous versions of the RDS code simply rejected a connection
       by calling "rdma_reject(cm_id, NULL, 0);"
       So the value of the payload in "private_data" will not be "1",
       but "0".

   #2) Now the code has become dependent on host byte order and sizing.
       If one peer is big-endian, the other is little-endian,
       or there's a difference in sizeof(int) (e.g. ILP64 vs LP64),
       the *err check does not work as intended.

   #3) There is no check for "len" to see if the data behind *err is even valid.
       Luckily, it appears that the "rdma_reject(cm_id, NULL, 0)" will always
       carry 148 bytes of zeroized payload.
       But that should probably not be relied upon here.

   #4) With the added "break;",
       we might as well drop the misleading "/* FALLTHROUGH */" comment.

This commit does _not_ address issue #2, as the sender would have to
agree on a byte order as well.

Here is the sequence of messages in this observed error-scenario:
   Host-A is pre-QoS changes (excluding the commit mentioned above)
   Host-B is post-QoS changes (including the commit mentioned above)

   #1 Host-B
      issues a connection request via function "rds_conn_path_transition"
      connection state transitions to "RDS_CONN_CONNECTING"

   #2 Host-A
      rejects the incompatible connection request (from #1)
      It does so by calling "rdma_reject(cm_id, NULL, 0);"

   #3 Host-B
      receives an "RDMA_CM_EVENT_REJECTED" event (from #2)
      But since the code is changed in the way described above,
      it won't drop the connection here, simply because "*err == 0".

   #4 Host-A
      issues a connection request

   #5 Host-B
      receives an "RDMA_CM_EVENT_CONNECT_REQUEST" event
      and ends up calling "rds_ib_cm_handle_connect".
      But since the state is already in "RDS_CONN_CONNECTING"
      (as of #1) it will end up issuing a "rdma_reject" without
      dropping the connection:
         if (rds_conn_state(conn) == RDS_CONN_CONNECTING) {
             /* Wait and see - our connect may still be succeeding */
             rds_ib_stats_inc(s_ib_connect_raced);
         }
         goto out;

   #6 Host-A
      receives an "RDMA_CM_EVENT_REJECTED" event (from #5),
      drops the connection and tries again (goto #4) until it gives up.

Tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/rdma_transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 46bce8389066..9db455d02255 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -112,7 +112,9 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		if (!conn)
 			break;
 		err = (int *)rdma_consumer_reject_data(cm_id, event, &len);
-		if (!err || (err && ((*err) == RDS_RDMA_REJ_INCOMPAT))) {
+		if (!err ||
+		    (err && len >= sizeof(*err) &&
+		     ((*err) <= RDS_RDMA_REJ_INCOMPAT))) {
 			pr_warn("RDS/RDMA: conn <%pI6c, %pI6c> rejected, dropping connection\n",
 				&conn->c_laddr, &conn->c_faddr);
 			conn->c_proposed_version = RDS_PROTOCOL_COMPAT_VERSION;
@@ -122,7 +124,6 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		rdsdebug("Connection rejected: %s\n",
 			 rdma_reject_msg(cm_id, event->status));
 		break;
-		/* FALLTHROUGH */
 	case RDMA_CM_EVENT_ADDR_ERROR:
 	case RDMA_CM_EVENT_ROUTE_ERROR:
 	case RDMA_CM_EVENT_CONNECT_ERROR:
-- 
2.20.1



