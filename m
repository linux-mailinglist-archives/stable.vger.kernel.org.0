Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEDD15E279
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405707AbgBNQXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392933AbgBNQXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C34024779;
        Fri, 14 Feb 2020 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697422;
        bh=boCaJ9AjUkm8HQ1bECcY0cYl3TSL6GThXcOQvvRZlhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBgVGRYwZokQh18N+CDrt8QS6QqIKmFxFkuUcsV2sF/5s2W3YAWLShu4FANU12E7F
         PVVQBaa1nf8QJz+t4k1MuZVKnZlZbhL6yiVQKXdUPRBSfwEvSw9VVWkm5k0KY8T3K4
         XTWkp7+xX/1XGeTzqA+PzIKiHqTikaehJ9QjGtW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 112/141] driver core: platform: fix u32 greater or equal to zero comparison
Date:   Fri, 14 Feb 2020 11:20:52 -0500
Message-Id: <20200214162122.19794-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0707cfa5c3ef58effb143db9db6d6e20503f9dec ]

Currently the check that a u32 variable i is >= 0 is always true because
the unsigned variable will never be negative, causing the loop to run
forever.  Fix this by changing the pre-decrement check to a zero check on
i followed by a decrement of i.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 39cc539f90d0 ("driver core: platform: Prevent resouce overflow from causing infinite loops")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200116175758.88396-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 6cdc198965f5a..bef299ef62276 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -418,7 +418,7 @@ int platform_device_add(struct platform_device *pdev)
 		pdev->id = PLATFORM_DEVID_AUTO;
 	}
 
-	while (--i >= 0) {
+	while (i--) {
 		struct resource *r = &pdev->resource[i];
 		if (r->parent)
 			release_resource(r);
-- 
2.20.1

