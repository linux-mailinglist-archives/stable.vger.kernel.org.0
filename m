Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB059DF8F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355703AbiHWKoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356550AbiHWKme (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:42:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CD58672E;
        Tue, 23 Aug 2022 02:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77C12CE1B40;
        Tue, 23 Aug 2022 09:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F26C433C1;
        Tue, 23 Aug 2022 09:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245799;
        bh=oBWPVa+/s0Zsff8K0UJpXwNYvvBDOEBsVZDbzO/5imw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgMBLFMhRbePs72q98Gr36FUPfpBi8ecNKhmXzKrMGbMEBTAl69XQ28to/XDrhwg8
         dGtayjfWs8hqwd6Izb1UO5YEI/AIWnzbUhpMSNvPzuSYD0QTdwL3i8+ANxKr1cDIpw
         fzh/XkCekQ5uIQEVUmj8+n/MAfSbgHH1v/HMvCqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Baokun Li <libaokun1@huawei.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 193/287] ext4: correct the misjudgment in ext4_iget_extra_inode
Date:   Tue, 23 Aug 2022 10:26:02 +0200
Message-Id: <20220823080107.338891250@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

commit fd7e672ea98b95b9d4c9dae316639f03c16a749d upstream.

Use the EXT4_INODE_HAS_XATTR_SPACE macro to more accurately
determine whether the inode have xattr space.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220616021358.2504451-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4844,8 +4844,7 @@ static inline int ext4_iget_extra_inode(
 	__le32 *magic = (void *)raw_inode +
 			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
 
-	if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize + sizeof(__le32) <=
-	    EXT4_INODE_SIZE(inode->i_sb) &&
+	if (EXT4_INODE_HAS_XATTR_SPACE(inode)  &&
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
 		return ext4_find_inline_data_nolock(inode);


