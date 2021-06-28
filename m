Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E973F3B6473
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhF1PI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237387AbhF1PFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E1061D86;
        Mon, 28 Jun 2021 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891421;
        bh=CpiTn6fwGgaGXTMYGMgfNW+cWjoAaiD92xplXobmz54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSHm3nCfhbQrS70aBVluumg9tPJ/3Q0MlYHlAA+lAHAfHc7ZjaPUjIjQF4B/UQoiC
         GzXq9AJVUlfztgeKmYp/KFYKFuv5iGzflZGSie1yvkg3xQ8muqDi1/dwY66JxPUX7I
         oOCl0GXiNVRXxlrHT95cRTKMChfPrsc4qs6v2vxWi5QQXq0hLi4V8c+mYDiYlauEs/
         +lxMcy+DoxPd02XvfDEoBj7HX/K8KAoIGJibREqDFj2zO171GRvR+z5cxIuf7nNn6w
         aGU5og47WJiCutrxeFpjyvAQcPDNMmJtQg9D+i66QDd0qGfxyWMYHFCXXPUdsTfInC
         Th8Yl/hEYIkhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 51/57] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 28 Jun 2021 10:42:50 -0400
Message-Id: <20210628144256.34524-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index 27e9c089b2fc..5baaa8291624 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3820,7 +3820,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
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

