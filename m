Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E7765D97C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbjADQZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbjADQZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C8B4318D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5012B61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55609C433EF;
        Wed,  4 Jan 2023 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849476;
        bh=4aVomUC427AMNaaw43UgXdo47FNOPAhP+Zw1KAFJmDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXsM24XlHTh4FtOy9BeymUL/mFhvqt6SUFPzyRGlP1BFt1UV32qFfypFdiT/PdaDM
         lCr/uBjFSOAgeBgdYJP7V29WMpkzD/QthgxKA46regpomYB6Hwz7+QEXzwRJZrqc7E
         bE2NDOy9TJmy3+CKHVErmP6Rl7Sgwlt4wUXKdSvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        stable@kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 195/207] ext4: initialize quota before expanding inode in setproject ioctl
Date:   Wed,  4 Jan 2023 17:07:33 +0100
Message-Id: <20230104160518.084704553@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 1485f726c6dec1a1f85438f2962feaa3d585526f upstream.

Make sure we initialize quotas before possibly expanding inode space
(and thus maybe needing to allocate external xattr block) in
ext4_ioctl_setproject(). This prevents not accounting the necessary
block allocation.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221207115937.26601-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -732,6 +732,10 @@ static int ext4_ioctl_setproject(struct
 	if (ext4_is_quota_file(inode))
 		return err;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		return err;
@@ -747,10 +751,6 @@ static int ext4_ioctl_setproject(struct
 		brelse(iloc.bh);
 	}
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);


