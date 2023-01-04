Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21F65D323
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjADMxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjADMxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A0D1AD90
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:53:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12FB1B81629
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA9AC433EF;
        Wed,  4 Jan 2023 12:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836781;
        bh=VBstytzzSkTBltOH4GmSuS5YLmHxylLO1E0OxfEH6fI=;
        h=Subject:To:Cc:From:Date:From;
        b=zRCeKXn5/cNfj0lWte6JhT7kCNsqtmdi5Xa+RdeAVExKEEYRs42dqKw0LOW0fvczS
         g++szJj71+KtP5TOjt0YgQE5lSpOGwWnYcMDeGtDHaDITTffaQ68pQmhnFY0j7nEpK
         wMa+rMn1B3uETLfgZhkF3XBUlNAXs0VCES3unOFs=
Subject: FAILED: patch "[PATCH] btrfs: fix extent map use-after-free when handling missing" failed to apply to 5.15-stable tree
To:     void0red@gmail.com, 1527030098@qq.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:52:44 +0100
Message-ID: <1672836764148137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1742e1c90c3d ("btrfs: fix extent map use-after-free when handling missing device in read_one_chunk")
ff37c89f94be ("btrfs: move missing device handling in a dedicate function")
562d7b1512f7 ("btrfs: handle device lookup with btrfs_dev_lookup_args")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1742e1c90c3da344f3bb9b1f1309b3f47482756a Mon Sep 17 00:00:00 2001
From: void0red <void0red@gmail.com>
Date: Wed, 23 Nov 2022 22:39:45 +0800
Subject: [PATCH] btrfs: fix extent map use-after-free when handling missing
 device in read_one_chunk

Store the error code before freeing the extent_map. Though it's
reference counted structure, in that function it's the first and last
allocation so this would lead to a potential use-after-free.

The error can happen eg. when chunk is stored on a missing device and
the degraded mount option is missing.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216721
Reported-by: eriri <1527030098@qq.com>
Fixes: adfb69af7d8c ("btrfs: add_missing_dev() should return the actual error")
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: void0red <void0red@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index acab20f2863d..aa25fa335d3e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6976,8 +6976,9 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			map->stripes[i].dev = handle_missing_device(fs_info,
 								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
+				ret = PTR_ERR(map->stripes[i].dev);
 				free_extent_map(em);
-				return PTR_ERR(map->stripes[i].dev);
+				return ret;
 			}
 		}
 

