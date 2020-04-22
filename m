Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E11B3CAF
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgDVKHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgDVKHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:07:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C4A2076C;
        Wed, 22 Apr 2020 10:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550067;
        bh=lXo/mUOLvXgMdxR13M1GMOY84RU5XYqhgyq8Pb0pkEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJfTwhfkwDGK5P2nTbqLWx3nsRkBVs2HyGNhUWVkfAWBdb+rms0+dUsdjG99VT0Yr
         LIUnVpR31w47V5sLhK3N6HHv7Fi1K4pFMICSBFdwL1p6rHBbMikr2/6QKujbScRT3k
         9xitAmB+/bPLeQ8CHqVyDjdlOsxRhHKLGPqGWFps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.9 121/125] mtd: lpddr: Fix a double free in probe()
Date:   Wed, 22 Apr 2020 11:57:18 +0200
Message-Id: <20200422095052.022334749@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4da0ea71ea934af18db4c63396ba2af1a679ef02 upstream.

This function is only called from lpddr_probe().  We free "lpddr" both
here and in the caller, so it's a double free.  The best place to free
"lpddr" is in lpddr_probe() so let's delete this one.

Fixes: 8dc004395d5e ("[MTD] LPDDR qinfo probing.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200228092554.o57igp3nqhyvf66t@kili.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/lpddr/lpddr_cmds.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -81,7 +81,6 @@ struct mtd_info *lpddr_cmdset(struct map
 	shared = kmalloc(sizeof(struct flchip_shared) * lpddr->numchips,
 						GFP_KERNEL);
 	if (!shared) {
-		kfree(lpddr);
 		kfree(mtd);
 		return NULL;
 	}


