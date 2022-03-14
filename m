Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E132A4D8359
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbiCNMN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbiCNMLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C18E33E86;
        Mon, 14 Mar 2022 05:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBE961361;
        Mon, 14 Mar 2022 12:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C76C340E9;
        Mon, 14 Mar 2022 12:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259826;
        bh=hY2UIJK5Bcp2co/zW3Bbj4YExAPuG2DsjYW6j9zjOz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyLW8eqcKePxd4vG+nQQ1X716yV8BBTtSessHI9LosDQBuUTNa2/sE6RRx6DXlWV+
         2fSxRWVQU3fLRKR7m6cYUriRfv+XeYOBjcuzyenxWpMoQN66SH0qPzHUvyvLpU+IkV
         YFvfYsXRb6mXWIjDyrS3jCCfStyzTegG3FMcPamE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 098/110] watch_queue: Free the alloc bitmap when the watch_queue is torn down
Date:   Mon, 14 Mar 2022 12:54:40 +0100
Message-Id: <20220314112745.761496477@linuxfoundation.org>
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

commit 7ea1a0124b6da246b5bc8c66cddaafd36acf3ecb upstream.

Free the watch_queue note allocation bitmap when the watch_queue is
destroyed.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -373,6 +373,7 @@ static void __put_watch_queue(struct kre
 
 	for (i = 0; i < wqueue->nr_pages; i++)
 		__free_page(wqueue->notes[i]);
+	bitmap_free(wqueue->notes_bitmap);
 
 	wfilter = rcu_access_pointer(wqueue->filter);
 	if (wfilter)


