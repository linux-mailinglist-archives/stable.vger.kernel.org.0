Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEBF60AC75
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiJXOHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbiJXOFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249EC4C613;
        Mon, 24 Oct 2022 05:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88B86B817AE;
        Mon, 24 Oct 2022 12:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EAEC433C1;
        Mon, 24 Oct 2022 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614989;
        bh=7nqqaqGTUrIsPz62h/ncaUsMRToIZJpG97d1QSfoPfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iCpit5egUFX5pqJmGCSLhfNz/E22ZWAPlnMZqGw75M+KsJ0K5rjQXVUGLJySEeUj
         kzi1AeGRvOlzAI4krTmJcTVlyOWHapJJUDAZlL6iudW/yw/1UeJo5HZPr34d3pjq9u
         ItE+jiOumfwSCRIRR12QWzTfTMcuNjbSlRphNnsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+fba8e2116a12609b6c59@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 080/530] btrfs: set generation before calling btrfs_clean_tree_block in btrfs_init_new_buffer
Date:   Mon, 24 Oct 2022 13:27:04 +0200
Message-Id: <20221024113048.630379815@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit cbddcc4fa3443fe8cfb2ff8e210deb1f6a0eea38 upstream.

syzbot is reporting uninit-value in btrfs_clean_tree_block() [1], for
commit bc877d285ca3dba2 ("btrfs: Deduplicate extent_buffer init code")
missed that btrfs_set_header_generation() in btrfs_init_new_buffer() must
not be moved to after clean_tree_block() because clean_tree_block() is
calling btrfs_header_generation() since commit 55c69072d6bd5be1 ("Btrfs:
Fix extent_buffer usage when nodesize != leafsize").

Since memzero_extent_buffer() will reset "struct btrfs_header" part, we
can't move btrfs_set_header_generation() to before memzero_extent_buffer().
Just re-add btrfs_set_header_generation() before btrfs_clean_tree_block().

Link: https://syzkaller.appspot.com/bug?extid=fba8e2116a12609b6c59 [1]
Reported-by: syzbot <syzbot+fba8e2116a12609b6c59@syzkaller.appspotmail.com>
Fixes: bc877d285ca3dba2 ("btrfs: Deduplicate extent_buffer init code")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4802,6 +4802,9 @@ btrfs_init_new_buffer(struct btrfs_trans
 	    !test_bit(BTRFS_ROOT_RESET_LOCKDEP_CLASS, &root->state))
 		lockdep_owner = BTRFS_FS_TREE_OBJECTID;
 
+	/* btrfs_clean_tree_block() accesses generation field. */
+	btrfs_set_header_generation(buf, trans->transid);
+
 	/*
 	 * This needs to stay, because we could allocate a freed block from an
 	 * old tree into a new tree, so we need to make sure this new block is


