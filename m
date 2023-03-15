Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBBA6BB0F8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjCOMXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjCOMXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC44FF17
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5144AB81DF8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B20C433EF;
        Wed, 15 Mar 2023 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882896;
        bh=nZiM7ujGz+VVNeHFSrcVcPw+dbp/E+rSK35/XOy2cyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZVaKvZ4R0fAVtxJDuq4JRrbbzP6ayugsYN6aGJiNWr1gs2vqXd4jvPEGKXVuRboH
         s+bpdBvbCdkrDd5V/xUxI2i7G3H23RYZlJ4wBt3KTo7SG5+A3dGhPCejMOzVN8SR3T
         F18A8E98k+AGvW6/vmzmZDqFv2UXudQaoZ/LdW04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/104] udf: Fix off-by-one error when discarding preallocation
Date:   Wed, 15 Mar 2023 13:11:44 +0100
Message-Id: <20230315115732.583783982@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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
index 81876284a83c0..d114774ecdea8 100644
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



