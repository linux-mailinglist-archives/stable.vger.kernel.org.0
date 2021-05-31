Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CC239621F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhEaOvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhEaOtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5226140C;
        Mon, 31 May 2021 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469405;
        bh=oDyXkmvx+gQobzupFPp7+JRAht8mlIefsNOkh3GbdPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkmECldBmB+UjkJLzixyU55BCcWx21t9hf/yW8nJBAFAHct5vFzGE7ReRIWJdEzDg
         VFnhlLSWy1SDK+ixZ8Aon6Z/Mv3TapWE1s0CqjZu5OEBBCzkFu8fCy9IsrrUeP1AMZ
         RVn7T9mzTQ4ul7V7+JGleyEDQ5SGOHws6/SQG3Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 186/296] Revert "libertas: add checks for the return value of sysfs_create_group"
Date:   Mon, 31 May 2021 15:14:01 +0200
Message-Id: <20210531130710.125514808@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 46651077765c80a0d6f87f3469129a72e49ce91b ]

This reverts commit 434256833d8eb988cb7f3b8a41699e2fe48d9332.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit was incorrect, the error needs to be propagated back
to the caller AND if the second group call fails, the first needs to be
removed.  There are much better ways to solve this, the driver should
NOT be calling sysfs_create_group() on its own as it is racing userspace
and loosing.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-53-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index f5b78257d551..c611e6668b21 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -805,12 +805,7 @@ static void lbs_persist_config_init(struct net_device *dev)
 {
 	int ret;
 	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
-	if (ret)
-		pr_err("failed to create boot_opts_group.\n");
-
 	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
-	if (ret)
-		pr_err("failed to create mesh_ie_group.\n");
 }
 
 static void lbs_persist_config_remove(struct net_device *dev)
-- 
2.30.2



