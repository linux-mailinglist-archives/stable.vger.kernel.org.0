Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098E21FABB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgGNSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730833AbgGNSzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D2222B45;
        Tue, 14 Jul 2020 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752908;
        bh=JWG7+TRaw8KM0rnneWTrc86o5aSOOmpb0FdLuyLoM4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0f7ySXR26Hf+EUCdWC4STrXH4iMkNKqvH4Hi3NIzrJgFNmPQ98OWC2C+Vpsde3Li0
         khdcliMnC9vyH/ReAvPhcxEPpW0xaUUg5nwAmGc0ePSp3KwwWj3pD1A2PkE98+zK7P
         5SCuY4qGLV5Mqm4VnHls0xY6HZuSDxvBQLPvJRSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 046/166] mtd: set master partition panic write flag
Date:   Tue, 14 Jul 2020 20:43:31 +0200
Message-Id: <20200714184118.087679531@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 630e8d5507d9f55dfa98134bfcadefb6cfba4fbb ]

Check and set master panic write flag so that low level drivers
can use it to take required action to ensure oops data gets written
to assigned mtdoops device partition.

Fixes: 9f897bfdd89f ("mtd: Add flag to indicate panic_write")
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200615155134.32007-1-kdasu.kdev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 29d41003d6e0d..f8317ccd8f2a6 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1235,8 +1235,8 @@ int mtd_panic_write(struct mtd_info *mtd, loff_t to, size_t len, size_t *retlen,
 		return -EROFS;
 	if (!len)
 		return 0;
-	if (!mtd->oops_panic_write)
-		mtd->oops_panic_write = true;
+	if (!master->oops_panic_write)
+		master->oops_panic_write = true;
 
 	return master->_panic_write(master, mtd_get_master_ofs(mtd, to), len,
 				    retlen, buf);
-- 
2.25.1



