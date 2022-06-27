Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4055D7EC
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbiF0Lvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238322AbiF0Lut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:50:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089FF2629;
        Mon, 27 Jun 2022 04:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83B83B80D92;
        Mon, 27 Jun 2022 11:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB646C341C7;
        Mon, 27 Jun 2022 11:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330227;
        bh=e1XX8I8SnpXBYkbVjJf9BRbY5atBzPtKnsb27yFGmSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZR+4I+dZq7lNU1XSLcAXV9ga+lEPBiZ8ZOVBjG4kxO1FuJiw1QgFQ8NgHSx/qqad
         bk0ZKr2aPj5y8QKS+hXeu/TJQ/A5OyfnPUnJkUCHiIqhJblvhAwyHI4nU+WxBn01Bc
         l9OTJO2xalRFplgQqpAxKWW8qEPFbOZtEKdSGHqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 125/181] btrfs: dont set lock_owner when locking extent buffer for reading
Date:   Mon, 27 Jun 2022 13:21:38 +0200
Message-Id: <20220627111948.317683160@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

commit 97e86631bccddfbbe0c13f9a9605cdef11d31296 upstream.

In 196d59ab9ccc "btrfs: switch extent buffer tree lock to rw_semaphore"
the functions for tree read locking were rewritten, and in the process
the read lock functions started setting eb->lock_owner = current->pid.
Previously lock_owner was only set in tree write lock functions.

Read locks are shared, so they don't have exclusive ownership of the
underlying object, so setting lock_owner to any single value for a
read lock makes no sense.  It's mostly harmless because write locks
and read locks are mutually exclusive, and none of the existing code
in btrfs (btrfs_init_new_buffer and print_eb_refs_lock) cares what
nonsense is written in lock_owner when no writer is holding the lock.

KCSAN does care, and will complain about the data race incessantly.
Remove the assignments in the read lock functions because they're
useless noise.

Fixes: 196d59ab9ccc ("btrfs: switch extent buffer tree lock to rw_semaphore")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/locking.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -45,7 +45,6 @@ void __btrfs_tree_read_lock(struct exten
 		start_ns = ktime_get_ns();
 
 	down_read_nested(&eb->lock, nest);
-	eb->lock_owner = current->pid;
 	trace_btrfs_tree_read_lock(eb, start_ns);
 }
 
@@ -62,7 +61,6 @@ void btrfs_tree_read_lock(struct extent_
 int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 {
 	if (down_read_trylock(&eb->lock)) {
-		eb->lock_owner = current->pid;
 		trace_btrfs_try_tree_read_lock(eb);
 		return 1;
 	}
@@ -90,7 +88,6 @@ int btrfs_try_tree_write_lock(struct ext
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
 	trace_btrfs_tree_read_unlock(eb);
-	eb->lock_owner = 0;
 	up_read(&eb->lock);
 }
 


