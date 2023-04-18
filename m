Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BD06E61C4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjDRM1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbjDRM1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC4086BB
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA2A6312F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AECC433EF;
        Tue, 18 Apr 2023 12:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820815;
        bh=rQYlSIxqehrDt52A5nAqDsy53H5yVR6Qf6pYOPCY6AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOspSMndoSCaqzRznNuAZBW7GXpSLIVn8ZJ8QhTAkiglpems0n40y3x3jcz3xq8ol
         ExxLeqveaiRFAUFwQJsY0jn4jerdtEiYl7kO+Ng0301sHUFjC+Zt1OTK5U+bT/2zLr
         e64Pq3rlEQWts79kwK3by6Ap4Pzt4EYLajvSAiPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/57] sctp: check send stream number after wait_for_sndbuf
Date:   Tue, 18 Apr 2023 14:21:12 +0200
Message-Id: <20230418120259.144598769@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2584024b23552c00d95b50255e47bd18d306d31a ]

This patch fixes a corner case where the asoc out stream count may change
after wait_for_sndbuf.

When the main thread in the client starts a connection, if its out stream
count is set to N while the in stream count in the server is set to N - 2,
another thread in the client keeps sending the msgs with stream number
N - 1, and waits for sndbuf before processing INIT_ACK.

However, after processing INIT_ACK, the out stream count in the client is
shrunk to N - 2, the same to the in stream count in the server. The crash
occurs when the thread waiting for sndbuf is awake and sends the msg in a
non-existing stream(N - 1), the call trace is as below:

  KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
  Call Trace:
   <TASK>
   sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1114 [inline]
   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1777 [inline]
   sctp_side_effects net/sctp/sm_sideeffect.c:1199 [inline]
   sctp_do_sm+0x197d/0x5310 net/sctp/sm_sideeffect.c:1170
   sctp_primitive_SEND+0x9f/0xc0 net/sctp/primitive.c:163
   sctp_sendmsg_to_asoc+0x10eb/0x1a30 net/sctp/socket.c:1868
   sctp_sendmsg+0x8d4/0x1d90 net/sctp/socket.c:2026
   inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:825
   sock_sendmsg_nosec net/socket.c:722 [inline]
   sock_sendmsg+0xde/0x190 net/socket.c:745

The fix is to add an unlikely check for the send stream number after the
thread wakes up from the wait_for_sndbuf.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: syzbot+47c24ca20a2fa01f082e@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8901bb7afa2be..355b89579e930 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1953,6 +1953,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
 			goto err;
+		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
+			err = -EINVAL;
+			goto err;
+		}
 	}
 
 	if (sctp_state(asoc, CLOSED)) {
-- 
2.39.2



