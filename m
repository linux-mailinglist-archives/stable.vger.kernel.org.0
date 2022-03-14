Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A881C4D82A0
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbiCNMGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbiCNMF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A903960C5;
        Mon, 14 Mar 2022 05:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41EA4612DD;
        Mon, 14 Mar 2022 12:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DF5C340E9;
        Mon, 14 Mar 2022 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259365;
        bh=/ysTpHMR/qo7lmvua99zXU/quYDGz2gZ/U7+mWVtzZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1TbWC5MqJcVNhqcLflTkzzXdhVE8DofZnVU75smSlnqZRtav138/oRPo9IrAdil+
         m5q/lSghRIyumYZS8F3MCNsbRvGZazMJVO1qpcRuIfuvDaHyiIb7/ClWjnrky12+62
         fyKWkeNn/I7m5x5AoNI7W7hLK1kKD90S+Hx3T1TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 62/71] watch_queue: Fix the alloc bitmap size to reflect notes allocated
Date:   Mon, 14 Mar 2022 12:53:55 +0100
Message-Id: <20220314112739.666040961@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 3b4c0371928c17af03e8397ac842346624017ce6 upstream.

Currently, watch_queue_set_size() sets the number of notes available in
wqueue->nr_notes according to the number of notes allocated, but sets
the size of the bitmap to the unrounded number of notes originally asked
for.

Fix this by setting the bitmap size to the number of notes we're
actually going to make available (ie. the number allocated).

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -244,6 +244,7 @@ long watch_queue_set_size(struct pipe_in
 		goto error;
 	}
 
+	nr_notes = nr_pages * WATCH_QUEUE_NOTES_PER_PAGE;
 	ret = pipe_resize_ring(pipe, roundup_pow_of_two(nr_notes));
 	if (ret < 0)
 		goto error;
@@ -269,7 +270,7 @@ long watch_queue_set_size(struct pipe_in
 	wqueue->notes = pages;
 	wqueue->notes_bitmap = bitmap;
 	wqueue->nr_pages = nr_pages;
-	wqueue->nr_notes = nr_pages * WATCH_QUEUE_NOTES_PER_PAGE;
+	wqueue->nr_notes = nr_notes;
 	return 0;
 
 error_p:


