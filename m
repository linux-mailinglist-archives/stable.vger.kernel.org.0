Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A306BB0ED
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjCOMXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjCOMWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF371769E9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23D2961D59
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E26DC4339B;
        Wed, 15 Mar 2023 12:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882885;
        bh=cLc0rVW5+b2WucWKlZqf1eyRlcd6eqV0xVoAIlyarmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exfR0L7mbbFGkaJz/+AJvithiuXEn+ePNpAzBQNnnmJnUlDR3vOtXtq5F7hCSxAbC
         3vZCa/TnV5BE3wyfC689TurrCB/JQT/v8B5sFdT76zTtrKwGjRVeD6sAfSVt1DnGZ0
         cC3/S+eXVnZmt95oSVFMqzU4QFRstRYyXKA9nklE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 009/104] ext4: move where set the MAY_INLINE_DATA flag is set
Date:   Wed, 15 Mar 2023 13:11:40 +0100
Message-Id: <20230315115732.398540415@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 1dcdce5919115a471bf4921a57f20050c545a236 upstream.

The only caller of ext4_find_inline_data_nolock() that needs setting of
EXT4_STATE_MAY_INLINE_DATA flag is ext4_iget_extra_inode().  In
ext4_write_inline_data_end() we just need to update inode->i_inline_off.
Since we are going to add one more caller that does not need to set
EXT4_STATE_MAY_INLINE_DATA, just move setting of EXT4_STATE_MAY_INLINE_DATA
out to ext4_iget_extra_inode().

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230307015253.2232062-2-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    1 -
 fs/ext4/inode.c  |    7 ++++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -157,7 +157,6 @@ int ext4_find_inline_data_nolock(struct
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4639,8 +4639,13 @@ static inline int ext4_iget_extra_inode(
 
 	if (EXT4_INODE_HAS_XATTR_SPACE(inode)  &&
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
+		int err;
+
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-		return ext4_find_inline_data_nolock(inode);
+		err = ext4_find_inline_data_nolock(inode);
+		if (!err && ext4_has_inline_data(inode))
+			ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return err;
 	} else
 		EXT4_I(inode)->i_inline_off = 0;
 	return 0;


