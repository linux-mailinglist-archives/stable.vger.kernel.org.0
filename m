Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D616059A061
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351787AbiHSQPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351711AbiHSQOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:14:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7EF140A1;
        Fri, 19 Aug 2022 08:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48060B82816;
        Fri, 19 Aug 2022 15:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE44C433D7;
        Fri, 19 Aug 2022 15:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924672;
        bh=7TerLh21QbI4xEHS6vRstbPd1xTOV8W+7vDm0LspVbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzJ7SfLby5UcX9g6F4AHEpKF6zUSpvr7vRM7CjczS72DQ45VwMjqSkmbW5F6fbzti
         pHU5Xk83KMc+jko0n7VT8YkjMZ58lsLI932d+Etx7L6Ep/WH6s886HWV3KAnIjbzYd
         mtfkl3YgtbQ2VrbmX3HgouRs+zBn9bjaYt+sW67Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/545] can: pch_can: pch_can_error(): initialize errc before using it
Date:   Fri, 19 Aug 2022 17:40:14 +0200
Message-Id: <20220819153840.278836924@linuxfoundation.org>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 9950f11211331180269867aef848c7cf56861742 ]

After commit 3a5c7e4611dd, the variable errc is accessed before being
initialized, c.f. below W=2 warning:

| In function 'pch_can_error',
|     inlined from 'pch_can_poll' at drivers/net/can/pch_can.c:739:4:
| drivers/net/can/pch_can.c:501:29: warning: 'errc' may be used uninitialized [-Wmaybe-uninitialized]
|   501 |                 cf->data[6] = errc & PCH_TEC;
|       |                             ^
| drivers/net/can/pch_can.c: In function 'pch_can_poll':
| drivers/net/can/pch_can.c:484:13: note: 'errc' was declared here
|   484 |         u32 errc, lec;
|       |             ^~~~

Moving errc initialization up solves this issue.

Fixes: 3a5c7e4611dd ("can: pch_can: do not report txerr and rxerr during bus-off")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/all/20220721160032.9348-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/pch_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 1adfcc0b9424..1272ec793a8d 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -489,6 +489,7 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 	if (!skb)
 		return;
 
+	errc = ioread32(&priv->regs->errc);
 	if (status & PCH_BUS_OFF) {
 		pch_can_set_tx_all(priv, 0);
 		pch_can_set_rx_all(priv, 0);
@@ -501,7 +502,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		cf->data[7] = (errc & PCH_REC) >> 8;
 	}
 
-	errc = ioread32(&priv->regs->errc);
 	/* Warning interrupt. */
 	if (status & PCH_EWARN) {
 		state = CAN_STATE_ERROR_WARNING;
-- 
2.35.1



