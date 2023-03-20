Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB0B6C17A6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjCTPQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjCTPPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:15:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF9E4697
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE692614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F015CC433EF;
        Mon, 20 Mar 2023 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325039;
        bh=itsdBSsZuZQchIHMp91AhtheSQCQbjR2HIoL5bDPqO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIPEVDI0SuSy7x9/C6RK+wFjRDEd5Cxc/byQ+XPbpPKkltjLEoULk8d5yE7x89Cae
         FbEXvefAHkUwwCLeQCSlHrdqiFZPvDk9sxBafh0bGBsg+KrmPuxbls9/+7DzW5Fu1H
         j0pAkHiZqo7N9qDT2ZXohk2xptrgyreipnsRooog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tobias Schramm <t.schramm@manjaro.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/115] mmc: atmel-mci: fix race between stop command and start of next command
Date:   Mon, 20 Mar 2023 15:54:35 +0100
Message-Id: <20230320145452.062353883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6f971a3e7e494..493ed8c824195 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1818,7 +1818,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1851,8 +1850,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
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



