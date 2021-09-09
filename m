Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA6405696
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351240AbhIINUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355417AbhIINNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:13:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF66A6108B;
        Thu,  9 Sep 2021 12:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188917;
        bh=Glq6Gzw1sbpK499PuOXT0KvtqLdtmo5/ThyFSrBMhE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/w7DuyvocSjzheHXlpMNljIZL/7syUEXynpbsLv2lb+VpVwF+gmW42ooEryssPBR
         GLVY/N/WRuMNIbp1JSAQsD7+yNaz4azjKt4GEBDTYbsnFYbmjoxskEgrvfhmhizGyS
         yLmk9nf5WoAzsTVP8F/n8SFxdyvhjnGS7+/147DyDU8iKEIyHwWu5mnUs0mRc7tkGu
         5Mjdft/ddhSx4yTlYKv9piQgXKfuCwh8PfSjFIg5ivEVmkKvRCjvgl5Qyn0GEX3bE5
         07A+aTWTtefE+k2H0EJ32B5+xKe/cRMv/+kiEwMIUIHaV9R9ysHC46DmEjo4JPuTnM
         2/pwkkEp9q+kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 33/35] parport: remove non-zero check on count
Date:   Thu,  9 Sep 2021 08:01:14 -0400
Message-Id: <20210909120116.150912-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
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
index 2e21af43d91e..b6d808037045 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -534,7 +534,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
-- 
2.30.2

