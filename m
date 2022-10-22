Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F340360865C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiJVHso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiJVHsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B8DCD5DC;
        Sat, 22 Oct 2022 00:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D8A560B24;
        Sat, 22 Oct 2022 07:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0037C433C1;
        Sat, 22 Oct 2022 07:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424370;
        bh=AEncgBZqnzHKq0T0S/CKCWLF1y28DmqfUPSmO+kiz2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjxEVSTRQcHRN8JzjYmchhqtLKaTUB8nE3DlzCBYXxtGQi/3tNY2hYgN/3uUR/m5l
         O6x4xKQoZzgHkTr50FFj7f1J/4fCP7X2M5cjZhJjzu3vBqihhsOyk2w6i/3t6FUeIc
         Fi0/Tnuh/vtLmbjzp2LMt8OKAHALFqN4yeszTZc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.19 120/717] jbd2: fix potential use-after-free in jbd2_fc_wait_bufs
Date:   Sat, 22 Oct 2022 09:19:59 +0200
Message-Id: <20221022072436.737549980@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -926,16 +926,16 @@ int jbd2_fc_wait_bufs(journal_t *journal
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


