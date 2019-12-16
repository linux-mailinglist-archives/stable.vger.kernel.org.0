Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55EC121949
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfLPRyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfLPRyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:54:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 007B820733;
        Mon, 16 Dec 2019 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518864;
        bh=SzvkVd+9LFIcwniH3yoE89IT43LDqnNp0UY/1zTYNSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPeofrAAoNJ/d/IbWe8qOMaADNX9cqo7LBswQ6Ck8T/Fl0Yi0ynlqeXx8Ebd+oyA3
         woJU3t6hMi0ST/7jQDTyhXVnc5fXtO3Eu46SelUu8+L7j8cj4iDpgTIRzVcMCXihmn
         PfEfbFRVUT7Eqp2H2/4JLbZNS43kXclI+PhNikpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/267] mtd: fix mtd_oobavail() incoherent returned value
Date:   Mon, 16 Dec 2019 18:47:03 +0100
Message-Id: <20191216174902.035495399@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index 6cd0f6b7658b3..aadc2ee050f16 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -401,7 +401,7 @@ static inline struct device_node *mtd_get_of_node(struct mtd_info *mtd)
 	return dev_of_node(&mtd->dev);
 }
 
-static inline int mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
+static inline u32 mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
 {
 	return ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail : mtd->oobsize;
 }
-- 
2.20.1



