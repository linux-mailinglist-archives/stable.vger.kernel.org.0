Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C096AF4E8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbjCGTVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjCGTUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:20:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB411E9FF;
        Tue,  7 Mar 2023 11:04:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B80861522;
        Tue,  7 Mar 2023 19:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E06C433D2;
        Tue,  7 Mar 2023 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215872;
        bh=dFncEYxzp4fxw/6dqAiNEGbjwMW6fJDfmWHBfGObDsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvYzZRF47r8GyNO71QSCyS3CMiHVSJTNBgLTnQwft1HQkO6JaWOVpphRFUQhScJBo
         yQU4qKG9o5903FBPaYo6mJK9bC+JCQYnCptmJmusfI02U9ENV2mNUQ8F8VADTqlAS7
         9Dxn/SIr6nTaEn7vERl2GatpCTcSaFdVwOj/9QZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/567] trace/blktrace: fix memory leak with using debugfs_lookup()
Date:   Tue,  7 Mar 2023 18:01:44 +0100
Message-Id: <20230307165921.799977578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2



