Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52D862132B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbiKHNrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiKHNrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:47:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E7559876
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A382B81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826EDC433D6;
        Tue,  8 Nov 2022 13:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915249;
        bh=xNwpYVzmCKJScfX6RLX2mNswnYS9xsczopbYlZyNLSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hime5tbHtVFepCJrFHL2PjRbD4Wk3kK5wfTEoilRbDaHlaz/NbJ/CjvvgxyNqb0Gt
         4hJX/wkWqzMO9+GcL2X+Cx0JXST3xfVc1dAMkWRxj2tYrlzQHozrihGJnwYBrzgzdf
         V0FLMtwCsyZIyqJLxfyuse6ga7+kfAuDnaKC2cd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 32/48] btrfs: fix type of parameter generation in btrfs_get_dentry
Date:   Tue,  8 Nov 2022 14:39:17 +0100
Message-Id: <20221108133330.654671628@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

commit 2398091f9c2c8e0040f4f9928666787a3e8108a7 upstream.

The type of parameter generation has been u32 since the beginning,
however all callers pass a u64 generation, so unify the types to prevent
potential loss.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/export.c |    2 +-
 fs/btrfs/export.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -58,7 +58,7 @@ static int btrfs_encode_fh(struct inode
 }
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -19,7 +19,7 @@ struct btrfs_fid {
 } __attribute__ ((packed));
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation);
 struct dentry *btrfs_get_parent(struct dentry *child);
 


