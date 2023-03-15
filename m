Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB06BB156
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjCOM0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbjCOM0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929B49AFD4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FB18B81E0B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7329EC433A7;
        Wed, 15 Mar 2023 12:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883084;
        bh=d2ci0kpJ+0PWXXIPqXAL/E/Vwe0hM7/CtN0cRIxUOck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nu2to1QmsLnvwZ0Z1OJa+bKeaixWqTalJDVHjKc2cumSqM7o9wXRUlxAFBbomHvp0
         81dC7LXesFYOpD0C751PjwBmR3sKIgqsCV6dRFRwQIV7e5M5HdkDmTe/073ZxfPMfy
         kXFloJok/nuYi52fe70WUoRkpTo3e4oiZXAm9slw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Forza <forza@tnonline.net>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 002/145] btrfs: fix percent calculation for bg reclaim message
Date:   Wed, 15 Mar 2023 13:11:08 +0100
Message-Id: <20230315115739.053383516@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 95cd356ca23c3807b5f3503687161e216b1c520d upstream.

We have a report, that the info message for block-group reclaim is
crossing the 100% used mark.

This is happening as we were truncating the divisor for the division
(the block_group->length) to a 32bit value.

Fix this by using div64_u64() to not truncate the divisor.

In the worst case, it can lead to a div by zero error and should be
possible to trigger on 4 disks RAID0, and each device is large enough:

  $ mkfs.btrfs  -f /dev/test/scratch[1234] -m raid1 -d raid0
  btrfs-progs v6.1
  [...]
  Filesystem size:    40.00GiB
  Block group profiles:
    Data:             RAID0             4.00GiB <<<
    Metadata:         RAID1           256.00MiB
    System:           RAID1             8.00MiB

Reported-by: Forza <forza@tnonline.net>
Link: https://lore.kernel.org/linux-btrfs/e99483.c11a58d.1863591ca52@tnonline.net/
Fixes: 5f93e776c673 ("btrfs: zoned: print unusable percentage when reclaiming block groups")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add Qu's note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1554,7 +1554,8 @@ void btrfs_reclaim_bgs_work(struct work_
 
 		btrfs_info(fs_info,
 			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
-				bg->start, div_u64(bg->used * 100, bg->length),
+				bg->start,
+				div64_u64(bg->used * 100, bg->length),
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);


