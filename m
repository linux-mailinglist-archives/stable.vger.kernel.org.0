Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F6866CA4
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfGLMV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfGLMV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60163216E3;
        Fri, 12 Jul 2019 12:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934117;
        bh=qp2QdYXM+NBo8M8cyO+n/PU1Mq/At1HHVJtHKxe6KoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSG+UQNjMYArPZ0MD4SFCCdGyJb/w0L1rzQJ/pVXJTD+Z3h4kJbTMdAxFJ6U6//AJ
         3J8KlUAxC/g89bJo6/PJemO/iYdGYDUwJS2V6893OzAfwE04F/DboXy/4iYpL+cDlU
         tkyfSf0nwZaPGFSYPwccgNFdf/okErxXfLeCa0Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/91] mmc: core: complete HS400 before checking status
Date:   Fri, 12 Jul 2019 14:18:48 +0200
Message-Id: <20190712121623.964532029@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b0e370b95a3b231d0fb5d1958cce85ef57196fe6 ]

We don't have a reproducible error case, yet our BSP team suggested that
the mmc_switch_status() command in mmc_select_hs400() should come after
the callback into the driver completing HS400 setup. It makes sense to
me because we want the status of a fully setup HS400, so it will
increase the reliability of the mmc_switch_status() command.

Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Fixes: ba6c7ac3a2f4 ("mmc: core: more fine-grained hooks for HS400 tuning")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/mmc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 55997cf84b39..f1fe446eee66 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1209,13 +1209,13 @@ static int mmc_select_hs400(struct mmc_card *card)
 	mmc_set_timing(host, MMC_TIMING_MMC_HS400);
 	mmc_set_bus_speed(card);
 
+	if (host->ops->hs400_complete)
+		host->ops->hs400_complete(host);
+
 	err = mmc_switch_status(card);
 	if (err)
 		goto out_err;
 
-	if (host->ops->hs400_complete)
-		host->ops->hs400_complete(host);
-
 	return 0;
 
 out_err:
-- 
2.20.1



