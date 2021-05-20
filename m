Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFD38A6AE
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbhETK3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235911AbhETK1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD2A061482;
        Thu, 20 May 2021 09:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504244;
        bh=0rLUmTGbGwzYfbMsvhdrmBckQ13VB8dZ5stH21Xc+Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sytsyv5DQmwqR+5Sl+jqhptkfJSULk03jgTAf7vB6JhBsQW99QVb8MUTgzohNGsK1
         V/iTue33vNUZ0pennK+RIEyTo3VZLJJDEaqlSMRc5reC6apn1eYd9IYOBbaxosxovk
         0cy0K3A5Hn7jm2LbT67W68bdEAXn+NSrpcewJfxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 157/323] mtd: require write permissions for locking and badblock ioctls
Date:   Thu, 20 May 2021 11:20:49 +0200
Message-Id: <20210520092125.482101642@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 1e97743fd180981bef5f01402342bb54bf1c6366 ]

MEMLOCK, MEMUNLOCK and OTPLOCK modify protection bits. Thus require
write permission. Depending on the hardware MEMLOCK might even be
write-once, e.g. for SPI-NOR flashes with their WP# tied to GND. OTPLOCK
is always write-once.

MEMSETBADBLOCK modifies the bad block table.

Fixes: f7e6b19bc764 ("mtd: properly check all write ioctls for permissions")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210303155735.25887-1-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdchar.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 18dd333f2d40..0a109277b174 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -689,16 +689,12 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
 	case MEMGETINFO:
 	case MEMREADOOB:
 	case MEMREADOOB64:
-	case MEMLOCK:
-	case MEMUNLOCK:
 	case MEMISLOCKED:
 	case MEMGETOOBSEL:
 	case MEMGETBADBLOCK:
-	case MEMSETBADBLOCK:
 	case OTPSELECT:
 	case OTPGETREGIONCOUNT:
 	case OTPGETREGIONINFO:
-	case OTPLOCK:
 	case ECCGETLAYOUT:
 	case ECCGETSTATS:
 	case MTDFILEMODE:
@@ -709,9 +705,13 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
 	/* "dangerous" commands */
 	case MEMERASE:
 	case MEMERASE64:
+	case MEMLOCK:
+	case MEMUNLOCK:
+	case MEMSETBADBLOCK:
 	case MEMWRITEOOB:
 	case MEMWRITEOOB64:
 	case MEMWRITE:
+	case OTPLOCK:
 		if (!(file->f_mode & FMODE_WRITE))
 			return -EPERM;
 		break;
-- 
2.30.2



