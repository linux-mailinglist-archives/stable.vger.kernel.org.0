Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8249499501
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392036AbiAXUuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389564AbiAXUmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF66AC049646;
        Mon, 24 Jan 2022 11:52:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8839EB81142;
        Mon, 24 Jan 2022 19:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9937BC340E7;
        Mon, 24 Jan 2022 19:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053945;
        bh=bRrlijC1F6GBDT2Rk+XS0Jz07Rmt6OW88U30+cWYSz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNI6UYPQVKErXjOgJeMVanzoqel651bkT/6IxabeZKOhCCVzZyGrVlQNZXiPsszh2
         PfZAoVH1FYQF+84+dJCU2iPr+pRBcbiDFReiSsdwoa5BUnJe4CvD1hzZdqCYkc+bRp
         tpLrbqRyLsQl0Wa+jFXTdw8JOtdwHf4gjo0pmF2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Fabio Estevam <festevam@denx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/563] regmap: Call regmap_debugfs_exit() prior to _init()
Date:   Mon, 24 Jan 2022 19:39:54 +0100
Message-Id: <20220124184032.369790263@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 530792efa6cb86f5612ff093333fec735793b582 ]

Since commit cffa4b2122f5 ("regmap: debugfs: Fix a memory leak when
calling regmap_attach_dev"), the following debugfs error is seen
on i.MX boards:

debugfs: Directory 'dummy-iomuxc-gpr@20e0000' with parent 'regmap' already present!

In the attempt to fix the memory leak, the above commit added a NULL check
for map->debugfs_name. For the first debufs entry, map->debugfs_name is NULL
and then the new name is allocated via kasprintf().

For the second debugfs entry, map->debugfs_name() is no longer NULL, so
it will keep using the old entry name and the duplicate name error is seen.

Quoting Mark Brown:

"That means that if the device gets freed we'll end up with the old debugfs
file hanging around pointing at nothing.
...
To be more explicit this means we need a call to regmap_debugfs_exit()
which will clean up all the existing debugfs stuff before we loose
references to it."

Call regmap_debugfs_exit() prior to regmap_debugfs_init() to fix
the problem.

Tested on i.MX6Q and i.MX6SX boards.

Fixes: cffa4b2122f5 ("regmap: debugfs: Fix a memory leak when calling regmap_attach_dev")
Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Link: https://lore.kernel.org/r/20220107163307.335404-1-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 456a1787e18d0..55a30afc14a00 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -620,6 +620,7 @@ int regmap_attach_dev(struct device *dev, struct regmap *map,
 	if (ret)
 		return ret;
 
+	regmap_debugfs_exit(map);
 	regmap_debugfs_init(map);
 
 	/* Add a devres resource for dev_get_regmap() */
-- 
2.34.1



