Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169A06A2DC8
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjBZDqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBZDp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:45:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7FB17CF3;
        Sat, 25 Feb 2023 19:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE680B80B90;
        Sun, 26 Feb 2023 03:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AA3C4339C;
        Sun, 26 Feb 2023 03:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383045;
        bh=m3Bi8ykRKz7C0lnLkCzrDQ+YdKhyypTsGT7n3gsu0GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfJJqRQciUXpVPIXCb9b/mCnGE2UmQNxDPN/V3BR4mXzuv2xcs4ihrf3S5NiO5JQW
         C/16lPPBK1hzmWvFX2aUUP/Z4Gz5Uf0LAoA7K4jPKGpcEbnEwPLsZRyi3cohrcQGjG
         DDcEGFRDfP6uxXRvDBSO5mzmtSQYC4fJCtLbU+patf+nNXv0D8AqWOUIcrgaR+ywRm
         55WbDQJ8VdQynm+hIiB/8Nlf050OIr0k/wLV68B//YAw54p+NU7donri6oykZOQSQA
         TJ24h8T9k7AIzB53/MzsaPXG7FgA+yoc3ilPDOqUgoDKT7q69/QZxr4DrepIn6o5rV
         IZGKmDdKhyC+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 4/6] trace/blktrace: fix memory leak with using debugfs_lookup()
Date:   Sat, 25 Feb 2023 22:43:56 -0500
Message-Id: <20230226034359.773806-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034359.773806-1-sashal@kernel.org>
References: <20230226034359.773806-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 83e8864fee26f63a7435e941b7c36a20fd6fe93e ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230202141956.2299521-1-gregkh@linuxfoundation.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 16b0d3fa56e00..e6d03cf148597 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -319,8 +319,8 @@ static void blk_trace_free(struct request_queue *q, struct blk_trace *bt)
 	 * under 'q->debugfs_dir', thus lookup and remove them.
 	 */
 	if (!bt->dir) {
-		debugfs_remove(debugfs_lookup("dropped", q->debugfs_dir));
-		debugfs_remove(debugfs_lookup("msg", q->debugfs_dir));
+		debugfs_lookup_and_remove("dropped", q->debugfs_dir);
+		debugfs_lookup_and_remove("msg", q->debugfs_dir);
 	} else {
 		debugfs_remove(bt->dir);
 	}
-- 
2.39.0

