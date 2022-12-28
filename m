Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DFE657F19
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiL1QBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiL1QBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:01:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EA012AA0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:01:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C127B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F70BC433EF;
        Wed, 28 Dec 2022 16:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243262;
        bh=Ct+mYGhl3hN88rg24PYTXGECb/qTwT8CyWyh/9w1Ojg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+1oHC2BjCznzJHqATCcd7TsHgoGXibeYY9gbkyMh9uQe8Yfxmpu9d4UWUL56ZQHO
         7mnpa7dRT/vACdsT8sK85fVQ8mdD+AAMTH2LCJeFYfbsaaAfmCuCXMlqOG3nNJXyp9
         KXI2frNbi0buOK/4ZFxx3I8HdlPiJ5pWfAzSo3h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0507/1073] blktrace: Fix output non-blktrace event when blk_classic option enabled
Date:   Wed, 28 Dec 2022 15:34:55 +0100
Message-Id: <20221228144341.819410129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit f596da3efaf4130ff61cd029558845808df9bf99 ]

When the blk_classic option is enabled, non-blktrace events must be
filtered out. Otherwise, events of other types are output in the blktrace
classic format, which is unexpected.

The problem can be triggered in the following ways:

  # echo 1 > /sys/kernel/debug/tracing/options/blk_classic
  # echo 1 > /sys/kernel/debug/tracing/events/enable
  # echo blk > /sys/kernel/debug/tracing/current_tracer
  # cat /sys/kernel/debug/tracing/trace_pipe

Fixes: c71a89615411 ("blktrace: add ftrace plugin")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20221122040410.85113-1-yangjihong1@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7f5eb295fe19..ee22a3b1c181 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1546,7 +1546,8 @@ blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
-	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+	if ((iter->ent->type != TRACE_BLK) ||
+	    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
 		return TRACE_TYPE_UNHANDLED;
 
 	return print_one_line(iter, true);
-- 
2.35.1



