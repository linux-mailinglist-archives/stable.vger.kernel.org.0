Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C046677B1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbjALOqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbjALOqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:46:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37745AC69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:34:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86A89B81E78
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3DFC433D2;
        Thu, 12 Jan 2023 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534071;
        bh=15uRru/oWodIcC1hJsZ6kzwXpAPzJSl+XxzYuyi2LHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yldMLDgBcKUXmUPSCVDlOnCkCv56xoHawrMkL/XynIb9/5llDrzxrU7+sqvQ1UbJ4
         SpRBdcAM2acNtiewQ+IcSBKTmO1YfBjo6yBlzNEserWp9a0Z/RC0+r4tvjSFXSYwAJ
         pYen0amnU0bI2XLpnfnmdeUFABa/Of5V+Fzg1pfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        stable@kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 685/783] ext4: initialize quota before expanding inode in setproject ioctl
Date:   Thu, 12 Jan 2023 14:56:41 +0100
Message-Id: <20230112135556.071367921@linuxfoundation.org>
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
@@ -495,6 +495,10 @@ static int ext4_ioctl_setproject(struct
 	if (ext4_is_quota_file(inode))
 		return err;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		return err;
@@ -510,10 +514,6 @@ static int ext4_ioctl_setproject(struct
 		brelse(iloc.bh);
 	}
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);


