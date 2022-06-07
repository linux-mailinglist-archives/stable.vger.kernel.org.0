Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5CB54232C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiFHCQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 22:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444768AbiFHCLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 22:11:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23DB254EC4;
        Tue,  7 Jun 2022 12:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 040536192F;
        Tue,  7 Jun 2022 19:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A17C341C0;
        Tue,  7 Jun 2022 19:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629510;
        bh=FjpVwRVNYYlAGn7k/OHLaxc52wPen+gS9TwWMFYhhXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCyVpjk1fjuXHH9A6PXLj8ci8B/JapyI6SHik/kMIH9uxTn5hJ7EJ4f6j1GPBZ84U
         9ieQuiZuN7HuAILSblgBVMbd9CcdQR/IvO2RENcUtp1yHc1cYFH/S//3WNXb8Yxzlv
         Kj/7KxSTlcuzOd3ot4/Ye5wP2FlvY933PyFz/SJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.18 715/879] f2fs: fix fallocate to use file_modified to update permissions consistently
Date:   Tue,  7 Jun 2022 19:03:53 +0200
Message-Id: <20220607165023.608176335@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 958ed92922028ec67f504dcdc72bfdfd0f43936a upstream.

This patch tries to fix permission consistency issue as all other
mainline filesystems.

Since the initial introduction of (posix) fallocate back at the turn of
the century, it has been possible to use this syscall to change the
user-visible contents of files.  This can happen by extending the file
size during a preallocation, or through any of the newer modes (punch,
zero, collapse, insert range).  Because the call can be used to change
file contents, we should treat it like we do any other modification to a
file -- update the mtime, and drop set[ug]id privileges/capabilities.

The VFS function file_modified() does all this for us if pass it a
locked inode, so let's make fallocate drop permissions correctly.

Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1774,6 +1774,10 @@ static long f2fs_fallocate(struct file *
 
 	inode_lock(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		if (offset >= inode->i_size)
 			goto out;


