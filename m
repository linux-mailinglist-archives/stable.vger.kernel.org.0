Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75011313F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfLDR5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:57:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbfLDR5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:57:39 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8782084F;
        Wed,  4 Dec 2019 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482258;
        bh=2NavNmSSRIUFC61aNh873EINxN+3wfIG+QCBYvnDcQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fva8FOMlG6vW8ZE7UodUEzonD5B/Hv7hj6DM6jRlwYu+8rrZxFpu/I9yJi4h1t6mn
         /FrxNoUEGkt2BVgqKak4ndFPig5nRmG8C7fuI98MjHy0mBlpWNUR+vfU2sD+j8EssC
         nKzZYVwQdhcQYL41lPHYVftzgbnfl4M1wxEOiwJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Kevin Hilman <khilman@baylibre.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/92] PM / AVS: SmartReflex: NULL check before some freeing functions is not needed
Date:   Wed,  4 Dec 2019 18:49:15 +0100
Message-Id: <20191204174330.335727209@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

[ Upstream commit 14d338a857f05f894ba3badd9e6d3039c68b8180 ]

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/avs/smartreflex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973bb53f19..ecc59798fd0aa 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -1001,8 +1001,7 @@ static int omap_sr_remove(struct platform_device *pdev)
 
 	if (sr_info->autocomp_active)
 		sr_stop_vddautocomp(sr_info);
-	if (sr_info->dbg_dir)
-		debugfs_remove_recursive(sr_info->dbg_dir);
+	debugfs_remove_recursive(sr_info->dbg_dir);
 
 	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
-- 
2.20.1



