Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F48715E6A0
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405222AbgBNQUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404825AbgBNQUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD882472C;
        Fri, 14 Feb 2020 16:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697230;
        bh=6iSZwHaW0ztzovYcB0ZaGJgcYLnZD6yj2W4g5zA0X9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHDaTMhyTCXVscgPXRRANiDBpMUwbOu6PucUIyTw9GosSLYN69S0bOh4KYKpVeA+X
         X6Nq1kvFwy9HxefsO5xnVCPzjUe8roXFZAa8/YM0mXxl+pXxP4ZGp5Iy9K3iBy4I5Q
         30YoEe6Rg2K39GWw82cz7rldYrZiKYvGx3bZ5C+k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 152/186] driver core: platform: fix u32 greater or equal to zero comparison
Date:   Fri, 14 Feb 2020 11:16:41 -0500
Message-Id: <20200214161715.18113-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
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
index e3d40c41c33b0..bcb6519fe2113 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -428,7 +428,7 @@ int platform_device_add(struct platform_device *pdev)
 		pdev->id = PLATFORM_DEVID_AUTO;
 	}
 
-	while (--i >= 0) {
+	while (i--) {
 		struct resource *r = &pdev->resource[i];
 		if (r->parent)
 			release_resource(r);
-- 
2.20.1

