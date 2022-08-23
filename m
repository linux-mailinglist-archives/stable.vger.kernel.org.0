Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0559DE01
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244253AbiHWLdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357778AbiHWLb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:31:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9524C6B41;
        Tue, 23 Aug 2022 02:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBF5AB81C63;
        Tue, 23 Aug 2022 09:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5428FC433C1;
        Tue, 23 Aug 2022 09:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246761;
        bh=vXDcH9p22lzctV7voDCYx49/6X0hsDZl1XdNwJZkaPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQXckeF1HGYN6navbil9CjaQHE9V2ZKDUyKtTQvM0a6ctuMj6M5SVzY/xHcOhXYJl
         CY0NPsMVnrR/tOOHkT2ZbUPUDOrz7FvJAmY37O4YJU5QofB30mzmg2dbCFv01UctCy
         slDhYcewuVjHypJuQU29IGywHQ1KvWvvxAK3kD44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/389] tty: n_gsm: fix packet re-transmission without open control channel
Date:   Tue, 23 Aug 2022 10:24:50 +0200
Message-Id: <20220823080124.462442388@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 4fae831b3a71fc5a44cc5c7d0b8c1267ee7659f5 ]

In the current implementation control packets are re-transmitted even if
the control channel closed down during T2. This is wrong.
Check whether the control channel is open before re-transmitting any
packets. Note that control channel open/close is handled by T1 and not T2
and remains unaffected by this.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-7-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index cab30df61196..893d6f502c2e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1382,7 +1382,7 @@ static void gsm_control_retransmit(struct timer_list *t)
 	spin_lock_irqsave(&gsm->control_lock, flags);
 	ctrl = gsm->pending_cmd;
 	if (ctrl) {
-		if (gsm->cretries == 0) {
+		if (gsm->cretries == 0 || !gsm->dlci[0] || gsm->dlci[0]->dead) {
 			gsm->pending_cmd = NULL;
 			ctrl->error = -ETIMEDOUT;
 			ctrl->done = 1;
-- 
2.35.1



