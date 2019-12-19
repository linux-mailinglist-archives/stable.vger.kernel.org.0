Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711D5126CD2
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfLSTGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbfLSSob (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4174F24679;
        Thu, 19 Dec 2019 18:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781070;
        bh=1MPMx1l2YY6G49X7p5LPea+7hTic56kzUOXi0+eR7lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9PJ19ZD1cKrgPnIi3j6Swym6smRDGk/snD3mOthVy9DL/abq5ICOfw0fMhcZ6NaQ
         hivmTJjEYgkpcW9WIaxBNwMLT41+CdxZaWrFTtge0FknR3KU9Su8XGvdlTjOQvvLZy
         VDheeLatzw1IrUijKNeAHXJi0uykUvbNSKLRcnb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@gmx.us>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/199] mlx4: Use snprintf instead of complicated strcpy
Date:   Thu, 19 Dec 2019 19:32:31 +0100
Message-Id: <20191219183218.814817462@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index 69fb5ba94d0f2..19caacd26f61a 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -352,16 +352,12 @@ err:
 
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



