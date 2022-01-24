Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8773499040
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353102AbiAXT7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41276 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356179AbiAXTxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:53:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427D8B811F9;
        Mon, 24 Jan 2022 19:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E6CC340E7;
        Mon, 24 Jan 2022 19:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054019;
        bh=v/uAKWoENKRN5LqOTFj36NcBgFNJnU9A42i7wUgs0l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2di109X09x2uw5MWWvhQAIoZ6whhU1Jl39tTPrjZFEPlzg+HWdxKN26vdDBiVetsr
         PD1yQ+IMPsm3aAaVQBkPxoPtGEunE6YZnl8cQiS1smxAbmGcQ8lj2iWuUid8DjNIZ8
         OVMv1BM3bEmQf2Dok8g/DoIRzk6idPMAP5St/ZUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/563] debugfs: lockdown: Allow reading debugfs files that are not world readable
Date:   Mon, 24 Jan 2022 19:39:44 +0100
Message-Id: <20220124184032.026535046@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 358fcf5ddbec4e6706405847d6a666f5933a6c25 ]

When the kernel is locked down the kernel allows reading only debugfs
files with mode 444. Mode 400 is also valid but is not allowed.

Make the 444 into a mask.

Fixes: 5496197f9b08 ("debugfs: Restrict debugfs when the kernel is locked down")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/20220104170505.10248-1-msuchanek@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 3aa5eb9ce498e..96059af28f508 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -147,7 +147,7 @@ static int debugfs_locked_down(struct inode *inode,
 			       struct file *filp,
 			       const struct file_operations *real_fops)
 {
-	if ((inode->i_mode & 07777) == 0444 &&
+	if ((inode->i_mode & 07777 & ~0444) == 0 &&
 	    !(filp->f_mode & FMODE_WRITE) &&
 	    !real_fops->unlocked_ioctl &&
 	    !real_fops->compat_ioctl &&
-- 
2.34.1



