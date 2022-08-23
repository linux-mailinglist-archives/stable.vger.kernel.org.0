Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9013B59D886
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240901AbiHWJ53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243431AbiHWJwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:52:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCACF9E108;
        Tue, 23 Aug 2022 01:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2FAC7CE1B51;
        Tue, 23 Aug 2022 08:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47555C433C1;
        Tue, 23 Aug 2022 08:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244347;
        bh=0knbD/ImRv9PdrlmhmwIx+OgZjRdA+sNf0/I295lEzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOBW/kErdfoQGS9ZVZe79gQ6SxL6Az9dAVEb4pGVdCh8UBWhniE0RiqowtGA3LK14
         wGaM2EObjdsC8ekUM9/jORo57BqxhlTd95mIOWlNbi+4MXc3ZoBJINYi1dlsVqi2r0
         +bfZM0xilTcUwQCTlGkNjJnGVJooI0YecCgcsFHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/229] tty: n_gsm: fix packet re-transmission without open control channel
Date:   Tue, 23 Aug 2022 10:24:44 +0200
Message-Id: <20220823080058.112909767@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index a838ec4f2715..62af08e5caa5 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1394,7 +1394,7 @@ static void gsm_control_retransmit(unsigned long data)
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



