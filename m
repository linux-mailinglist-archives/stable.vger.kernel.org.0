Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522AE38EAF5
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhEXO7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233257AbhEXO46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F1006144C;
        Mon, 24 May 2021 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867756;
        bh=Y9d8Ty7Lyl4PcVZbnQaNFTDoJew30z4oO0XxsyM7ll8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAqno1irqINvy47yKIxq3rFIIkJ8vLWX9y2VxzK/DC38NdA4fg+4gaU/3s1mmvZNT
         WxI2swH0liWvDLBoRFCZNWj3yXGQezzJPpKGOpqTPGxTqt3nI5JXSxSVnFOzidSIny
         q/mbJ40PqrQiKXgCqfqQ32ZPgUud/tTKwNTBCyJevMY17rj74bttMzqd5WjLbtqJBM
         R97Hpcn+rQHaqx8BO7jHVMG6RistAp2XHL5bKczinTggaCi28un6SZERupqUtvVOWE
         1X1RdooRODXIgSZxGrNtrJM9pSTdQfeCsu4v6WQCosnaehxHqye1Grh1NUtUrn5BY9
         yzHiYlx5EL3Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 11/52] Revert "char: hpet: fix a missing check of ioremap"
Date:   Mon, 24 May 2021 10:48:21 -0400
Message-Id: <20210524144903.2498518-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 566f53238da74801b48e985788e5f7c9159e5940 ]

This reverts commit 13bd14a41ce3105d5b1f3cd8b4d1e249d17b6d9b.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

While this is technically correct, it is only fixing ONE of these errors
in this function, so the patch is not fully correct.  I'll leave this
revert and provide a fix for this later that resolves this same
"problem" everywhere in this function.

Cc: Kangjie Lu <kjlu@umn.edu>
Link: https://lore.kernel.org/r/20210503115736.2104747-29-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hpet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index f69609b47fef..3e31740444f1 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -969,8 +969,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 	if (ACPI_SUCCESS(status)) {
 		hdp->hd_phys_address = addr.address.minimum;
 		hdp->hd_address = ioremap(addr.address.minimum, addr.address.address_length);
-		if (!hdp->hd_address)
-			return AE_ERROR;
 
 		if (hpet_is_known(hdp)) {
 			iounmap(hdp->hd_address);
-- 
2.30.2

