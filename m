Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFCF4D8364
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiCNMN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbiCNMLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85F833A39;
        Mon, 14 Mar 2022 05:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA87B80DF4;
        Mon, 14 Mar 2022 12:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFADC340EC;
        Mon, 14 Mar 2022 12:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259822;
        bh=/ysTpHMR/qo7lmvua99zXU/quYDGz2gZ/U7+mWVtzZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGd6PzOzZMgZL1EZQ9RbUPyk28chcQ9n2dQdg/pfjIQS8u+aCMXLUy0BMk4srhHco
         RVmn6XuXWER3sTACK1HlXiKbQQvcTxP1H3ADselaQyCpqXA+2uMlfC5kw4ifSkpW4/
         kGt6BRUbIetaXWTg0adl1xJMVfpDXNSxTVV2oWAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 097/110] watch_queue: Fix the alloc bitmap size to reflect notes allocated
Date:   Mon, 14 Mar 2022 12:54:39 +0100
Message-Id: <20220314112745.733992680@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
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


