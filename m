Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17533B6100
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhF1Ob2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234760AbhF1Oa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB1AC61CBC;
        Mon, 28 Jun 2021 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890409;
        bh=02Y6e3yR52rQTL00zjp3aZEJEqPN/kUlX4YwZMjPUYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=te4HzosbZtSKvymU/vIvE4bapleN3Iwgk47pISuILI26jV2E6sxHgbvFI2UiRa5pI
         MLr6cur/tO8ZyAoPph5r8XstrHr+XkIRgpEcpGhWBTtH9aHUyv34ZtE7djE14JD5di
         /yx9coQunh7yfwSAO02GBAGYdbCDoUlhiMX5uPjj6KmNtLrcZjHzaSbPFc+sTAUViz
         74OhSx5wojoHp1AYEOEbrCv3tWIeLWtWcFETTAZfDv+Fy0CckbEYYrhaC4JS6/tDIA
         1GuAeyR9TtZuVrKfUsYhkwwnvIvxnrRexHhJlhXnztnMjDCXLK0XbMiUMfKFlwsELB
         OKJhMGP74DynA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/101] sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:25:13 -0400
Message-Id: <20210628142607.32218-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 6d84266c03ca..5cab2d3c0023 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2287,7 +2287,7 @@ static void sh_eth_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
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

