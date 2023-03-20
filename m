Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743886C16D0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjCTPJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjCTPIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:08:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FE528E90
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD98C6159D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE7AC433EF;
        Mon, 20 Mar 2023 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324618;
        bh=LZx4q1lETWJHg3/WXlioNelaySs+Dkng3PDOHU9RfG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIfxhn5POZEM2GX1s77h+6YgVv4EOJTTBVObq2uEGJDNV3rIJbX076ucwCQD9bRy6
         QgMHpQtKLV7r0s76fVGWoIcfF1OXgwDcDZIk1ck2gpNlGNPW1kLr0SoWbidC70lfwO
         tQLvou+ou7/6Tcedyly75dVlgZ9G2pKC49eZV/a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/115] cifs: Move the in_send statistic to __smb_send_rqst()
Date:   Mon, 20 Mar 2023 15:53:35 +0100
Message-Id: <20230320145449.489095466@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit d0dc41119905f740e8d5594adce277f7c0de8c92 ]

When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
in_send statistic was lost.

Let's move the in_send statistic to the send function to avoid
this scenario.

Fixes: 7ee1af765dfa ("[CIFS]")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 514056605fa7a..49b7edbe34975 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -299,7 +299,7 @@ static int
 __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		struct smb_rqst *rqst)
 {
-	int rc = 0;
+	int rc;
 	struct kvec *iov;
 	int n_vec;
 	unsigned int send_length = 0;
@@ -310,6 +310,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
+	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
 		rc = -EAGAIN;
@@ -318,14 +319,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		goto smbd_done;
 	}
 
+	rc = -EAGAIN;
 	if (ssocket == NULL)
-		return -EAGAIN;
+		goto out;
 
+	rc = -ERESTARTSYS;
 	if (fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
-		return -ERESTARTSYS;
+		goto out;
 	}
 
+	rc = 0;
 	/* cork the socket */
 	tcp_sock_set_cork(ssocket->sk, true);
 
@@ -438,7 +442,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			 rc);
 	else if (rc > 0)
 		rc = 0;
-
+out:
+	cifs_in_send_dec(server);
 	return rc;
 }
 
@@ -855,9 +860,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(mid);
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, 1, rqst, flags);
-	cifs_in_send_dec(server);
 
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
@@ -1149,9 +1152,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			midQ[i]->callback = cifs_compound_last_callback;
 	}
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
-	cifs_in_send_dec(server);
 
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
@@ -1388,9 +1389,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -1527,9 +1526,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
-- 
2.39.2



