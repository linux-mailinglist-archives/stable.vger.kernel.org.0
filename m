Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF344995F5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359603AbiAXU5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442151AbiAXUxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C3BB60C44;
        Mon, 24 Jan 2022 20:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558C5C340E7;
        Mon, 24 Jan 2022 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057608;
        bh=aMCzFlePstTjSYJQ1nZqs+s14GvcDB63SuiLw1DajFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfBWG2HCv0cgatgK0bgK+OCop9SWQXrdyqryrlASyUZJgY01IKeLGHDV5rUzHPfyS
         8rVeUouRvc2xS68Ctbi6UF36KCT+XfIbmpLJqGWbDVi/ZSYcJOKfdiftHgHXlpKjc2
         V+G+UJGYuoEb+Ztv71b48L3szABS78Xwsv/WBo1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.16 0013/1039] f2fs: avoid EINVAL by SBI_NEED_FSCK when pinning a file
Date:   Mon, 24 Jan 2022 19:30:02 +0100
Message-Id: <20220124184125.591885196@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 19bdba5265624ba6b9d9dd936a0c6ccc167cfe80 upstream.

Android OTA failed due to SBI_NEED_FSCK flag when pinning the file. Let's avoid
it since we can do in-place-updates.

Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    7 +++++--
 fs/f2fs/file.c |   10 +++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2617,6 +2617,11 @@ bool f2fs_should_update_outplace(struct
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
+	/* The below cases were checked when setting it. */
+	if (f2fs_is_pinned_file(inode))
+		return false;
+	if (fio && is_sbi_flag_set(sbi, SBI_NEED_FSCK))
+		return true;
 	if (f2fs_lfs_mode(sbi))
 		return true;
 	if (S_ISDIR(inode->i_mode))
@@ -2625,8 +2630,6 @@ bool f2fs_should_update_outplace(struct
 		return true;
 	if (f2fs_is_atomic_file(inode))
 		return true;
-	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
-		return true;
 
 	/* swap file is migrating in aligned write mode */
 	if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3143,17 +3143,17 @@ static int f2fs_ioc_set_pin_file(struct
 
 	inode_lock(inode);
 
-	if (f2fs_should_update_outplace(inode, NULL)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (!pin) {
 		clear_inode_flag(inode, FI_PIN_FILE);
 		f2fs_i_gc_failures_write(inode, 0);
 		goto done;
 	}
 
+	if (f2fs_should_update_outplace(inode, NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (f2fs_pin_file_control(inode, false)) {
 		ret = -EAGAIN;
 		goto out;


