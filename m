Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBF3B6018
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhF1OWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232678AbhF1OVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E006E61C80;
        Mon, 28 Jun 2021 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889953;
        bh=R+x4Wqwj5RgMy8VT/r7q7vt2Ruh37Eil2G6Zb2Z7jxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mddjBmre6RWFOY0pT+uEdnyU779PgFNP38XOoSJPFqio1YB6Xy2WCMekxiJQSbFoJ
         3j6YtaHxWbEtpjTMEJCwVBxom70ejpj3AucsXk7U2nuiWjhcl0SwiadYFhxsjA+i0h
         mBT3mga86XJ1DtoSVPOXR9XBkavAd1WZU2d0vFvSU5dpApXlzj1lsvtEYtnMje8ea/
         d/YTenblLI82iAgfyiKfupsdDMOlTVW2+EO9MYf2KwCrfUejHsDOT2frJBm28Y+oYu
         q+jTtRlEXuZBHzYn5KMvKhb0DN5MHBWIRgM8krJwPMufqZpJTmYPm5bSAY6sJX1jcd
         Ee4EJBPxGNUbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 051/110] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:17:29 -0400
Message-Id: <20210628141828.31757-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit da5ac772cfe2a03058b0accfac03fad60c46c24d ]

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
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1df2c002c9f6..f7a56e05ec8a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1673,7 +1673,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch(stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8169_gstrings, sizeof(rtl8169_gstrings));
+		memcpy(data, rtl8169_gstrings, sizeof(rtl8169_gstrings));
 		break;
 	}
 }
-- 
2.30.2

