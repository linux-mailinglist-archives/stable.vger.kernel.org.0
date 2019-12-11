Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5817811B4DE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732615AbfLKPWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730932AbfLKPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDCA32073D;
        Wed, 11 Dec 2019 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077758;
        bh=6WqnEtZcpwKMN0AGFQmDNkvleWZEMRKj16Ms18ORuJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUPB/BFmaj87I02qMYj8qb4d/1ysIcAJgFmQb0QjI+WHDVd6ncsBNfIQs4h+NtCt4
         GUu9x7azBlDgD7/7zPmwCiLBRr4bkLL4JGqq/T8IjItQDUdhpDGqP5I4CvZQhMrGub
         +ILG41JVBjIwn34/xIOIliPFZEIOvh6idTvFGg+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/243] mtd: fix mtd_oobavail() incoherent returned value
Date:   Wed, 11 Dec 2019 16:05:22 +0100
Message-Id: <20191211150349.965520027@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 4348433d8c0234f44adb6e12112e69343f50f0c5 ]

mtd_oobavail() returns either mtd->oovabail or mtd->oobsize. Both
values are unsigned 32-bit entities, so there is no reason to pretend
returning a signed one.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/mtd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index cd0be91bdefa5..035d641e8847c 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -386,7 +386,7 @@ static inline struct device_node *mtd_get_of_node(struct mtd_info *mtd)
 	return dev_of_node(&mtd->dev);
 }
 
-static inline int mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
+static inline u32 mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
 {
 	return ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail : mtd->oobsize;
 }
-- 
2.20.1



