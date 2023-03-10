Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBBF6B41C7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjCJN4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjCJN4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:56:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451F71151F1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A7F76187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46283C433EF;
        Fri, 10 Mar 2023 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456564;
        bh=mqR+W1Spb8Wbs1tqi686OAo9NQiSd+1DJo2tEzcrggk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3nub41Esgwb2NzQO+tW8vILNOV4M4607u+96Yg3zENlc9UCMBXi6hsPcmdL0ZF8q
         DeB36XfewikNeZa5IghQKP+gAjTePA7StuIFn95carl5XwnUxHxGWs6AS3/sFqRtjJ
         /7fIIpfFNsiv+OkO/rEX3Am1sJJkab18mBbT2rR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 016/211] f2fs: clear atomic_write_task in f2fs_abort_atomic_write()
Date:   Fri, 10 Mar 2023 14:36:36 +0100
Message-Id: <20230310133719.232185993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0e8d040bfa4c476d7d2a23119527c744c7de13cd ]

Otherwise, last .atomic_write_task will be remained in structure
f2fs_inode_info, resulting in aborting atomic_write accidentally
in race case. Meanwhile, clear original_i_size as well.

Fixes: 7a10f0177e11 ("f2fs: don't give partially written atomic data from process crash")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index af3059236f542..cf430f34d1968 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -201,9 +201,12 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 	clear_inode_flag(inode, FI_ATOMIC_FILE);
 	stat_dec_atomic_inode(inode);
 
+	F2FS_I(inode)->atomic_write_task = NULL;
+
 	if (clean) {
 		truncate_inode_pages_final(inode->i_mapping);
 		f2fs_i_size_write(inode, fi->original_i_size);
+		fi->original_i_size = 0;
 	}
 }
 
-- 
2.39.2



