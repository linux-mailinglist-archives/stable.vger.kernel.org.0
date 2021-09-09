Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF7D404DD8
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbhIIMHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244632AbhIIMBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A0F61528;
        Thu,  9 Sep 2021 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187983;
        bh=6GYGAVk2gYlgVH3/XQYaDlJTce6H+5zqR3EON9Hy2B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijGKmNYBY9gnayFJn8FaqtdS/EaX6BLk+gvvgfMeK6jx+9StTbEfrVtH1xjATg0/y
         UZCYmhLOkCNFNDPSBSjlSCDb/geVXY92DUMxa+SoIlnY7ZGWG29uiCd0tHPjqft+mc
         byVsCTuGg4PWR5duIqKQJ8NAFGO6g2D8uB4VMh2PUQTW2vOsiFMUnvvFtO4BYIjKTl
         LSuQiErKflRrNggd0P5YUS41Y3gWPsD6AbwPgUQv2QjHze4GusKRBYPhkC6QvIAdFt
         S53VztFSORmEaj6M7qVEFmFRZSmeUWId8vHhSpkC9EDakkGnzv5JbNe/fL8BrV6g0C
         ACM+oeqeQ21GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 244/252] parport: remove non-zero check on count
Date:   Thu,  9 Sep 2021 07:40:58 -0400
Message-Id: <20210909114106.141462-244-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0be883a0d795d9146f5325de582584147dd0dcdc ]

The check for count appears to be incorrect since a non-zero count
check occurs a couple of statements earlier. Currently the check is
always false and the dev->port->irq != PARPORT_IRQ_NONE part of the
check is never tested and the if statement is dead-code. Fix this
by removing the check on count.

Note that this code is pre-git history, so I can't find a sha for
it.

Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Logically dead code")
Link: https://lore.kernel.org/r/20210730100710.27405-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/ieee1284_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/ieee1284_ops.c b/drivers/parport/ieee1284_ops.c
index 2c11bd3fe1fd..17061f1df0f4 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -518,7 +518,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
-- 
2.30.2

