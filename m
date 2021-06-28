Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72093B6383
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbhF1O5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236214AbhF1OzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16DA261CC1;
        Mon, 28 Jun 2021 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891060;
        bh=2IKbnHxMDnVBoUTL2DIlZzBwzV8l8nQCh3hScq+Pc10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5Jt+JZxDJjNNpiKTL3lHh5bmi2BFjy6GBBO9ODy/vEoZwt5dNfPkaG8OYkyO/UQi
         vx5VIasOIFlC2WoTTypzA4vkCc+x0nWoHAb8iCKCO4CqaXm35OihJY1fhCAHtOkfo/
         0yFAUrxEFcyI/VwEla/5kvFwAtDozkgk8XYV3A/LQrZgHB/L7tNpOkcoB5fWg0hp5k
         YxglKKTHaqKjU9Y1NXeS6mbYEA6w11iPjtCfmsFrbw8X8va9v4mf6ia5ruUq6kL0rW
         PPMraU4faEmQbCHm+b1GJUjwEvGZVskVlZ+4oj2YGLbzswpNe1r79MY3NyIbCMcE/C
         oWji3vPuUK7Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 82/88] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:36:22 -0400
Message-Id: <20210628143628.33342-83-sashal@kernel.org>
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
 drivers/net/ethernet/realtek/r8169.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 530b8da11960..191531a03415 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2355,7 +2355,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
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

