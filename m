Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739595868F3
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiHALzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiHALyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E942E3FA29;
        Mon,  1 Aug 2022 04:50:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03257B80E8F;
        Mon,  1 Aug 2022 11:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47461C433C1;
        Mon,  1 Aug 2022 11:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354643;
        bh=d0PFtRJnzZrBYfXv4fhaquB7q0KQccE/rvCowFHmkbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsCIu8jKnZT5JcP6UV/KWKgG3FzmWGnT2b36gFDnwfhNzP8H/DWvlAZF9Yj5kdAeR
         68+gZS5PGo5Q1BmGL1pFTMsJhNCIQdV4nlg6skAxHeIcRklv/9gVY4oie/HD8qabCO
         B50FtI/dYkFZl8QZrcqxKsBOD9geWXwSylX9bnBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 06/65] watch_queue: Fix missing rcu annotation
Date:   Mon,  1 Aug 2022 13:46:23 +0200
Message-Id: <20220801114133.926593140@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit e0339f036ef4beb9b20f0b6532a1e0ece7f594c6 upstream.

Since __post_watch_notification() walks wlist->watchers with only the
RCU read lock held, we need to use RCU methods to add to the list (we
already use RCU methods to remove from the list).

Fix add_watch_to_object() to use hlist_add_head_rcu() instead of
hlist_add_head() for that list.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -497,7 +497,7 @@ int add_watch_to_object(struct watch *wa
 		unlock_wqueue(wqueue);
 	}
 
-	hlist_add_head(&watch->list_node, &wlist->watchers);
+	hlist_add_head_rcu(&watch->list_node, &wlist->watchers);
 	return 0;
 }
 EXPORT_SYMBOL(add_watch_to_object);


