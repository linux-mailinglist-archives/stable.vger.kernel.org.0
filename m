Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451426B94D8
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjCNMtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbjCNMso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:48:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608FAA42C2;
        Tue, 14 Mar 2023 05:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F0B1B818F3;
        Tue, 14 Mar 2023 12:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D917C4339C;
        Tue, 14 Mar 2023 12:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797866;
        bh=rbXSAK+88t/rL+IzRSDszfV7F6QhwewLoU1P/X/l4ho=;
        h=From:To:Cc:Subject:Date:From;
        b=XDbUxSmE46noyBlOLRVj9m6edd4aSYD0EMzZRYzyuXrHPqKBQ39zCmQGVVGZZYbi7
         kiotsxM0nBMlUk6Z+PuSzrHAJP9ISqPILp5fjRJQ5v7o7nPh0+2eR9y3URhaF1mhsM
         gKXBe2HVqSFemsyfuX1fBLR90nBLNX81fAo0CLlQDfZbetDCBVK9HaNEmM6sHoKFZW
         xnmwm1C/hVccpk3lqrp3D0PXKzywb65vJnApKof2QSHqlkfuQw85ttMv6O1jKFJZmc
         qnkpfv1oy0wg4v1xI7zi7MYZPGpJXFjtiQCP4zkH52XkIjW3p6ccLHER9iatzaLbve
         m4EsGMTvy7i/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Schramm <t.schramm@manjaro.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 1/7] mmc: atmel-mci: fix race between stop command and start of next command
Date:   Tue, 14 Mar 2023 08:44:18 -0400
Message-Id: <20230314124424.471460-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Schramm <t.schramm@manjaro.org>

[ Upstream commit eca5bd666b0aa7dc0bca63292e4778968241134e ]

This commit fixes a race between completion of stop command and start of a
new command.
Previously the command ready interrupt was enabled before stop command
was written to the command register. This caused the command ready
interrupt to fire immediately since the CMDRDY flag is asserted constantly
while there is no command in progress.
Consequently the command state machine will immediately advance to the
next state when the tasklet function is executed again, no matter
actual completion state of the stop command.
Thus a new command can then be dispatched immediately, interrupting and
corrupting the stop command on the CMD line.
Fix that by dropping the command ready interrupt enable before calling
atmci_send_stop_cmd. atmci_send_stop_cmd does already enable the
command ready interrupt, no further writes to ATMCI_IER are necessary.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20221230194315.809903-2-t.schramm@manjaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/atmel-mci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index d40bab3d9f4af..fb435a8d37213 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1857,7 +1857,6 @@ static void atmci_tasklet_func(unsigned long priv)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1890,8 +1889,6 @@ static void atmci_tasklet_func(unsigned long priv)
 				 * command to send.
 				 */
 				if (host->mrq->stop) {
-					atmci_writel(host, ATMCI_IER,
-					             ATMCI_CMDRDY);
 					atmci_send_stop_cmd(host, data);
 					state = STATE_SENDING_STOP;
 				} else {
-- 
2.39.2

