Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565A93B6381
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhF1O53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236199AbhF1Oy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC6361CBC;
        Mon, 28 Jun 2021 14:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891059;
        bh=Y8LH12gw3ai5GFatjMPXNOpi11MLQkzPyNHpM21pDus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkTx/XUcxWv2OrIkajnLsSah+wg44qszPPWRzT4w/rlV2k3oMciRkd0hEG8oGs/WR
         mUBXnmixBDdk3JwbqgN640XS9HFpXRPVwDRRFAhPkflwVd2RXsQ2kFCWPggZHb0pll
         ANGzaL6higb8U1TJY3wo3uMGCq/LEGX1IChBgTDdfwnM9R4qRc58NVevj0kQnflKdz
         Dy3Pr3LYaxH9zh6Pk9rlUpF1tFNGszQP9ZkSMO9SAzQIWiebusdb915WT42sG0r3Kc
         4EqiTiHx5V385PS4qaC+3i9AHtHdtqqxm76F7x8kuOVUFwBIiAcJmLRqQNFT4rSfY7
         19QLlJwFCbTpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 80/88] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:36:20 -0400
Message-Id: <20210628143628.33342-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index f9c531a6ce06..8da3c891c9e8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4640,7 +4640,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
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

