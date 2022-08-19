Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF97599FB7
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350822AbiHSQCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351094AbiHSQAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:00:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEA3109753;
        Fri, 19 Aug 2022 08:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA334B827F8;
        Fri, 19 Aug 2022 15:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34213C433C1;
        Fri, 19 Aug 2022 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924353;
        bh=2P86ZKNFEU5wzeVoOvbD8JQFIyb0ga6RcvV8rBd+ApA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgkuIGHkAKjP6dJ76AJGzhaf1HghFqW15u7XefNHvAtgkJ/ms3WblJhZPNzQtMPZF
         r6sDWg3u4DT3U+f2P/OlrKvwuDYQqEYAW1ZL2JjUbQJFfVa884UhTnRMfReiXmqDHO
         3nZACIe0r+5V9nyOYu2bYXrRXKJIuNZzRBqcSW8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junichi Nomura <junichi.nomura@nec.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/545] blktrace: Trace remapped requests correctly
Date:   Fri, 19 Aug 2022 17:38:32 +0200
Message-Id: <20220819153835.687614029@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 22c80aac882f712897b88b7ea8f5a74ea19019df ]

Trace the remapped operation and its flags instead of only the data
direction of remapped operations. This issue was detected by analyzing
the warnings reported by sparse related to the new blk_opf_t type.

Reviewed-by: Jun'ichi Nomura <junichi.nomura@nec.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Fixes: 1b9a9ab78b0a ("blktrace: use op accessors")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20220714180729.1065367-11-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7f625400763b..15a376f85e09 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1100,7 +1100,7 @@ static void blk_add_trace_rq_remap(void *ignore, struct request *rq, dev_t dev,
 	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
-			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
+			req_op(rq), rq->cmd_flags, BLK_TA_REMAP, 0,
 			sizeof(r), &r, blk_trace_request_get_cgid(rq));
 	rcu_read_unlock();
 }
-- 
2.35.1



