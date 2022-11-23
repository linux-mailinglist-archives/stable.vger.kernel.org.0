Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436856355C7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiKWJWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237614AbiKWJWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A266710B433
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57C73B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C2CC433D6;
        Wed, 23 Nov 2022 09:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195299;
        bh=SMFgKL51AnwUK1fHRMRT7V0IMZtAcWNIaHk4Qst6sC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9EqgH81qGFO4FC/AcFPRZi4pNMdvYe+mf99fy4wGQfCMyzEaNtWBXPyA7oY9jXJd
         MlHn61wl3yMLQXjP4dv1d6/CgrZi8BLJL4eYOkiNNq1YuEBWFvTO44lwGq04xxpkOh
         9CnoLJrkh3zpRE66sFZipvKf15EfWVO54aWu2cWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/149] sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
Date:   Wed, 23 Nov 2022 09:50:28 +0100
Message-Id: <20221123084559.569642587@linuxfoundation.org>
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
index 3fd06a27105d..35d5532320f9 100644
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



