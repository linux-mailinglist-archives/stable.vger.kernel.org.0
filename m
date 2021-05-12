Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D89137C7F2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhELQD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232351AbhELP5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6144961C41;
        Wed, 12 May 2021 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833495;
        bh=6hNkKI2pvt0uak00GyXphpKBhmOwCq3Ef2687Ixh6ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqEqIH9kApfFgtp6LoOBXAsXrTGcx25oBEft1Qe9wmgzlqiUYh7yUSq81Glu8XdWP
         R7epx7tp+WGhw+S86sIWffzOHKcyPA7vx/RPgbh+/x2F5zRh4C8RPtJ/YJ25LxHxWf
         GWgtaP0D1fAk2Z45/QatLupvu5P6HiP3jsl95UG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 171/601] mtd: maps: fix error return code of physmap_flash_remove()
Date:   Wed, 12 May 2021 16:44:08 +0200
Message-Id: <20210512144833.473310387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 620b90d30c08684dc6ebee07c72755d997f9d1f6 ]

When platform_get_drvdata() returns NULL to info, no error return code
of physmap_flash_remove() is assigned.
To fix this bug, err is assigned with -EINVAL in this case

Fixes: 73566edf9b91 ("[MTD] Convert physmap to platform driver")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210308034446.3052-1-baijiaju1990@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/physmap-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/physmap-core.c b/drivers/mtd/maps/physmap-core.c
index 001ed5deb622..4f63b8430c71 100644
--- a/drivers/mtd/maps/physmap-core.c
+++ b/drivers/mtd/maps/physmap-core.c
@@ -69,8 +69,10 @@ static int physmap_flash_remove(struct platform_device *dev)
 	int i, err = 0;
 
 	info = platform_get_drvdata(dev);
-	if (!info)
+	if (!info) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	if (info->cmtd) {
 		err = mtd_device_unregister(info->cmtd);
-- 
2.30.2



