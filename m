Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E8E396042
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhEaOXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhEaOVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE08061417;
        Mon, 31 May 2021 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468706;
        bh=Y9d8Ty7Lyl4PcVZbnQaNFTDoJew30z4oO0XxsyM7ll8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmNy/aUAInHiQioaBB4rkDGUEhvuS6Yqtqq5v6/E01/upTgckh7wiBlsENaBBCzXh
         3OxpM3k+ZhSxtvNVBIrYSVoVZ4lQECKRkYg8Bv/kg9+NKz6RG4gGG+GLgS3aYuyviN
         TzhGnP0yE11RBI5qK0SPcOfD4z8tL1FQU3JpEr8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/177] Revert "char: hpet: fix a missing check of ioremap"
Date:   Mon, 31 May 2021 15:14:13 +0200
Message-Id: <20210531130651.204694446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



