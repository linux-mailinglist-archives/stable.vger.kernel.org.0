Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172E1579D56
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbiGSMuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242175AbiGSMtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:49:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A5A57E1F;
        Tue, 19 Jul 2022 05:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DD15B81B1C;
        Tue, 19 Jul 2022 12:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AA2C341C6;
        Tue, 19 Jul 2022 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233185;
        bh=E8DcP3YJAdegwlxCi30cQmG9bc8+tT6ERZNM97yBuEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XteFZrVD0W5Yx7wTN749EKrDcbuw5p3u1AXzZ8ZtYcdUdWDyXJBDOmOd2dlfZy8to
         zj/o6eFgdSakcm72uN5674ZCJ3NvaaRoLFaVfG4qK12dhJ5xjaeTN1sjvALxen/gaK
         T1ijgJRkDGHSjI/zbKLAanOPBipzj4fou3nBdVFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 028/231] btrfs: zoned: fix a leaked bioc in read_zone_info
Date:   Tue, 19 Jul 2022 13:51:53 +0200
Message-Id: <20220719114716.423799150@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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

commit 2963457829decf0c824a443238d251151ed18ff5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1727,12 +1727,14 @@ static int read_zone_info(struct btrfs_f
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
@@ -1751,7 +1753,8 @@ static int read_zone_info(struct btrfs_f
 		break;
 	}
 	memalloc_nofs_restore(nofs_flag);
-
+out_put_bioc:
+	btrfs_put_bioc(bioc);
 	return ret;
 }
 


