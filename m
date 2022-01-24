Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3A49919E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353925AbiAXUMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:12:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51928 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379110AbiAXUKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:10:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BFE5B810AF;
        Mon, 24 Jan 2022 20:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB54C340E7;
        Mon, 24 Jan 2022 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055018;
        bh=es4VFNe9AaDnfs8Ou0sM7tYhD3qSg6+pBgcbz0bHUXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWALHyhkTjzYTWU4FbN29+KWeTdnzi6SljH2uVLcD3o6ICdyiWkuy61QZ5zDgEEr7
         tY/B9G+84GSi0+bVgH+dmiC2K3R6qCkU1MxrDlGlirprTmbQcLSmouVFW7VQQRsvgA
         Okno4AGbzzQCY/FukNjnTiznH4j8klZeZ7zp8JZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andreas Oetken <andreas.oetken@siemens-energy.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 015/846] mtd: Fixed breaking list in __mtd_del_partition.
Date:   Mon, 24 Jan 2022 19:32:12 +0100
Message-Id: <20220124184101.439970355@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Oetken <ennoerlangen@gmail.com>

commit 2966daf7d253d9904b337b040dd7a43472858b8a upstream.

Not the child partition should be removed from the partition list
but the partition itself. Otherwise the partition list gets broken
and any subsequent remove operations leads to a kernel panic.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211102172604.2921065-1-andreas.oetken@siemens-energy.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -312,7 +312,7 @@ static int __mtd_del_partition(struct mt
 	if (err)
 		return err;
 
-	list_del(&child->part.node);
+	list_del(&mtd->part.node);
 	free_partition(mtd);
 
 	return 0;


