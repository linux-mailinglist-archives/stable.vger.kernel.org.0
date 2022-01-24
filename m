Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58D49A058
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843836AbiAXXG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382484AbiAXW6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:58:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAB4C02B87B;
        Mon, 24 Jan 2022 13:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 942B9B81243;
        Mon, 24 Jan 2022 21:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C6AC340E7;
        Mon, 24 Jan 2022 21:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058778;
        bh=yCS3kdcuvrsLpG2x1smI/oLscK7914Esvp5KKO44Nv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1pYtNUec6sM6/7KbgnpE7CB9X+hB5illv/TepczY2eBiSYZP8zzTnz5ScK0bna8Z
         YkC7QgR5sISYbmDait3g5nYEjhqTZl7cWQYcH5mEFNYbU92WuIo0LNpVrgmwTWlgn7
         Jt3Byeak5i0WdZq9r5kSldj5rrs/yUu9U2Lc5ZVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0398/1039] debugfs: lockdown: Allow reading debugfs files that are not world readable
Date:   Mon, 24 Jan 2022 19:36:27 +0100
Message-Id: <20220124184138.697023872@linuxfoundation.org>
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
index 7d162b0efbf03..950c63fa4d0b2 100644
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



