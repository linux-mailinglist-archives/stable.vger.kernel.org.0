Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30ED541DD2
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358083AbiFGWVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384899AbiFGWUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C08263289;
        Tue,  7 Jun 2022 12:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D41B600E1;
        Tue,  7 Jun 2022 19:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45728C385A2;
        Tue,  7 Jun 2022 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629632;
        bh=Rf2BtKigmj85vqHrqvMHp6RrUnAF/AVzeXa9HlfYhMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwwPregZygrhB0sws5UDJ0+FPTVv6btwxsKiOlZw0upx63W7yXTSw3iwM3AiZH0B8
         KgFL5l+FpqbRrcAmLQlHk+u+RN9WwMfdtOgwjwg1GVcw9KSXqEd432TvUz+N/+QzPP
         17CcVGuVPR2d0eFYEdsBFP0BhXqWw8d5CBuR0ki8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 759/879] block: Fix potential deadlock in blk_ia_range_sysfs_show()
Date:   Tue,  7 Jun 2022 19:04:37 +0200
Message-Id: <20220607165024.895162554@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 41e46b3c2aa24f755b2ae9ec4ce931ba5f0d8532 upstream.

When being read, a sysfs attribute is already protected against removal
with the kobject node active reference counter. As a result, in
blk_ia_range_sysfs_show(), there is no need to take the queue sysfs
lock when reading the value of a range attribute. Using the queue sysfs
lock in this function creates a potential deadlock situation with the
disk removal, something that a lockdep signals with a splat when the
device is removed:

[  760.703551]  Possible unsafe locking scenario:
[  760.703551]
[  760.703554]        CPU0                    CPU1
[  760.703556]        ----                    ----
[  760.703558]   lock(&q->sysfs_lock);
[  760.703565]                                lock(kn->active#385);
[  760.703573]                                lock(&q->sysfs_lock);
[  760.703579]   lock(kn->active#385);
[  760.703587]
[  760.703587]  *** DEADLOCK ***

Solve this by removing the mutex_lock()/mutex_unlock() calls from
blk_ia_range_sysfs_show().

Fixes: a2247f19ee1c ("block: Add independent access ranges support")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20220603021905.1441419-1-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-ia-ranges.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/block/blk-ia-ranges.c
+++ b/block/blk-ia-ranges.c
@@ -54,13 +54,8 @@ static ssize_t blk_ia_range_sysfs_show(s
 		container_of(attr, struct blk_ia_range_sysfs_entry, attr);
 	struct blk_independent_access_range *iar =
 		container_of(kobj, struct blk_independent_access_range, kobj);
-	ssize_t ret;
 
-	mutex_lock(&iar->queue->sysfs_lock);
-	ret = entry->show(iar, buf);
-	mutex_unlock(&iar->queue->sysfs_lock);
-
-	return ret;
+	return entry->show(iar, buf);
 }
 
 static const struct sysfs_ops blk_ia_range_sysfs_ops = {


