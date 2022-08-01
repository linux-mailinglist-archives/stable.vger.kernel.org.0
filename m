Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E92586897
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiHALvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiHALuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:50:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B883C8D7;
        Mon,  1 Aug 2022 04:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F32E46125A;
        Mon,  1 Aug 2022 11:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEDAC433C1;
        Mon,  1 Aug 2022 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354542;
        bh=56sfNEMTQcxQGZXj9gWrjrjlCxtZaq4OzlBp/NcB63s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Stko80BkiKWtLjNDbOs7NI3aNrcC9ICGZ518Eh0reWm1EzwHyqQamkounubR8Tz7u
         blo0d2j+rNMu5aIFExbGteToJtIMMF9h619+5N/O97vvhtz4k4wdCjkzXrwq+oJ/8U
         2qln56wX5ESYjYMzNEFQBSplk6eoDNk7L7d7pj3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Chen <harperchen1110@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/34] sctp: leave the err path free in sctp_stream_init to sctp_stream_free
Date:   Mon,  1 Aug 2022 13:47:11 +0200
Message-Id: <20220801114129.214903256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 181d8d2066c000ba0a0e6940a7ad80f1a0e68e9d ]

A NULL pointer dereference was reported by Wei Chen:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__list_del_entry_valid+0x26/0x80
  Call Trace:
   <TASK>
   sctp_sched_dequeue_common+0x1c/0x90
   sctp_sched_prio_dequeue+0x67/0x80
   __sctp_outq_teardown+0x299/0x380
   sctp_outq_free+0x15/0x20
   sctp_association_free+0xc3/0x440
   sctp_do_sm+0x1ca7/0x2210
   sctp_assoc_bh_rcv+0x1f6/0x340

This happens when calling sctp_sendmsg without connecting to server first.
In this case, a data chunk already queues up in send queue of client side
when processing the INIT_ACK from server in sctp_process_init() where it
calls sctp_stream_init() to alloc stream_in. If it fails to alloc stream_in
all stream_out will be freed in sctp_stream_init's err path. Then in the
asoc freeing it will crash when dequeuing this data chunk as stream_out
is missing.

As we can't free stream out before dequeuing all data from send queue, and
this patch is to fix it by moving the err path stream_out/in freeing in
sctp_stream_init() to sctp_stream_free() which is eventually called when
freeing the asoc in sctp_association_free(). This fix also makes the code
in sctp_process_init() more clear.

Note that in sctp_association_init() when it fails in sctp_stream_init(),
sctp_association_free() will not be called, and in that case it should
go to 'stream_free' err path to free stream instead of 'fail_init'.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/831a3dc100c4908ff76e5bcc363be97f2778bc0b.1658787066.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c |  5 ++---
 net/sctp/stream.c    | 19 +++----------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index fb6f62264e87..f960b0e1e552 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -224,9 +224,8 @@ static struct sctp_association *sctp_association_init(
 	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
 		goto fail_init;
 
-	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams,
-			     0, gfp))
-		goto fail_init;
+	if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams, 0, gfp))
+		goto stream_free;
 
 	/* Initialize default path MTU. */
 	asoc->pathmtu = sp->pathmtu;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index cd20638b6151..56762745d6e4 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -137,7 +137,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	ret = sctp_stream_alloc_out(stream, outcnt, gfp);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	for (i = 0; i < stream->outcnt; i++)
 		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
@@ -145,22 +145,9 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 handle_in:
 	sctp_stream_interleave_init(stream);
 	if (!incnt)
-		goto out;
-
-	ret = sctp_stream_alloc_in(stream, incnt, gfp);
-	if (ret)
-		goto in_err;
-
-	goto out;
+		return 0;
 
-in_err:
-	sched->free(stream);
-	genradix_free(&stream->in);
-out_err:
-	genradix_free(&stream->out);
-	stream->outcnt = 0;
-out:
-	return ret;
+	return sctp_stream_alloc_in(stream, incnt, gfp);
 }
 
 int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
-- 
2.35.1



