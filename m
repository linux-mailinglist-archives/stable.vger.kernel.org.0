Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46B26B42A0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjCJOE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjCJOEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:04:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305F31499B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB2BEB822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0BFC4339E;
        Fri, 10 Mar 2023 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457086;
        bh=q9SXpEIEJ7CN0EDtwiiA2258JISseLm5FqIEvlREOMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfMay3uRZbbhISJlPyjbnE2zAvkg7t6XKgEAirrL/v928phWXNmXPW0iv2FmlXESU
         Dw4ynerxBl8bpIdGV/hrcSNTS+GtNbszRAGeOAXnndYa/O7YXQez91dGIANWtblzF8
         IKrfkS1cvpdbCR0BhtZ35IxWy7QjEUD6SL8buAps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/200] f2fs: clear atomic_write_task in f2fs_abort_atomic_write()
Date:   Fri, 10 Mar 2023 14:37:03 +0100
Message-Id: <20230310133717.541462441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index 60d79e427f988..63c6894099799 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -200,9 +200,12 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
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



