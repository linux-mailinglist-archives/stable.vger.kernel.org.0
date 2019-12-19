Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F987126CCA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfLSSoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728937AbfLSSoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D749B24679;
        Thu, 19 Dec 2019 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781041;
        bh=y+nQxC6lag84zSjjpeCKCucJBQKq2nK/mD3DhW0tzUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dp4GshD2/Nhrl96CbVifs2gG/FakKdukLyULg1Z5O9xtrSZRR6khZWeJAhSuYETgc
         bES6dIhzfn82YHssvsKczc27aBRZry/MkaaA6NGtnyO7otlok/VPmZmpu4WJGKUC2a
         6xvPXgGiV2DE1Vwh7LOtVxKoZvg19agoZE8W949c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 058/199] mtd: fix mtd_oobavail() incoherent returned value
Date:   Thu, 19 Dec 2019 19:32:20 +0100
Message-Id: <20191219183218.172518536@linuxfoundation.org>
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
index 13f8052b9ff92..13ddba5e531d3 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -392,7 +392,7 @@ static inline struct device_node *mtd_get_of_node(struct mtd_info *mtd)
 	return mtd->dev.of_node;
 }
 
-static inline int mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
+static inline u32 mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
 {
 	return ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail : mtd->oobsize;
 }
-- 
2.20.1



