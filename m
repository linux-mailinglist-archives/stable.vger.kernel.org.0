Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67953635835
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbiKWJux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiKWJuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90765EA
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17D9561B75
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B03BC433C1;
        Wed, 23 Nov 2022 09:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196853;
        bh=aP7aSIxkv2UW3X52PHr26yg33DA7BJkUejYm3Wd3hVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYnR1Rw72ZkTwOmOQAhp6ZTFwE1irg4ulkXEvumVI6Lw//ZLl58vN4yU+iHphlTta
         KRHZc8R3+3/M39hYsH5WBpOFaDcnwNbLO2yfmqxCnTp+JdkNpezRFe4OCJ0oaLaowL
         RK9I1hTPTvpNHhBlimKdCR126Lqli14CkKhUlrgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 101/314] tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send
Date:   Wed, 23 Nov 2022 09:49:06 +0100
Message-Id: <20221123084630.070182052@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 7b7dfe4833c70a11cdfa51b38705103bd31eddaa ]

The function gsm_dlci_t1() is a timer handler that runs in an
atomic context, but it calls "kzalloc(..., GFP_KERNEL)" that
may sleep. As a result, the sleep-in-atomic-context bug will
happen. The process is shown below:

gsm_dlci_t1()
 gsm_dlci_open()
  gsm_modem_update()
   gsm_modem_upd_via_msc()
    gsm_control_send()
     kzalloc(sizeof(.., GFP_KERNEL) //may sleep

This patch changes the gfp_t parameter of kzalloc() from GFP_KERNEL to
GFP_ATOMIC in order to mitigate the bug.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20221002040709.27849-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 01c112e2e214..2a0de70e0be4 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1670,7 +1670,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 		unsigned int command, u8 *data, int clen)
 {
 	struct gsm_control *ctrl = kzalloc(sizeof(struct gsm_control),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 	unsigned long flags;
 	if (ctrl == NULL)
 		return NULL;
-- 
2.35.1



