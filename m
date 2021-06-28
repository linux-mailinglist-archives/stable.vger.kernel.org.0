Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F673B61AB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhF1Ohc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234624AbhF1Of3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DC9B61CA4;
        Mon, 28 Jun 2021 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890634;
        bh=IvfwO7W+m151QZkIJivbN4TRV5E5e7WHbaY6qjOWgaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPtQ6Q3X49j+96hWTbr3G2QUCp7qQ/q1Ma7chQvBthMKhPYqEGd2u96awrNPOAbrY
         Nnst6VSGHVe75WTgfHmU9xOddPFLxezZHmxfZbBbKJluhV4HOPhY2wAY8R47tZbkKk
         IaMp8oPdvlBLqkxy+5rIy7z++3ts0TjmKuhVPXfAqrJfTq+6pNOwxx9QHQ12lKJksg
         kpslW+5p19GEr8b8ukKe73i9k6Hl/oOhiJdWe4Zi2enrlz9UYU52UqUIzzCCUVUUkt
         OtzbZ5dwW/NUgBf6ggucXEPeaBCp7tLYNQ8vZGyaGeN3lTK/1DZBrSPZudcF72/+/9
         CVN1l1YNyG7eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/71] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:29:25 -0400
Message-Id: <20210628143004.32596-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index 8ff178fc2670..661202e85412 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1801,7 +1801,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
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

