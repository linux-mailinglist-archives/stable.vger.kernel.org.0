Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A011499393
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385926AbiAXUer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51730 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383978AbiAXU2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E9E61383;
        Mon, 24 Jan 2022 20:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457C2C340E5;
        Mon, 24 Jan 2022 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056084;
        bh=yCS3kdcuvrsLpG2x1smI/oLscK7914Esvp5KKO44Nv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OImHXflqfPZD7FLfzY1PYEEiCkbgdpw1nvJa/9ExwUDQPXNsn3igH+zlUrvhQ6Kny
         LPDPXHEPRewv7d1Twta02wSQGGg8dSQPb7nNfkbJhPptW5Rc7ivThnaoX/3tU5xVNq
         zVd/c6oBtjNhcru3U5Ng913ruzs7mP8rlkVJosdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/846] debugfs: lockdown: Allow reading debugfs files that are not world readable
Date:   Mon, 24 Jan 2022 19:37:29 +0100
Message-Id: <20220124184112.361816489@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



