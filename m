Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0CC5946DD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344824AbiHOXCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352984AbiHOXBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:01:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CF113F20C;
        Mon, 15 Aug 2022 12:58:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3943612B1;
        Mon, 15 Aug 2022 19:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58BCC433D7;
        Mon, 15 Aug 2022 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593484;
        bh=NxNXOIqovvENtDMuxyXRJZc6jarusv6Z/+p9FTbIHzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5nYGd5111GkCdzQxUo10yO0NVd2aLmpp9m9BShJpoI7eVeZummUU4przmNs7ckXX
         60UERURXLx1FhLI3O5KHlffGhfzY5uP6B69AVmOsflOtusN7+BNdo3m02N0USNHz5H
         1+rdR7k5PVtaOZNXMkZUOpOMkHous+vwOfzPvufU=
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
Subject: [PATCH 5.19 0274/1157] blktrace: Trace remapped requests correctly
Date:   Mon, 15 Aug 2022 19:53:50 +0200
Message-Id: <20220815180450.571170856@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index fe04c6f96ca5..b334c033cee7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1058,7 +1058,7 @@ static void blk_add_trace_rq_remap(void *ignore, struct request *rq, dev_t dev,
 	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
-			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
+			req_op(rq), rq->cmd_flags, BLK_TA_REMAP, 0,
 			sizeof(r), &r, blk_trace_request_get_cgid(rq));
 	rcu_read_unlock();
 }
-- 
2.35.1



