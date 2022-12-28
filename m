Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC0A657A50
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiL1PKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiL1PJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA11C13E8E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A6F2B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47FAC433F0;
        Wed, 28 Dec 2022 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240187;
        bh=0+NNa5fpyW3DCq73rttI0isSuvvtqapy9L9/HEa6Tz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgRkYW/fpBlj4vD1ecageq9Se7J1Mub+nAYQeXYaUQyuOvC9YwQViYHt3iOa5fwJp
         yFC++pKp8fUFxoerqV7pVZO+AAZRs/Ybe2Q6ovpvXV/BcGtBp4saHedpT2VWqotZkY
         YEBdaTi4yyYktqQAfx9Vwa2owURoxjPRGpywWAGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Jihong <yangjihong1@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/731] blktrace: Fix output non-blktrace event when blk_classic option enabled
Date:   Wed, 28 Dec 2022 15:37:06 +0100
Message-Id: <20221228144305.823198406@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index eaa98e2b468f..16b0d3fa56e0 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1547,7 +1547,8 @@ blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
 
 static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 {
-	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+	if ((iter->ent->type != TRACE_BLK) ||
+	    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
 		return TRACE_TYPE_UNHANDLED;
 
 	return print_one_line(iter, true);
-- 
2.35.1



