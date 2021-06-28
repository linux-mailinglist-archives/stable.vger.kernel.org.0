Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC2D3B6382
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbhF1O5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236197AbhF1Oy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5127C61CBE;
        Mon, 28 Jun 2021 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891059;
        bh=Kd9a3ZNmyTVW0IOsoOLCiBjQhKEGktUcBWuBImjJLo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UetLDCQrCkSAM6egiUJI4QzD7gF9kEHiMtKvfzEX61hp0THP4x/1jU7xpEJkuGsGc
         dSQ6FmMabEi8hx++1F3DLxOenjpvLsNcskpjIdsDkOiABv0CDd1GT6bG/nu6ABb/LH
         Nd1NXSt5X9gJ58Z3NqyZ49aaU3OayXC/guoNjM9HFhq+b3S9qylikVHC/fFQImzzZU
         oD8+nnQAdrDTbS5dPccYGD0R1bs5ukJwVInPzgxsNdCCpxXt4LdaI9tqVv9Ous+Oy4
         4fCAOT8uPr4RyP7FJoDj2bMZMcA/FOnbik8Whqhhr76mtvr96EWrLV6/AZ0VPPqSPU
         lsQoYrVcUfZJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 81/88] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:36:21 -0400
Message-Id: <20210628143628.33342-82-sashal@kernel.org>
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

[ Upstream commit 224004fbb033600715dbd626bceec10bfd9c58bc ]

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
 drivers/net/ethernet/renesas/sh_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index dab1597287b9..36f1019809ea 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2197,7 +2197,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *sh_eth_gstrings_stats,
+		memcpy(data, sh_eth_gstrings_stats,
 		       sizeof(sh_eth_gstrings_stats));
 		break;
 	}
-- 
2.30.2

