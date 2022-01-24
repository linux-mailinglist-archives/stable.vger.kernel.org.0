Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1B0498D7D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345793AbiAXTci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57230 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352248AbiAXT34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766B1614A8;
        Mon, 24 Jan 2022 19:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADC1C340E5;
        Mon, 24 Jan 2022 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052595;
        bh=O/qVZZaNBQiKTU8XF9hX2SxNcvEqCW1/ktGfMh8W1do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7t4615pcgK+kytOpfJzkyLgirFBjQDV43Up3KDH74iONvFq8YDNLUzoxzX/oHZQV
         +Qp5WfdcI0tsgx6uSTcfu8lDswwzVoHyY3DZN5MXz1QEHS6VL34mvWWAeBv47xN7f4
         ceJ2KO9t+6B0tGcPm5BlVQjptVwsHicKu0+DhoMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/320] debugfs: lockdown: Allow reading debugfs files that are not world readable
Date:   Mon, 24 Jan 2022 19:41:36 +0100
Message-Id: <20220124183957.523671417@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index a32c5c7dcfd89..da87615ad69a7 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -146,7 +146,7 @@ static int debugfs_locked_down(struct inode *inode,
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



