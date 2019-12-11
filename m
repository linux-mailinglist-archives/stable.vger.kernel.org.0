Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD0A11B471
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbfLKP0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733057AbfLKPZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44AC2222C4;
        Wed, 11 Dec 2019 15:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077957;
        bh=aWlTSsAz5pIPz3sdH4Px6OlGakCFM7rgFREkQ+ye7i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSwqYL7deNA2iRv4nBPjSdFZJuuIykoiPWGL2IIE5gszYRg06OLml8MBhQi5AiXuH
         DdNcpSSlTtGr3bIMgqCCYGQEjEdUxmLkzW6vY583s6GoJZJ+Tc14lSooR/9a3UN0NJ
         Ha525ULlt7uU6mOJ8oToAMEBhUjGJc8z8d9e8bjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@gmx.us>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/243] mlx4: Use snprintf instead of complicated strcpy
Date:   Wed, 11 Dec 2019 16:05:50 +0100
Message-Id: <20191211150351.864220155@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@gmx.us>

[ Upstream commit 0fbc9b8b4ea3f688a5da141a64f97aa33ad02ae9 ]

This fixes a compilation warning in sysfs.c

drivers/infiniband/hw/mlx4/sysfs.c:360:2: warning: 'strncpy' output may be
truncated copying 8 bytes from a string of length 31
[-Wstringop-truncation]

By eliminating the temporary stack buffer.

Signed-off-by: Qian Cai <cai@gmx.us>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/sysfs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index e219093d27645..d2da28d613f2c 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -353,16 +353,12 @@ err:
 
 static void get_name(struct mlx4_ib_dev *dev, char *name, int i, int max)
 {
-	char base_name[9];
-
-	/* pci_name format is: bus:dev:func -> xxxx:yy:zz.n */
-	strlcpy(name, pci_name(dev->dev->persist->pdev), max);
-	strncpy(base_name, name, 8); /*till xxxx:yy:*/
-	base_name[8] = '\0';
-	/* with no ARI only 3 last bits are used so when the fn is higher than 8
+	/* pci_name format is: bus:dev:func -> xxxx:yy:zz.n
+	 * with no ARI only 3 last bits are used so when the fn is higher than 8
 	 * need to add it to the dev num, so count in the last number will be
 	 * modulo 8 */
-	sprintf(name, "%s%.2d.%d", base_name, (i/8), (i%8));
+	snprintf(name, max, "%.8s%.2d.%d", pci_name(dev->dev->persist->pdev),
+		 i / 8, i % 8);
 }
 
 struct mlx4_port {
-- 
2.20.1



