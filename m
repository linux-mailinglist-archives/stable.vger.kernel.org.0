Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12643C4F42
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245514AbhGLHXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241262AbhGLHWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BD660FE3;
        Mon, 12 Jul 2021 07:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074383;
        bh=YLpnRZwbYrMs34c6jbdfXkIubDmJKgkXjrhsClIoAN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9Zj03MjT4suWGOoMpgDSxd05gqcUDTLMCREnHBy58dQFjKOFKAgxj5vWZR0xPnq0
         QCeG8UTXz6+0kS+pgbnrbnUmOlWewvfgGClONvhZkE5EMvfev/B/bWeCyG+bE2v+LB
         wtK1LT2ElDPxTqvygKu+6UV1LEFSOnzZFi31p5VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 561/700] mtd: partitions: redboot: seek fis-index-block in the right node
Date:   Mon, 12 Jul 2021 08:10:44 +0200
Message-Id: <20210712061035.893565744@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



