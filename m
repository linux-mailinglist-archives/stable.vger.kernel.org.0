Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8341960AAF2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiJXNmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiJXNkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66323B2D81;
        Mon, 24 Oct 2022 05:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B149A612A1;
        Mon, 24 Oct 2022 12:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38FEC433C1;
        Mon, 24 Oct 2022 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615018;
        bh=RHgpOY34xrHo3qmUkhEOiFA/j5Y4V8+PQcbcKFKYUqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgL5KM/4Ce+9ORS8xeZeTGaHs4ol34kDvbPZLpTrgLeoA7d84HqjA5HWAdaofjSzB
         TvBDz8o92nSrSNB2ywAuuDWeUr9VKFnbWQ3vT4yFaMl0t84KoqiJYHHUK8WIgWY5l0
         MUI6gOYJb/7NUQ+dSMJg1HtX3McBInOnCzaMyUhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 090/530] jbd2: fix potential use-after-free in jbd2_fc_wait_bufs
Date:   Mon, 24 Oct 2022 13:27:14 +0200
Message-Id: <20221024113049.089404719@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 243d1a5d505d0b0460c9af0ad56ed4a56ef0bebd upstream.

In 'jbd2_fc_wait_bufs' use 'bh' after put buffer head reference count
which may lead to use-after-free.
So judge buffer if uptodate before put buffer head reference count.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220914100812.1414768-3-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -924,16 +924,16 @@ int jbd2_fc_wait_bufs(journal_t *journal
 	for (i = j_fc_off - 1; i >= j_fc_off - num_blks; i--) {
 		bh = journal->j_fc_wbuf[i];
 		wait_on_buffer(bh);
-		put_bh(bh);
-		journal->j_fc_wbuf[i] = NULL;
 		/*
 		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
 		 * buffer head.
 		 */
 		if (unlikely(!buffer_uptodate(bh))) {
-			journal->j_fc_off = i;
+			journal->j_fc_off = i + 1;
 			return -EIO;
 		}
+		put_bh(bh);
+		journal->j_fc_wbuf[i] = NULL;
 	}
 
 	return 0;


