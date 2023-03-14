Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B67E6B9441
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjCNMn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjCNMnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:43:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5389B12588;
        Tue, 14 Mar 2023 05:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E17B8B818F3;
        Tue, 14 Mar 2023 12:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5653C433D2;
        Tue, 14 Mar 2023 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797788;
        bh=fXGFdJhYV+PXpv7qzl8L1ATb9+K9VRxi83TYZva0h7c=;
        h=From:To:Cc:Subject:Date:From;
        b=kW3HzLszBC1Llr2lRFnSvggQ0sKgxxzi2e4IPbInMYwlXEd++Sp7yCQzbtVS6npln
         c8u1v/1WXqFfuPL+ejws8HMVSggtDBGGZbck9Z43JUd2RfL9ovHr2XYc0h7rXFoPi3
         OtVbWLjiwSh8a2zMxJIEwXfO6E4soeVjLuMc3lswdOlwTXzZ/CvsQ0SdOpDeNfnQN3
         jh+9o7M5g3Q0dfuoBIGOOn6AtcbHFfrasRJQMe9zvtrVYGWhMIuqqvDuXCAEafhVSW
         ULRIkuH0Zj32pc4MGQNAyEKv8J/BQbSAqNgpN28OEqcndJd4+wU7rdoI0vbFaBEHZS
         Ht2YhWP3sLflA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Schramm <t.schramm@manjaro.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 01/13] mmc: atmel-mci: fix race between stop command and start of next command
Date:   Tue, 14 Mar 2023 08:42:53 -0400
Message-Id: <20230314124305.470657-1-sashal@kernel.org>
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
index bb9bbf1c927b6..dd18440a90c58 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1817,7 +1817,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1850,8 +1849,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
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

