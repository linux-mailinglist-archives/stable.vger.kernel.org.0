Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE94245C139
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347411AbhKXNPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348670AbhKXNNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:13:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C96461A8C;
        Wed, 24 Nov 2021 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757799;
        bh=BK13YRtjt4xo0x18ZkuwYfFykbkco/riE+U0evPBdqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdLcdSq1s9kCXy5vLpFehaNExNxBqbRU63S4hCinkrMip1NCKZOpD4F4BFpYghIdt
         GEeSThLwQsofXb+vGVY0Z2SXbCHbC3qm5mbinXBrA+EnUsBnmYpBuA7I3cqAzkHjCW
         q0oRRH8VvGwwKEpGTVqZ7nFcRrbGNvbXwNdf3fv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Lu Wei <luwei32@huawei.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 280/323] maple: fix wrong return value of maple_bus_init().
Date:   Wed, 24 Nov 2021 12:57:50 +0100
Message-Id: <20211124115728.348518599@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit bde82ee391fa6d3ad054313c4aa7b726d32515ce ]

If KMEM_CACHE or maple_alloc_dev failed, the maple_bus_init() will return 0
rather than error, because the retval is not changed after KMEM_CACHE or
maple_alloc_dev failed.

Fixes: 17be2d2b1c33 ("sh: Add maple bus support for the SEGA Dreamcast.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
Acked-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/maple/maple.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index e5d7fb81ad665..44a931d41a132 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -835,8 +835,10 @@ static int __init maple_bus_init(void)
 
 	maple_queue_cache = KMEM_CACHE(maple_buffer, SLAB_HWCACHE_ALIGN);
 
-	if (!maple_queue_cache)
+	if (!maple_queue_cache) {
+		retval = -ENOMEM;
 		goto cleanup_bothirqs;
+	}
 
 	INIT_LIST_HEAD(&maple_waitq);
 	INIT_LIST_HEAD(&maple_sentq);
@@ -849,6 +851,7 @@ static int __init maple_bus_init(void)
 		if (!mdev[i]) {
 			while (i-- > 0)
 				maple_free_dev(mdev[i]);
+			retval = -ENOMEM;
 			goto cleanup_cache;
 		}
 		baseunits[i] = mdev[i];
-- 
2.33.0



