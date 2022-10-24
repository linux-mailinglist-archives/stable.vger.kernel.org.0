Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC2460AAEA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiJXNmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiJXNlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:41:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5ABB3B04;
        Mon, 24 Oct 2022 05:38:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9088F61326;
        Mon, 24 Oct 2022 12:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E0C433D6;
        Mon, 24 Oct 2022 12:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615052;
        bh=rEC/jNmzP26VTMds8NVsPf5tqRzefsXbvPgDYAJAvbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whDMkzeKVL6HHFYYSKCHYSndVsHNczgvj5ZqLBEqoaEmgI+Ogiy+pxB6FzB4xkrH4
         kqhqrcOejkKwGhRGaUTfkqU7g8VyTP/ZBVjIIuYbflX0ASKmSl2zB4axqFKXgejOYV
         WpdyOmZsw1wjPLEI3qW/ZPt/n3JWpc8lP2+q5cq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 096/530] ext4: dont increase iversion counter for ea_inodes
Date:   Mon, 24 Oct 2022 13:27:20 +0200
Message-Id: <20221024113049.362333658@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

commit 50f094a5580e6297bf10a807d16f0ee23fa576cf upstream.

ea_inodes are using i_version for storing part of the reference count so
we really need to leave it alone.

The problem can be reproduced by xfstest ext4/026 when iversion is
enabled. Fix it by not calling inode_inc_iversion() for EXT4_EA_INODE_FL
inodes in ext4_mark_iloc_dirty().

Cc: stable@kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Link: https://lore.kernel.org/r/20220824160349.39664-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5701,7 +5701,12 @@ int ext4_mark_iloc_dirty(handle_t *handl
 	}
 	ext4_fc_track_inode(handle, inode);
 
-	if (IS_I_VERSION(inode))
+	/*
+	 * ea_inodes are using i_version for storing reference count, don't
+	 * mess with it
+	 */
+	if (IS_I_VERSION(inode) &&
+	    !(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
 		inode_inc_iversion(inode);
 
 	/* the do_update_inode consumes one bh->b_count */


