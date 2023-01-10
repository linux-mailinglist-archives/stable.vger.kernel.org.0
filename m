Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26BD664A86
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbjAJSdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbjAJSch (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53534E79
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:28:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F045CB81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CF8C433D2;
        Tue, 10 Jan 2023 18:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375315;
        bh=klK8k98N1/aMAR8o70ZfvSD3KevfMpw7nLCKsWQzM/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUQymJ2HoGqf+bcgQ9kqKzwK5XM0vzvCHpvCSLAfypUuj+W4sSDLWOmLOouQdWwwc
         fU95ZwIE5a3UcNRIw9f/9ZGd+ogsEKbOoqhuIvaqfiAcoAgAuISKfEJtb2a8K2ZpLH
         etC1w86sBJVxVgbVu4ZjuevL5KvCAEOb1BM3h+HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Zhang Yi <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.15 149/290] ext4: check and assert if marking an no_delete evicting inode dirty
Date:   Tue, 10 Jan 2023 19:04:01 +0100
Message-Id: <20230110180036.980717866@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
@@ -338,6 +338,12 @@ stop_handle:
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
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */


