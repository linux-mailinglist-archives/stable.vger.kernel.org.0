Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96F559D771
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiHWJ52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351739AbiHWJzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5BEA00E3;
        Tue, 23 Aug 2022 01:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1AAEB8105C;
        Tue, 23 Aug 2022 08:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56804C433C1;
        Tue, 23 Aug 2022 08:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244411;
        bh=tZSJGZcu29hov5KyLe01/mQJdshxtNc7fhWtD6BhF4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhPtwrlQTVu2WftJ6XtUUkqdpwmohZI7SSpXrWDIZpHWhD9P9e/CK01PpZmf9MC7k
         sXkgX9utPBPl/IvikVtN+4xiYiS/UvmIT7FpJ6krH+OFThSJkKJiuQox48bbwc2PkP
         vgiJEuAi/I0cOV6a2R2M5wF5oauyNQlHUm5k4mpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuanzheng Song <songyuanzheng@huawei.com>,
        "Tobin C. Harding" <tobin@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 090/244] tools/vm/slabinfo: use alphabetic order when two values are equal
Date:   Tue, 23 Aug 2022 10:24:09 +0200
Message-Id: <20220823080102.026017060@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yuanzheng Song <songyuanzheng@huawei.com>

commit 4f5ceb8851f0081af54313abbf56de1615911faf upstream.

When the number of partial slabs in each cache is the same (e.g., the
value are 0), the results of the `slabinfo -X -N5` and `slabinfo -P -N5`
are different.

/ # slabinfo -X -N5
...
Slabs sorted by number of partial slabs
---------------------------------------
Name                   Objects Objsize           Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
inode_cache              15180     392         6217728        758/0/1   20 1   0  95 a
kernfs_node_cache        22494      88         2002944        488/0/1   46 0   0  98
shmem_inode_cache          663     464          319488         38/0/1   17 1   0  96
biovec-max                  50    3072          163840          4/0/1   10 3   0  93 A
dentry                   19050     136         2600960        633/0/2   30 0   0  99 a

/ # slabinfo -P -N5
Name                   Objects Objsize           Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
bdev_cache                  32     984           32.7K          1/0/1   16 2   0  96 Aa
ext4_inode_cache            42     752           32.7K          1/0/1   21 2   0  96 a
dentry                   19050     136            2.6M        633/0/2   30 0   0  99 a
TCPv6                       17    1840           32.7K          0/0/1   17 3   0  95 A
RAWv6                       18     856           16.3K          0/0/1   18 2   0  94 A

This problem is caused by the sort_slabs().  So let's use alphabetic order
when two values are equal in the sort_slabs().

By the way, the content of the `slabinfo -h` is not aligned because the

`-P|--partial Sort by number of partial slabs`

uses tabs instead of spaces.  So let's use spaces instead of tabs to fix
it.

Link: https://lkml.kernel.org/r/20220528063117.935158-1-songyuanzheng@huawei.com
Fixes: 1106b205a3fe ("tools/vm/slabinfo: add partial slab listing to -X")
Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/vm/slabinfo.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -125,7 +125,7 @@ static void usage(void)
 		"-n|--numa              Show NUMA information\n"
 		"-N|--lines=K           Show the first K slabs\n"
 		"-o|--ops               Show kmem_cache_ops\n"
-		"-P|--partial		Sort by number of partial slabs\n"
+		"-P|--partial           Sort by number of partial slabs\n"
 		"-r|--report            Detailed report on single slabs\n"
 		"-s|--shrink            Shrink slabs\n"
 		"-S|--Size              Sort by size\n"
@@ -1067,15 +1067,27 @@ static void sort_slabs(void)
 		for (s2 = s1 + 1; s2 < slabinfo + slabs; s2++) {
 			int result;
 
-			if (sort_size)
-				result = slab_size(s1) < slab_size(s2);
-			else if (sort_active)
-				result = slab_activity(s1) < slab_activity(s2);
-			else if (sort_loss)
-				result = slab_waste(s1) < slab_waste(s2);
-			else if (sort_partial)
-				result = s1->partial < s2->partial;
-			else
+			if (sort_size) {
+				if (slab_size(s1) == slab_size(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_size(s1) < slab_size(s2);
+			} else if (sort_active) {
+				if (slab_activity(s1) == slab_activity(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_activity(s1) < slab_activity(s2);
+			} else if (sort_loss) {
+				if (slab_waste(s1) == slab_waste(s2))
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = slab_waste(s1) < slab_waste(s2);
+			} else if (sort_partial) {
+				if (s1->partial == s2->partial)
+					result = strcasecmp(s1->name, s2->name);
+				else
+					result = s1->partial < s2->partial;
+			} else
 				result = strcasecmp(s1->name, s2->name);
 
 			if (show_inverted)


