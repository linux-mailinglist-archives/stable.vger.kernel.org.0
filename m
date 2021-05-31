Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3E395EB6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhEaOCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhEaOAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B74E06193E;
        Mon, 31 May 2021 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468189;
        bh=L6/9C92JDBgplMtoVklmzjavKJBt2S6f6PqJFK2r8qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTh3wckzEVvbVXoQOaqeEVz4x5DzPQarO+SUD0CvVkb+MiOEAF9lWuZ6jdsrhtPbt
         OQ0RWOw10K1+34pS3Hy4RUSOwTQqhL4rhRFZIsZgQSOxVctgSf1SgdS18DG3xOa+W/
         hT7eXjuFJWdWv4PvjgWIU3sKZh71r1hysufwqbac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/252] Revert "isdn: mISDNinfineon: fix potential NULL pointer dereference"
Date:   Mon, 31 May 2021 15:13:33 +0200
Message-Id: <20210531130703.045093010@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index a16c7a2a7f3d..fa9c491f9c38 100644
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



