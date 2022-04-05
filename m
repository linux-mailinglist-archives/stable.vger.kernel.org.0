Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822934F2FFD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345194AbiDEKkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244367AbiDEJlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95F7BB90A;
        Tue,  5 Apr 2022 02:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F696144D;
        Tue,  5 Apr 2022 09:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7F6C385A0;
        Tue,  5 Apr 2022 09:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150777;
        bh=Yb/Qsv5HlnFq2Ze6nGZxoMM9ffO70zuocXfIM8QKSw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppBTMh3fYh9QoixpYuOUj6mzM7QG0pSbZF8Qcksz/+wrjKQCxioStZcaDi8e44h64
         Xsrq1hj4P5/IPgnLInC6uNb0iAM0inHWsyp5hvAoT3xGjtTJ+Jru2PlctG2GixGd3U
         SW/EDgiE9QS20rdlXfjmVTeLSMyOr4Y08y42uWwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Niels Dossche <niels.dossche@ugent.be>,
        Niels Dossche <dossche.niels@gmail.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 170/913] btrfs: extend locking to all space_info members accesses
Date:   Tue,  5 Apr 2022 09:20:32 +0200
Message-Id: <20220405070344.945810759@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

commit 06bae876634ebf837ba70ea3de532b288326103d upstream.

bytes_pinned is always accessed under space_info->lock, except in
btrfs_preempt_reclaim_metadata_space, however the other members are
accessed under that lock. The reserved member of the rsv's are also
partially accessed under a lock and partially not. Move all these
accesses into the same lock to ensure consistency.

This could potentially race and lead to a flush instead of a commit but
it's not a big problem as it's only for preemptive flush.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1054,7 +1054,6 @@ static void btrfs_preempt_reclaim_metada
 			trans_rsv->reserved;
 		if (block_rsv_size < space_info->bytes_may_use)
 			delalloc_size = space_info->bytes_may_use - block_rsv_size;
-		spin_unlock(&space_info->lock);
 
 		/*
 		 * We don't want to include the global_rsv in our calculation,
@@ -1085,6 +1084,8 @@ static void btrfs_preempt_reclaim_metada
 			flush = FLUSH_DELAYED_REFS_NR;
 		}
 
+		spin_unlock(&space_info->lock);
+
 		/*
 		 * We don't want to reclaim everything, just a portion, so scale
 		 * down the to_reclaim by 1/4.  If it takes us down to 0,


