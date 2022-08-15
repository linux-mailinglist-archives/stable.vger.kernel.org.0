Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D055948EB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346366AbiHOXhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346117AbiHOXds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:33:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29371959C;
        Mon, 15 Aug 2022 13:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9314BCE12E7;
        Mon, 15 Aug 2022 20:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9D3C433C1;
        Mon, 15 Aug 2022 20:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594117;
        bh=ZnymPQFspFL40QedNmT9etLRZlQVld7+zT63dbaFmGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMzUsz9j5m0iYJLWSAcTvkT/q/QWJEfqkMnKunDnDMCaa9+8Mgaq9md6co5dJDGIp
         zNWJMLZipHn6QDhOnZbmavBz7E43vz4XJ+WQZPt+FNUjaLmXBjvdkwVZaAA06nDvAk
         anBUxQOrxq8FRgk2qaLfh6ijLq2uWIWlE+Xybo0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Baokun Li <libaokun1@huawei.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1059/1095] ext4: correct the misjudgment in ext4_iget_extra_inode
Date:   Mon, 15 Aug 2022 20:07:38 +0200
Message-Id: <20220815180512.842967020@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit fd7e672ea98b95b9d4c9dae316639f03c16a749d ]

Use the EXT4_INODE_HAS_XATTR_SPACE macro to more accurately
determine whether the inode have xattr space.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220616021358.2504451-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 826e2deb10f8..e478cac3b8f2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4681,8 +4681,7 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 	__le32 *magic = (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
 
-	if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize + sizeof(__le32) <=
-	    EXT4_INODE_SIZE(inode->i_sb) &&
+	if (EXT4_INODE_HAS_XATTR_SPACE(inode)  &&
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
 		return ext4_find_inline_data_nolock(inode);
-- 
2.35.1



