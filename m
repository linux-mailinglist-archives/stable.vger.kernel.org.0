Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A28E65D807
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbjADQK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbjADQJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2296F3C39A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D868CB8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E7DC433F0;
        Wed,  4 Jan 2023 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848578;
        bh=EmGRuQejFU6pqmw/+KxpjNHHIOHj+6GvddIAknnB/M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnA9ShWuiY+fvmChvcmTrETHl/LeA17ayVVGAfajTu3V2o3JxjM3p4cVO6UHj+ViV
         Hii/KreJasDTDThMTXPtj9H59Cy7E/pU5otxnGo0pYiqxd41Pryzr6gvMd4tlBGZOO
         Wou52G9Iism3CrBauzpnp8zj1OzJdBk4kDmwtTlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 020/207] btrfs: fix uninitialized parent in insert_state
Date:   Wed,  4 Jan 2023 17:04:38 +0100
Message-Id: <20230104160512.560119106@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit d7c9e1be2876f63fb2178a24e0c1d5733ff98d47 upstream.

I don't know how this isn't caught when we build this in the kernel, but
while syncing extent-io-tree.c into btrfs-progs I got an error because
parent could potentially be uninitialized when we link in a new node,
specifically when the extent_io_tree is empty.  This means we could have
garbage in the parent color.  I don't know what the ramifications are of
that, but it's probably not great, so fix this by initializing parent to
NULL.  I spot checked all of our other usages in btrfs and we appear to
be doing the correct thing everywhere else.

Fixes: c7e118cf98c7 ("btrfs: open code rbtree search in insert_state")
CC: stable@vger.kernel.org # 6.0+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-io-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -397,7 +397,7 @@ static int insert_state(struct extent_io
 			u32 bits, struct extent_changeset *changeset)
 {
 	struct rb_node **node;
-	struct rb_node *parent;
+	struct rb_node *parent = NULL;
 	const u64 end = state->end;
 
 	set_state_bits(tree, state, bits, changeset);


