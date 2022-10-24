Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027E360B106
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiJXQPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiJXQOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:14:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE29F127BEC;
        Mon, 24 Oct 2022 08:02:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76C36B81627;
        Mon, 24 Oct 2022 12:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF8C433D6;
        Mon, 24 Oct 2022 12:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613903;
        bh=RHgpOY34xrHo3qmUkhEOiFA/j5Y4V8+PQcbcKFKYUqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnQfBGzA7jOq6+8f0iRoObSl/CnLHTAB8XDa+uERDZojAthdO8rG5IgFSdDIolylT
         8ScLnzqA/Z2x6LOjE+hIF+tV2zp+lfVgrjRkk3980mOXm7N+Q2EPCR/JtPAF4YLxR4
         rCjUUgNiBXIq9vs2DalK029JaEFMmJNWwC787bGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 058/390] jbd2: fix potential use-after-free in jbd2_fc_wait_bufs
Date:   Mon, 24 Oct 2022 13:27:35 +0200
Message-Id: <20221024113025.110853995@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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


