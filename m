Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B96677A8
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbjALOqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbjALOpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:45:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827385E67E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21791B81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BBFC433EF;
        Thu, 12 Jan 2023 14:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534043;
        bh=2mLmHW6MFuIqc4pRFVppfgmm1RoOfi7m7tM4G/SObAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsnwRglaWvh7XJnfw3yrSKg1RRTCgklkrBGru2GfrA2o5qJun5Ri5p5GiNjBcOBMl
         HELvpTbUGbYd0Kom1q6RXgkjpYRlZbZU5Ktnnt45UWi6V/QaAJIeGsSuLzYB7bpdhl
         J0eDW+kGKeFKo3z6EbkYJWrKXalEsIPB86KMlAUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Zhang Yi <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 677/783] ext4: check and assert if marking an no_delete evicting inode dirty
Date:   Thu, 12 Jan 2023 14:56:33 +0100
Message-Id: <20230112135555.711825572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 318cdc822c63b6e2befcfdc2088378ae6fa18def upstream.

In ext4_evict_inode(), if we evicting an inode in the 'no_delete' path,
it cannot be raced by another mark_inode_dirty(). If it happens,
someone else may accidentally dirty it without holding inode refcount
and probably cause use-after-free issues in the writeback procedure.
It's indiscoverable and hard to debug, so add an WARN_ON_ONCE() to
check and detect this issue in advance.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220629112647.4141034-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -336,6 +336,12 @@ stop_handle:
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:
+	/*
+	 * Check out some where else accidentally dirty the evicting inode,
+	 * which may probably cause inode use-after-free issues later.
+	 */
+	WARN_ON_ONCE(!list_empty_careful(&inode->i_io_list));
+
 	if (!list_empty(&EXT4_I(inode)->i_fc_list))
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */


