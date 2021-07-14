Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58B63C8D2C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhGNTnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235954AbhGNTnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8A2A613D1;
        Wed, 14 Jul 2021 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291621;
        bh=jWSKzkJ1vsphKuArPC7UbEpDSmeIB1msXfkM5MF16iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKU4DkbhrBJ2I7myv25ZDqHSMmmDR6ZO7sw/fbJNJq5kKOeO0DOx4OUTV3dN4AmGl
         tEC9kzFKhe5BAbdLAdQ4C89+F3Y6t45TpMgxqFus6BGLpA8KRZdEOd6Haxk/NwXHj8
         r2h2OMez9DDkd/NZpL1H5HebeJRE7TVzC8s2nmzlmqppo+5wPkY0SMsolcDj0f1kC/
         JUDP6+29PuQKfc4jRSB1Zn50eWPniRSSswGEOhr6kSZPjxGbwp1ZP1RXClTp1Vh9HZ
         GajBnCqode4oBaj1JdiaHIBW+VPU9yXiYdhxGSu9tzEwjAscs8Y6nNIO7mcuDW3pS9
         88yhzkEEQbwTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 098/108] scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
Date:   Wed, 14 Jul 2021 15:37:50 -0400
Message-Id: <20210714193800.52097-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 332a9dd1d86f1e7203fc7f0fd7e82f0b304200fe ]

The shifting of the u8 integer returned fom ahc_inb(ahc, port+3) by 24 bits
to the left will be promoted to a 32 bit signed int and then sign-extended
to a u64. In the event that the top bit of the u8 is set then all then all
the upper 32 bits of the u64 end up as also being set because of the
sign-extension. Fix this by casting the u8 values to a u64 before the 24
bit left shift.

[ This dates back to 2002, I found the offending commit from the git
history git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git,
commit f58eb66c0b0a ("Update aic7xxx driver to 6.2.10...") ]

Link: https://lore.kernel.org/r/20210621151727.20667-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Addresses-Coverity: ("Unintended sign extension")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 4b04ab8908f8..a396f048a031 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -493,7 +493,7 @@ ahc_inq(struct ahc_softc *ahc, u_int port)
 	return ((ahc_inb(ahc, port))
 	      | (ahc_inb(ahc, port+1) << 8)
 	      | (ahc_inb(ahc, port+2) << 16)
-	      | (ahc_inb(ahc, port+3) << 24)
+	      | (((uint64_t)ahc_inb(ahc, port+3)) << 24)
 	      | (((uint64_t)ahc_inb(ahc, port+4)) << 32)
 	      | (((uint64_t)ahc_inb(ahc, port+5)) << 40)
 	      | (((uint64_t)ahc_inb(ahc, port+6)) << 48)
-- 
2.30.2

