Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC559515F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiHPE4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbiHPE4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:56:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18815BB68A;
        Mon, 15 Aug 2022 13:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7497EB811AC;
        Mon, 15 Aug 2022 20:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B472C433C1;
        Mon, 15 Aug 2022 20:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596672;
        bh=dhF1/NQMWIzDt9euqKEuVQlmK9TFSNf2KeDeCJevN9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1P7FvrLlBJzo+iVQwD9nvmMi6/53zrN9OtB1hY9nUJDSO+QO1XXUXcSTN7NDShycn
         lQsEOTjTz4ZsKhD05h0jSUTZgRTdjTpY/U9aGmvl0gIBbyLnTZXIcPR1wqVxdeoYTw
         6ie23PY6U1VMXWXSoyef1atz3vUdC1bgRcDrBq8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Baokun Li <libaokun1@huawei.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1121/1157] ext4: correct max_inline_xattr_value_size computing
Date:   Mon, 15 Aug 2022 20:07:57 +0200
Message-Id: <20220815180525.192713819@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit c9fd167d57133c5b748d16913c4eabc55e531c73 ]

If the ext4 inode does not have xattr space, 0 is returned in the
get_max_inline_xattr_value_size function. Otherwise, the function returns
a negative value when the inode does not contain EXT4_STATE_XATTR.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220616021358.2504451-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1fa36cbe09ec..a4fbe825694b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -36,6 +36,9 @@ static int get_max_inline_xattr_value_size(struct inode *inode,
 	struct ext4_inode *raw_inode;
 	int free, min_offs;
 
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
+		return 0;
+
 	min_offs = EXT4_SB(inode->i_sb)->s_inode_size -
 			EXT4_GOOD_OLD_INODE_SIZE -
 			EXT4_I(inode)->i_extra_isize -
-- 
2.35.1



