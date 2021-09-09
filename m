Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EB1405741
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357723AbhIINdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356263AbhIIM7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A0263273;
        Thu,  9 Sep 2021 11:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188733;
        bh=QRAfYCMlD1tydVAsQqC38dv/IQY/ZID3c6hiYrYC74A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJYgfyBpQwlQw6RXcSJD9YVqdh6QFHPVIvjtFzEa+vqtbf3xYbL/O7I1KLh2n+/vu
         GqNHGBjiu/C2Oyo/4jJfwnDM+KPHy8LXbM1CQVCFvBelmPr/7XE5TRFlbYmLbnina7
         ZwHQWa37zfEOa9pbrH/3giyEsBjkNGdObLKpwyO03R9mj1JvfKUS/8uBkGedAhRmUf
         YPktyLDFxNDpSCElO93gs1NberZOkhhEfTJ2fi1IEVIoC3X9WFcuO3ofopeRVGUYv4
         qE7lMusJMZqKbp06CRIVahME2RabQmMB0uC1rg1bVAY4GdccfP/lAn2HY5xraAgsir
         jFsxnI0+ubNyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 70/74] parport: remove non-zero check on count
Date:   Thu,  9 Sep 2021 07:57:22 -0400
Message-Id: <20210909115726.149004-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 5d41dda6da4e..75daa16f38b7 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -535,7 +535,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
-- 
2.30.2

