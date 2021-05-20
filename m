Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56AD38A946
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhETLAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhETK6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF44C6191D;
        Thu, 20 May 2021 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504941;
        bh=Bd7ya/Acu3UmQZhaki/yGBV6VqDbjpKrpEA+fXt7tFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0FOxTIzz3Y11e2tbuZis1U48FFRsvAc69gkTi79eXSx41m9tPfKlLsG/meyGioqm
         GUWaqhB53CTi/C21hSPbzrCQ/Z8JOsfxJEkN0qoUdnH+HsJEjPVQB4JYxE1RybP3KO
         gHzG9niKUj9S9z/j/BPB1BYF25gBLIy7IwQV3XZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 107/240] mtd: require write permissions for locking and badblock ioctls
Date:   Thu, 20 May 2021 11:21:39 +0200
Message-Id: <20210520092112.271357965@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 331183548bc5..b43b8edc18ec 100644
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



