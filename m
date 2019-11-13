Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A86FA4EE
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfKMCTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbfKMBzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B394204EC;
        Wed, 13 Nov 2019 01:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610103;
        bh=+G/Hb5yXy8J1/R9Fa07bK3eEpG/8DlxjsJp1lvjGrEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBBamO5DQU9+aeIQ8Cmh1a8JKUqQYHsOT2XOiy9hp/nMomR/HajDtj1m5UENruY2l
         q4DtwYkb9P4pQqq8a6sB+rpmXe2iLOOS8VepXoh+cxYeURfJpB0zOmg/umzLl8GMEd
         ktUfeS6zqtQHcTk5ODhBwdlJ1KJdjmZ0iuEGBCF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wang6495@umn.edu>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 163/209] media: isif: fix a NULL pointer dereference bug
Date:   Tue, 12 Nov 2019 20:49:39 -0500
Message-Id: <20191113015025.9685-163-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

[ Upstream commit a26ac6c1bed951b2066cc4b2257facd919e35c0b ]

In isif_probe(), there is a while loop to get the ISIF base address and
linearization table0 and table1 address. In the loop body, the function
platform_get_resource() is called to get the resource. If
platform_get_resource() returns NULL, the loop is terminated and the
execution goes to 'fail_nobase_res'. Suppose the loop is terminated at the
first iteration because platform_get_resource() returns NULL and the
execution goes to 'fail_nobase_res'. Given that there is another while loop
at 'fail_nobase_res' and i equals to 0, one iteration of the second while
loop will be executed. However, the second while loop does not check the
return value of platform_get_resource(). This can cause a NULL pointer
dereference bug if the return value is a NULL pointer.

This patch avoids the above issue by adding a check in the second while
loop after the call to platform_get_resource().

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/isif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index f924e76e2fbf8..340f8218f54d3 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1100,7 +1100,8 @@ static int isif_probe(struct platform_device *pdev)
 
 	while (i >= 0) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		release_mem_region(res->start, resource_size(res));
+		if (res)
+			release_mem_region(res->start, resource_size(res));
 		i--;
 	}
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
-- 
2.20.1

