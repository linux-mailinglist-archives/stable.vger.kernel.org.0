Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2263C3C552A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355362AbhGLIJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353051AbhGLIBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D15619B0;
        Mon, 12 Jul 2021 07:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076445;
        bh=YLpnRZwbYrMs34c6jbdfXkIubDmJKgkXjrhsClIoAN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKsJtzVe3WIO2qqFuRMsB3iilZgWsfZdyiUO4WytxTnMStc+TpExJ9BTPuXLiTDFS
         GkYun4VNgP5DG2B43iaNcE4eJpM+165q7XRhYqJ+EOVtdcb0jmV7SpJ0OH62A9R9W7
         WToHL+I3txUVPf7FaZ8ncIGdfmertN/OzsWYg/9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 645/800] mtd: partitions: redboot: seek fis-index-block in the right node
Date:   Mon, 12 Jul 2021 08:11:08 +0200
Message-Id: <20210712061035.690393729@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 237960880960863fb41888763d635b384cffb104 ]

fis-index-block is seeked in the master node and not in the partitions node.
For following binding and current usage, the driver need to check the
partitions subnode.

Fixes: c0e118c8a1a3 ("mtd: partitions: Add OF support to RedBoot partitions")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210520114851.1274609-1-clabbe@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/redboot.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/redboot.c b/drivers/mtd/parsers/redboot.c
index 91146bdc4713..3ccd6363ee8c 100644
--- a/drivers/mtd/parsers/redboot.c
+++ b/drivers/mtd/parsers/redboot.c
@@ -45,6 +45,7 @@ static inline int redboot_checksum(struct fis_image_desc *img)
 static void parse_redboot_of(struct mtd_info *master)
 {
 	struct device_node *np;
+	struct device_node *npart;
 	u32 dirblock;
 	int ret;
 
@@ -52,7 +53,11 @@ static void parse_redboot_of(struct mtd_info *master)
 	if (!np)
 		return;
 
-	ret = of_property_read_u32(np, "fis-index-block", &dirblock);
+	npart = of_get_child_by_name(np, "partitions");
+	if (!npart)
+		return;
+
+	ret = of_property_read_u32(npart, "fis-index-block", &dirblock);
 	if (ret)
 		return;
 
-- 
2.30.2



