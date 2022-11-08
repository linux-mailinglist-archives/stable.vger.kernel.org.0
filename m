Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461836212AF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiKHNmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiKHNll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:41:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5127D4509B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0364DB81AA1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E06CC433D6;
        Tue,  8 Nov 2022 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914897;
        bh=LfOHEKCt9cOBzFlgCsgHS1k+f7TrtHDUoI48gMEK0Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHIiOc1YsQrMqoDVqDdiTYPuD/bn6w412IkhIeyY3YNWvJmaIIHP6dv8mccFlVocW
         HFrg0ANOl5hwVUlmPo71Zhl2JVtPAsu/5PXLyOxGeG7M5qH1SC18Sa3Kr3sz+gLioe
         uvhoTN0HlhTpzObxepUvWhIqDKBiJs7sZdeKBFqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 21/30] btrfs: fix type of parameter generation in btrfs_get_dentry
Date:   Tue,  8 Nov 2022 14:39:09 +0100
Message-Id: <20221108133327.515382734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
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
@@ -56,7 +56,7 @@ static int btrfs_encode_fh(struct inode
 }
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
--- a/fs/btrfs/export.h
+++ b/fs/btrfs/export.h
@@ -17,7 +17,7 @@ struct btrfs_fid {
 } __attribute__ ((packed));
 
 struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				u64 root_objectid, u32 generation,
+				u64 root_objectid, u64 generation,
 				int check_generation);
 struct dentry *btrfs_get_parent(struct dentry *child);
 


