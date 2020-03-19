Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F6518B6D0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgCSNWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbgCSNWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DF0208D6;
        Thu, 19 Mar 2020 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624137;
        bh=CqsKLrQra6cLEAHnT8a8YJqR3AY12jRQOjMQLpab51o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HggvGo8N8YbXcHLEanbrSQEoP0etIxdldyLDWCcbZ8xfVdoPLjco3X6m4f3yeCMvb
         r0qLtEbp2h7G6fur5Y78hv1WDQjhW5Tkni1FsjHO2Dxd8fjG3fplBA7THIa8IfAB3F
         41h3wz+CGhxVMo3lK540w4kQLPIGdZhtzwf5ll/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/60] mmc: core: Default to generic_cmd6_time as timeout in __mmc_switch()
Date:   Thu, 19 Mar 2020 14:03:42 +0100
Message-Id: <20200319123920.563972990@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 533a6cfe08f96a7b5c65e06d20916d552c11b256 ]

All callers of __mmc_switch() should now be specifying a valid timeout for
the CMD6 command. However, just to be sure, let's print a warning and
default to use the generic_cmd6_time in case the provided timeout_ms
argument is zero.

In this context, let's also simplify some of the corresponding code and
clarify some related comments.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-4-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/mmc_ops.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 09113b9ad6790..cfb2ce979baf1 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -458,10 +458,6 @@ static int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 	bool expired = false;
 	bool busy = false;
 
-	/* We have an unspecified cmd timeout, use the fallback value. */
-	if (!timeout_ms)
-		timeout_ms = MMC_OPS_TIMEOUT_MS;
-
 	/*
 	 * In cases when not allowed to poll by using CMD13 or because we aren't
 	 * capable of polling by using ->card_busy(), then rely on waiting the
@@ -534,14 +530,19 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 
 	mmc_retune_hold(host);
 
+	if (!timeout_ms) {
+		pr_warn("%s: unspecified timeout for CMD6 - use generic\n",
+			mmc_hostname(host));
+		timeout_ms = card->ext_csd.generic_cmd6_time;
+	}
+
 	/*
-	 * If the cmd timeout and the max_busy_timeout of the host are both
-	 * specified, let's validate them. A failure means we need to prevent
-	 * the host from doing hw busy detection, which is done by converting
-	 * to a R1 response instead of a R1B.
+	 * If the max_busy_timeout of the host is specified, make sure it's
+	 * enough to fit the used timeout_ms. In case it's not, let's instruct
+	 * the host to avoid HW busy detection, by converting to a R1 response
+	 * instead of a R1B.
 	 */
-	if (timeout_ms && host->max_busy_timeout &&
-		(timeout_ms > host->max_busy_timeout))
+	if (host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
 	cmd.opcode = MMC_SWITCH;
@@ -552,10 +553,6 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	cmd.flags = MMC_CMD_AC;
 	if (use_r1b_resp) {
 		cmd.flags |= MMC_RSP_SPI_R1B | MMC_RSP_R1B;
-		/*
-		 * A busy_timeout of zero means the host can decide to use
-		 * whatever value it finds suitable.
-		 */
 		cmd.busy_timeout = timeout_ms;
 	} else {
 		cmd.flags |= MMC_RSP_SPI_R1 | MMC_RSP_R1;
-- 
2.20.1



