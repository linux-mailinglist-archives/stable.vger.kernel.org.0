Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F0B3B640F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbhF1PEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhF1PCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8FFF61D77;
        Mon, 28 Jun 2021 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891260;
        bh=2c4SdLcWZ1rC+EZJHcOg/uwJ+04fRZSNs78cXqgTGHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5Q1G+BC5srv3pbksHrlx10r2FLhDiSP684xSmxou/DOY5Che/Gr8Cy28Dn0/sH4V
         2TgzTi7C6Ov13D/+QasEqisf7ZoWzP/7Gy/wOfIgwlvc+ttQDnLwqMUt2vhM84Zc5E
         O6A6b51mauykS9NViJZuoN5+kpBGb+oO1n/kY48EayX2Pp1e25ekSt0VZq5iLsnhNZ
         mC9fQqg5lxVJTrQdFLvzbP+Xr0u0q2FOYvqXTunwdeLGAbjFwxmbxmKfaXSkvY3wbF
         X5ig9RRKnLB4g5Oc5xekuxWPnY5OL7tNzzgGXvdqGj7x7Wv+BeUBtApc0GpRcMdCrd
         E53ve99rMLlSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 64/71] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:39:56 -0400
Message-Id: <20210628144003.34260-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 99718abdc00e86e4f286dd836408e2834886c16e ]

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 6e74965d26a0..64fdea332886 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3938,7 +3938,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8152_gstrings, sizeof(rtl8152_gstrings));
+		memcpy(data, rtl8152_gstrings, sizeof(rtl8152_gstrings));
 		break;
 	}
 }
-- 
2.30.2

