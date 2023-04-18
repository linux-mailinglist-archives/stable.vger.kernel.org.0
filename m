Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F246E6457
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjDRMsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjDRMsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123B815A3F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92D4262B21
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37CAC433EF;
        Tue, 18 Apr 2023 12:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822088;
        bh=s2tBruNHJ36y6TmV3Iu7hSFoh8IbYFP4VVe5v4GJ4GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlIUmx2pCokuLtyrfUzaclnEQBYwsSjbELmrsBBcUC6EAD7dUPgQC+rf3gaV6HdHS
         RhP52PMqoZ/uRb77z3qyhrJdPOxnzS90cr+0iqeCFCuv9IV1WozUh4pMQ6JIPDQlNw
         0tOBvPE4TsjiFw0OcoiSQ9RfxiwMM+EPnFlVfwQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 018/139] btrfs: restore the thread_pool= behavior in remount for the end I/O workqueues
Date:   Tue, 18 Apr 2023 14:21:23 +0200
Message-Id: <20230418120314.341531471@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 40fac6472f22a59f5694496e179988ab4a1dfe07 upstream.

Commit d7b9416fe5c5 ("btrfs: remove btrfs_end_io_wq") converted the read
and I/O handling from btrfs_workqueues to Linux workqueues, and as part
of that lost the code to apply the thread_pool= based max_active limit
on remount.  Restore it.

Fixes: d7b9416fe5c5 ("btrfs: remove btrfs_end_io_wq")
CC: stable@vger.kernel.org # 6.0+
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1630,6 +1630,8 @@ static void btrfs_resize_thread_pool(str
 	btrfs_workqueue_set_max(fs_info->hipri_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delalloc_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->caching_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
+	workqueue_set_max_active(fs_info->endio_meta_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delayed_workers, new_pool_size);


