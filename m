Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB88211842
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgGBB0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgGBB0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 366022083E;
        Thu,  2 Jul 2020 01:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653181;
        bh=73609KfXOAIqlc6B/woCVMBcJsoRgZARJtEgN0Js7a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyJzOPbjdXTykmA2AtsLAJrBLBqP3Hq1VIIOhIK6bZAm3mL7Mws7iBOAjJYIwb+aN
         2qohf5S9xY2IwVEJZ47TOx3e0oUhO0kJjkv9ZrZ9rORAHqow7wLkyQqufBHyIjE4Bh
         TbR7fLhpgACV/RHLKgS5CqlkjRwSs67gBnfmkqj8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/27] btrfs: use kfree() in btrfs_ioctl_get_subvol_info()
Date:   Wed,  1 Jul 2020 21:25:53 -0400
Message-Id: <20200702012615.2701532-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit b091f7fede97cc64f7aaad3eeb37965aebee3082 ]

In btrfs_ioctl_get_subvol_info(), there is a classic case where kzalloc()
was incorrectly paired with kzfree(). According to David Sterba, there
isn't any sensitive information in the subvol_info that needs to be
cleared before freeing. So kzfree() isn't really needed, use kfree()
instead.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a5ae02bf3652b..60418b1fcef5b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2723,7 +2723,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 
 out:
 	btrfs_free_path(path);
-	kzfree(subvol_info);
+	kfree(subvol_info);
 	return ret;
 }
 
-- 
2.25.1

