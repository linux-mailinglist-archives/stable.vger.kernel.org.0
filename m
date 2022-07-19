Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E217E579C63
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbiGSMkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241093AbiGSMir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:38:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAEE24F0B;
        Tue, 19 Jul 2022 05:15:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C58A60F10;
        Tue, 19 Jul 2022 12:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223F9C341C6;
        Tue, 19 Jul 2022 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232922;
        bh=Fm3LsUhGs+2lwQNvSwWdfXPnG9aC/70429wLcfFpyA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ur1c2C80iftkPF0HjY6SCMmSCjY/Y75myPeq2o8pao9gLQ0VujwD5fgSNbLw01Dlc
         m7TNms7/BUmy3lGDJlPl5N0gcO3Prqkjt0cZF6hFkcu+uAa+U9WPL0Lkzd8GMXDZMv
         1pXIfy0IH9GVm1Io7/Cwr+60J3TecdwdTF79f++Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/167] btrfs: zoned: fix a leaked bioc in read_zone_info
Date:   Tue, 19 Jul 2022 13:54:04 +0200
Message-Id: <20220719114707.350845467@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2963457829decf0c824a443238d251151ed18ff5 ]

The bioc would leak on the normal completion path and also on the RAID56
check (but that one won't happen in practice due to the invalid
combination with zoned mode).

Fixes: 7db1c5d14dcd ("btrfs: zoned: support dev-replace in zoned filesystems")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[ update changelog ]
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ce4eeffc4f12..574769f921a2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1511,12 +1511,14 @@ static int read_zone_info(struct btrfs_fs_info *fs_info, u64 logical,
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
 			       &mapped_length, &bioc);
 	if (ret || !bioc || mapped_length < PAGE_SIZE) {
-		btrfs_put_bioc(bioc);
-		return -EIO;
+		ret = -EIO;
+		goto out_put_bioc;
 	}
 
-	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-		return -EINVAL;
+	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		ret = -EINVAL;
+		goto out_put_bioc;
+	}
 
 	nofs_flag = memalloc_nofs_save();
 	nmirrors = (int)bioc->num_stripes;
@@ -1535,7 +1537,8 @@ static int read_zone_info(struct btrfs_fs_info *fs_info, u64 logical,
 		break;
 	}
 	memalloc_nofs_restore(nofs_flag);
-
+out_put_bioc:
+	btrfs_put_bioc(bioc);
 	return ret;
 }
 
-- 
2.35.1



