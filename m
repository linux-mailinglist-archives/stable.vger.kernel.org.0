Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C956459D50D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243707AbiHWI3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243564AbiHWI1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:27:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E213F74CC2;
        Tue, 23 Aug 2022 01:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED79612DA;
        Tue, 23 Aug 2022 08:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D019EC433C1;
        Tue, 23 Aug 2022 08:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242447;
        bh=fMHn/Vf6sz9I5BG9XFOTBqc05WPfoxjFlUueGrdfOEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+nkrvqY1kSOT/dfnT+A+gS4TVmlcLYGdD94ZSBe/6Wi5zlguFL87gcmI5YMVfDP9
         1vt3MlhrUXTl5P8Zp8Z1d49HgxKwErkvTjbhCjijC5uVBZklvKVLPpaQi5c1zrFNqV
         kDnU3+M/dvmr+kyXaKuEUe3X/r1KXiYn7rNBJsxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Baokun Li <libaokun1@huawei.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 055/101] ext4: correct max_inline_xattr_value_size computing
Date:   Tue, 23 Aug 2022 10:03:28 +0200
Message-Id: <20220823080036.657404616@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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

commit c9fd167d57133c5b748d16913c4eabc55e531c73 upstream.

If the ext4 inode does not have xattr space, 0 is returned in the
get_max_inline_xattr_value_size function. Otherwise, the function returns
a negative value when the inode does not contain EXT4_STATE_XATTR.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220616021358.2504451-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -40,6 +40,9 @@ static int get_max_inline_xattr_value_si
 	struct ext4_inode *raw_inode;
 	int free, min_offs;
 
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
+		return 0;
+
 	min_offs = EXT4_SB(inode->i_sb)->s_inode_size -
 			EXT4_GOOD_OLD_INODE_SIZE -
 			EXT4_I(inode)->i_extra_isize -


