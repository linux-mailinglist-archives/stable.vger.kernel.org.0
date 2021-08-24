Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125953F637F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhHXQ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhHXQ4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40AE361371;
        Tue, 24 Aug 2021 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824170;
        bh=+iohKxA+dJ7wXNrXW47nWHqQy50s8PaxxGNPlFzoeVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkWVCKolVSnL4//OTeqmX7aOJNfyGer8jpoS6FPkb1TyAJUtx6kzRgMKDN9nFxxyJ
         Ey0Fzd3/8VcC4qAfI3XiC8QLKzuj9xsLlxlNMxGBK00MAhnNlHCaPjehQcqbTiQb6o
         +zVxKLH02e9qavPjf/8+34toocaV1cSTFWuVthIll2DtO2x7BhZFsd7h0PhiM04J3f
         K+6KAdj3GZJM+zcRKH6qHNf3kSFsca4kGAk6MtW1owWV7SAHlUNsa/rx2uy3XUO9B3
         GiZNaKGK70M5M+LisMT/yH8NMznd8YaKI6olNlfzMhN6gI3DWjVJMynWQ4RPL95VG/
         DC32MMKdNHpXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Persson <andreasp56@outlook.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.13 001/127] mtd: cfi_cmdset_0002: fix crash when erasing/writing AMD cards
Date:   Tue, 24 Aug 2021 12:54:01 -0400
Message-Id: <20210824165607.709387-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Persson <andreasp56@outlook.com>

commit 2394e628738933aa014093d93093030f6232946d upstream.

Erasing an AMD linear flash card (AM29F016D) crashes after the first
sector has been erased. Likewise, writing to it crashes after two bytes
have been written. The reason is a missing check for a null pointer -
the cmdset_priv field is not set for this type of card.

Fixes: 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
Signed-off-by: Andreas Persson <andreasp56@outlook.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/DB6P189MB05830B3530B8087476C5CFE4C1159@DB6P189MB0583.EURP189.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 3097e93787f7..a761134fd3be 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -119,7 +119,7 @@ static int cfi_use_status_reg(struct cfi_private *cfi)
 	struct cfi_pri_amdstd *extp = cfi->cmdset_priv;
 	u8 poll_mask = CFI_POLL_STATUS_REG | CFI_POLL_DQ;
 
-	return extp->MinorVersion >= '5' &&
+	return extp && extp->MinorVersion >= '5' &&
 		(extp->SoftwareFeatures & poll_mask) == CFI_POLL_STATUS_REG;
 }
 
-- 
2.30.2

