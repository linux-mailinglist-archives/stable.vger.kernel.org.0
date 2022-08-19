Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6E659A221
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353029AbiHSQcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353113AbiHSQai (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3991E11CF37;
        Fri, 19 Aug 2022 09:05:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BFBD6181B;
        Fri, 19 Aug 2022 16:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA05C433C1;
        Fri, 19 Aug 2022 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925103;
        bh=/zEdtsTIMZtBod26zAP0r+tf459yO0+VwCRjbNtJLPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sxm9KeVGfLpnX2eSHXVJI+p5077WDDo94MK+XUSRBioyZFpHEJ6mX3Ihtkgnl3NiW
         WYW1bAJaLMwoueNRLXIKC9woYhjQQySEHLfcB/qbbFOAGTHbZgHBRRLf+z/FAWZtoR
         rcpjUi84s3JwIzLfAuiDaWylNeHhj3pogtiyywFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/545] tty: n_gsm: fix packet re-transmission without open control channel
Date:   Fri, 19 Aug 2022 17:42:35 +0200
Message-Id: <20220819153846.638308633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index fe14eed0aa2e..b4cce5cd0e3d 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1388,7 +1388,7 @@ static void gsm_control_retransmit(struct timer_list *t)
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



