Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F106BB154
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjCOM0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjCOM0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B44599C2C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C160B81DF6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98359C433EF;
        Wed, 15 Mar 2023 12:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883122;
        bh=IyhMf7AffPOfSQ3jx3jQk604PzoiGSL9QvWyJmhAZAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmtKuxxtLKJw5tbl/WazMplmo5FO8eA7Nrhkn4ANWXbEy0iTD9epcHAEshD1OJykv
         RW7ZbmEAEFgtqPBpwNxS8q0iKaYyqaIGc1Lrbvigmzkck7IaqU9JlVgQszwtth5JyB
         7fUNxGApOCA1mIlbKHeFu2ibANHbMi0jsxQJQPAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/145] udf: Fix off-by-one error when discarding preallocation
Date:   Wed, 15 Mar 2023 13:11:30 +0100
Message-Id: <20230315115739.838873153@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit f54aa97fb7e5329a373f9df4e5e213ced4fc8759 ]

The condition determining whether the preallocation can be used had
an off-by-one error so we didn't discard preallocation when new
allocation was just following it. This can then confuse code in
inode_getblk().

CC: stable@vger.kernel.org
Fixes: 16d055656814 ("udf: Discard preallocation before extending file with a hole")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index a151e04856afe..594d224588819 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -442,7 +442,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	 * Block beyond EOF and prealloc extents? Just discard preallocation
 	 * as it is not useful and complicates things.
 	 */
-	if (((loff_t)block) << inode->i_blkbits > iinfo->i_lenExtents)
+	if (((loff_t)block) << inode->i_blkbits >= iinfo->i_lenExtents)
 		udf_discard_prealloc(inode);
 	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
-- 
2.39.2



