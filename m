Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7557339604D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhEaOY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234021AbhEaOWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F409619EE;
        Mon, 31 May 2021 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468719;
        bh=SqjKvzL/9wcAch+fn06ik3D6/zS8+xJL9bETZFokctA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQSHsNnVW0iXdOLsR13hU+dVvzw/fyAJ9V12p5zwksqH6SMXT4mgmz+cJ2QAo73eJ
         +D9/NYq0sEcFCd3y4EFRULP8zybheU9nYv24POwP3dE3gFV9lxoBbHu7mO21+llYcO
         7It+sAcR862q9//dkNSIBQyDyHGI4A9Zf1eAVq+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/177] Revert "isdn: mISDNinfineon: fix potential NULL pointer dereference"
Date:   Mon, 31 May 2021 15:14:18 +0200
Message-Id: <20210531130651.391051444@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit abd7bca23bd4247124265152d00ffd4b2b0d6877 ]

This reverts commit d721fe99f6ada070ae8fc0ec3e01ce5a42def0d9.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit was incorrect, it should have never have used
"unlikely()" and if it ever does trigger, resources are left grabbed.

Given there are no users for this code around, I'll just revert this and
leave it "as is" as the odds that ioremap() will ever fail here is
horrendiously low.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-41-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/mISDNinfineon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index f4cb29766888..d62006bab9c6 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -697,11 +697,8 @@ setup_io(struct inf_hw *hw)
 				(ulong)hw->addr.start, (ulong)hw->addr.size);
 			return err;
 		}
-		if (hw->ci->addr_mode == AM_MEMIO) {
+		if (hw->ci->addr_mode == AM_MEMIO)
 			hw->addr.p = ioremap(hw->addr.start, hw->addr.size);
-			if (unlikely(!hw->addr.p))
-				return -ENOMEM;
-		}
 		hw->addr.mode = hw->ci->addr_mode;
 		if (debug & DEBUG_HW)
 			pr_notice("%s: IO addr %lx (%lu bytes) mode%d\n",
-- 
2.30.2



