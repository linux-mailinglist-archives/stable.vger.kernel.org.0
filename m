Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BEB63DE0E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiK3SdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiK3SdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C24537E2
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B78261AFE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D431C433D6;
        Wed, 30 Nov 2022 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833189;
        bh=hL2bfwoxDhEngUNaznYHMVht1omGZX8sAPnwKju+iyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efp8KF8kf82d9bXVdIiXcD7eMXRET9agUG6Y6mI2MSnZTc/UL8MdNnKVtDYUS5nfc
         wktIJQrQXpFeqBOFDxVzNQVXrsGDShaRQAx7y7pG1bGnl+ogbxroXzUZtnSyBYUffu
         67vF2OmVSli9/x4d/x7JdsgYbtIoRv54n+o2C7/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/206] sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
Date:   Wed, 30 Nov 2022 19:20:58 +0100
Message-Id: <20221130180533.151238905@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 9f0b773210c27a8f5d98ddb2fc4ba60a42a3285f ]

Since commit 5bbbbe32a431 ("sctp: introduce stream scheduler foundations"),
sctp_stream_outq_migrate() has been called in sctp_stream_init/update to
removes those chunks to streams higher than the new max. There is no longer
need to do such check in sctp_prsctp_prune_unsent().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2f201ae14ae0 ("sctp: clear out_curr if all frag chunks of current msg are pruned")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/outqueue.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index b3950963fc8f..6fcc4ff97f94 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 {
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
+	struct sctp_stream_out *sout;
 
 	q->sched->unsched_all(&asoc->stream);
 
@@ -398,12 +399,9 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-			struct sctp_stream_out *streamout =
-				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
-			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		}
+		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
-- 
2.35.1



