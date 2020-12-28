Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F36C2E3EB0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390410AbgL1Obn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504107AbgL1ObB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC15420715;
        Mon, 28 Dec 2020 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165821;
        bh=w2MbZqHrbnV1/3vTaIVxhKkrqqnlg4ERx7+X5Is3acI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsvU26eWK13TazqIE2JHkxpH0AWXXJpmyziCwFS3iz4DujYfZduk2IEv7nDxSnLDr
         Lkso3fmwwpiuQvrdKM5KkbiIqe0ENUd8XIYvbfJEz+BlvvIX4CFbhGwihZ7EKesvLp
         FbG+y+Y3cwfmUlk6ERKgrNeWihWyjXIWAQOFxaik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 666/717] mtd: core: Fix refcounting for unpartitioned MTDs
Date:   Mon, 28 Dec 2020 13:51:04 +0100
Message-Id: <20201228125052.887156137@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit 1ca71415f075353974524e96ed175306d8a937a8 upstream.

Apply changes to usecount also to the master partition.
Otherwise we have no refcounting at all if an MTD has no partitions.

Cc: stable@vger.kernel.org
Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201206202220.27290-1-richard@nod.at
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/mtdcore.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -993,6 +993,8 @@ int __get_mtd_device(struct mtd_info *mt
 		}
 	}
 
+	master->usecount++;
+
 	while (mtd->parent) {
 		mtd->usecount++;
 		mtd = mtd->parent;
@@ -1059,6 +1061,8 @@ void __put_mtd_device(struct mtd_info *m
 		mtd = mtd->parent;
 	}
 
+	master->usecount--;
+
 	if (master->_put_device)
 		master->_put_device(master);
 


