Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174F0411C9D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345547AbhITRL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346900AbhITRJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6588D6187D;
        Mon, 20 Sep 2021 16:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156980;
        bh=Glq6Gzw1sbpK499PuOXT0KvtqLdtmo5/ThyFSrBMhE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qA2PmD65Bd5e6Z08UQYrZr0EU95FpoVmFcse8fsmFQiXqBpvQvFgCkitOKb3emr7B
         gmncgdh0UzK42O3Zv3zUuaLek8uHlHWCfnfsY8dO2eN9ix/ldm72ixwbOgIAZZAbGn
         bXH1DQjuf3y4ppgSEJ0druOq7FQihKPEfMM/Fby0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 143/175] parport: remove non-zero check on count
Date:   Mon, 20 Sep 2021 18:43:12 +0200
Message-Id: <20210920163922.749848261@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



