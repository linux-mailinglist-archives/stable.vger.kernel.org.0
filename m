Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26496355A4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbiKWJW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237623AbiKWJWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235F3286D9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD92BB81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05919C433C1;
        Wed, 23 Nov 2022 09:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195302;
        bh=8/HKitjhzZvNMq+cXNn7TyKpIMUbwlDX1FVrQ3KbJV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkzM4yl14iN55tKLnUKRiJtJP2KyOZjx+GRV0syECKcJ5bMrjuStkH++v+Ud/y8ie
         mD/C7URjYms9fq0Jna2vvRwy+bi6FCAMcBpvuF5P4TDj4aYVSmzZqteruaKLu1Q7jH
         cBOsDoEKUTee7xXYDCuYAzKuLhxihlO9i33VrE7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhen Chen <chenzhen126@huawei.com>,
        Caowangbao <caowangbao@huawei.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/149] sctp: clear out_curr if all frag chunks of current msg are pruned
Date:   Wed, 23 Nov 2022 09:50:29 +0100
Message-Id: <20221123084559.608922510@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2f201ae14ae0f91dbf1cffea7bb1e29e81d4d108 ]

A crash was reported by Zhen Chen:

  list_del corruption, ffffa035ddf01c18->next is NULL
  WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49 __list_del_entry_valid+0x59/0xe0
  RIP: 0010:__list_del_entry_valid+0x59/0xe0
  Call Trace:
   sctp_sched_dequeue_common+0x17/0x70 [sctp]
   sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
   sctp_outq_flush_data+0x85/0x360 [sctp]
   sctp_outq_uncork+0x77/0xa0 [sctp]
   sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
   sctp_side_effects+0x37/0xe0 [sctp]
   sctp_do_sm+0xd0/0x230 [sctp]
   sctp_primitive_SEND+0x2f/0x40 [sctp]
   sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
   sctp_sendmsg+0x3d5/0x440 [sctp]
   sock_sendmsg+0x5b/0x70

and in sctp_sched_fcfs_dequeue() it dequeued a chunk from stream
out_curr outq while this outq was empty.

Normally stream->out_curr must be set to NULL once all frag chunks of
current msg are dequeued, as we can see in sctp_sched_dequeue_done().
However, in sctp_prsctp_prune_unsent() as it is not a proper dequeue,
sctp_sched_dequeue_done() is not called to do this.

This patch is to fix it by simply setting out_curr to NULL when the
last frag chunk of current msg is dequeued from out_curr stream in
sctp_prsctp_prune_unsent().

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Zhen Chen <chenzhen126@huawei.com>
Tested-by: Caowangbao <caowangbao@huawei.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/outqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 35d5532320f9..83a89dcf75ed 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -403,6 +403,11 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
+		/* clear out_curr if all frag chunks are pruned */
+		if (asoc->stream.out_curr == sout &&
+		    list_is_last(&chk->frag_list, &chk->msg->chunks))
+			asoc->stream.out_curr = NULL;
+
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
 		if (msg_len <= 0)
-- 
2.35.1



