Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA602061CC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392631AbgFWUur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391751AbgFWUsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:48:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A928521548;
        Tue, 23 Jun 2020 20:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945316;
        bh=2nQ0gIecz0QqDByb09pooe3RpZuahbE6hxH7vRUPpSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgB4TzYD8W7hd3LhZzVwqqgbNSZ2Fp6jI7PcmuWVTHKdvR/clvGcLHpUX7xnTm4Av
         +KYJX+lLZxxUntMmHIytXKBz1t7EVHDSFnWpeKB3D6Cgy/CpsoArpKXo8iZMWAsuxO
         bJpfXUK2R8qA9EJD6J0UkfNtVW4AtRPngg5/OVIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/136] mtd: rawnand: orion: Fix the probe error path
Date:   Tue, 23 Jun 2020 21:59:39 +0200
Message-Id: <20200623195309.935969176@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit be238fbf78e4c7c586dac235ab967d3e565a4d1a ]

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-34-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/orion_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 2f21c678d6efd..df07f9b4cf03a 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -186,7 +186,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	mtd->name = "orion_nand";
 	ret = mtd_device_register(mtd, board->parts, board->nr_parts);
 	if (ret) {
-		nand_release(nc);
+		nand_cleanup(nc);
 		goto no_dev;
 	}
 
-- 
2.25.1



