Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4834838EA42
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhEXOxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233352AbhEXOvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C374613D0;
        Mon, 24 May 2021 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867681;
        bh=BW5P4etMGsgT4xI1Vez4UnzEYGNudEKWJr9HEmsIOaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lo69tPC8nzRkqekujRXWan8+Xi9q1bRp8Qf2l/QuSRGqYfzMdQCOmLXmYehISIkpC
         fTwjuFfZLKOLyWLV7EbmM4QyE9cme2bRp37Eor0LgoXrup7vFeAjeqXJAphp7kB5ys
         htBhmwNFvfKjJCxY+D38Dpc45unc8m6fpVDRpg/Yl/ORgoksSVt3y23ys/JlEqKfjF
         ZzVkuSyFgD++AD2s/WS/IUij2g7exH+eP9TH+ivnO85ofoxBtdYBahkmjz/OgEeTg3
         TUwF2EFXXoQjYe4McNwpqTsbv/RePDZbiDNG1xB55yAnCPjK7tNpo14mBEkaxHreGD
         B38NDPFhDFrSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 14/62] Revert "char: hpet: fix a missing check of ioremap"
Date:   Mon, 24 May 2021 10:46:55 -0400
Message-Id: <20210524144744.2497894-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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
index ed3b7dab678d..6f13def6c172 100644
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

