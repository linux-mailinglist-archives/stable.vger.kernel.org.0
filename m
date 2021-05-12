Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FDF37C3E0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhELPWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233383AbhELPU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E89EB61490;
        Wed, 12 May 2021 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832124;
        bh=w8ThypbtQWX26mEdMFWbwl0qLBFoHfiAFNpcf35XHsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoMUQQ7PNBwUugtc0eJAc44RSnoiAQnXVM+lkSVYNJ+BhYie0RDkPjKD5ltdrXeAx
         LqrFkYl92Ewm1xKARKQkCJ3FKW4YByZkeMMI1hsjHz4seRA4kKJ5fWdDSTz0l+bMva
         kOi/M/1WnRJvnnlm5bWd+8SHnQBYtyUlz2MPaAGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Bauer <mail@david-bauer.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/530] mtd: dont lock when recursively deleting partitions
Date:   Wed, 12 May 2021 16:44:22 +0200
Message-Id: <20210512144824.841955924@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit cb4543054c5c4fd33df960b41d7b483ebca8e786 ]

When recursively deleting partitions, don't acquire the masters
partition lock twice. Otherwise the process ends up in a deadlocked
state.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: David Bauer <mail@david-bauer.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210217195320.893253-1-mail@david-bauer.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index c3575b686f79..95d47422bbf2 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -331,7 +331,7 @@ static int __del_mtd_partitions(struct mtd_info *mtd)
 
 	list_for_each_entry_safe(child, next, &mtd->partitions, part.node) {
 		if (mtd_has_partitions(child))
-			del_mtd_partitions(child);
+			__del_mtd_partitions(child);
 
 		pr_info("Deleting %s MTD partition\n", child->name);
 		ret = del_mtd_device(child);
-- 
2.30.2



