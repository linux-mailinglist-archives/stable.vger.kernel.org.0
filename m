Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF6A328846
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbhCARiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237800AbhCAR3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:29:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D24E65093;
        Mon,  1 Mar 2021 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617536;
        bh=GowxoeeIByD1M0xcJ5/1xiC31yHkKPzkZjCUnkCyJps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZIycyi2R6hOMVWBmDSy0zUuWinb5r7R+W+JOuEdHIBNk1/65Bp87/jml4bAo9Czl
         Co9c9lBCUUgMjNJLwIkY8xarkXOJjRoOSnr4A/rpaUb5x152VoIAtqEKIbgsdcF3Rf
         ytNUECRd6mcGX/WYS1JqOA9Q7Da0Gm1BQIhQ4nMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/340] mtd: parsers: afs: Fix freeing the part name memory in failure
Date:   Mon,  1 Mar 2021 17:10:53 +0100
Message-Id: <20210301161053.699206422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 7b844cf445f0a7daa68be0ce71eb2c88d68b0c5d ]

In the case of failure while parsing the partitions, the iterator should
be pre decremented by one before starting to free the memory allocated
by kstrdup(). Because in the failure case, kstrdup() will not succeed
and thus no memory will be allocated for the current iteration.

Fixes: 1fca1f6abb38 ("mtd: afs: simplify partition parsing")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210104041137.113075-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/afs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/parsers/afs.c b/drivers/mtd/parsers/afs.c
index 752b6cf005f71..8fd61767af831 100644
--- a/drivers/mtd/parsers/afs.c
+++ b/drivers/mtd/parsers/afs.c
@@ -370,10 +370,8 @@ static int parse_afs_partitions(struct mtd_info *mtd,
 	return i;
 
 out_free_parts:
-	while (i >= 0) {
+	while (--i >= 0)
 		kfree(parts[i].name);
-		i--;
-	}
 	kfree(parts);
 	*pparts = NULL;
 	return ret;
-- 
2.27.0



