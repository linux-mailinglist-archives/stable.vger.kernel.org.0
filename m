Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4F76B9485
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjCNMqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjCNMpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:45:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD47A1FC2;
        Tue, 14 Mar 2023 05:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 255B2B81904;
        Tue, 14 Mar 2023 12:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2A7C433D2;
        Tue, 14 Mar 2023 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797842;
        bh=0vGVffKTWvcvF7+SWzA/RlrcWvpEwqtW4CZqnlnVuOo=;
        h=From:To:Cc:Subject:Date:From;
        b=myLqk5UiT3d6FMGFcEXV9ZafSVuVHjiZ5tEUJ49Atk9M5h7C8pNtAYLHAV8Fm8wzx
         TAJJUpgy0jcFY0O9D00Z9+yUxLrdFiE+iQCWPgssEnUt+MhKMLpb/jF67Xm1xEiZ/J
         mDrYB+935WxNnWh5TrKsxeTYHQIFKWjdqJFCns5FpfENarPix1aqpGVTfVR3PAo793
         NdgDnU9XE6IiKEs8bpmnYXAtuSnBw1EypvCUnMKweb4wmC9g1ulFslPz3YoWVokScy
         MWgvfBVLT5a+LtZ1FSfjvRfH6s9nf3RV9+N5hhqTE2FQ4ZN4ANmY37RCiBUP26T0jS
         u3CYuKifVvJbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Schramm <t.schramm@manjaro.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/8] mmc: atmel-mci: fix race between stop command and start of next command
Date:   Tue, 14 Mar 2023 08:43:53 -0400
Message-Id: <20230314124400.471257-1-sashal@kernel.org>
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
index af85b32c6c1c8..c468f9a02ef6b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1818,7 +1818,6 @@ static void atmci_tasklet_func(unsigned long priv)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1851,8 +1850,6 @@ static void atmci_tasklet_func(unsigned long priv)
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

