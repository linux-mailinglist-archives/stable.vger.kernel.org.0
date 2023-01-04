Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA765DA05
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbjADQjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjADQjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:39:23 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95F1C12B;
        Wed,  4 Jan 2023 08:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672850360;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=JA2Boit5hyhfpofRWHW5LAiC5RIJQLwxKJ4yn4Zs8lA=;
    b=kmE068kd3DsO19+9rW3d8Spsxuh1XCVCHwqELE2MfOe74JIpIQYvvduR9SX5VMiDil
    aRFk9oRhskomFXc3OdoQ97PoPRuLIUO50c2DG+KjrsJRQ4kVBQ05raeT5Js4EnfR/6Lj
    h5xa9A8g7f5YHKvq44EFx3i5UMUUlnTVd3tfl0ZBV1pWl63TBy1MgP0DRMjPcV6UxTHD
    iBemc8QeaU1Y4y6YFxz0cFb0V3+/+oXCmfykSItKTRemERjclm5osNBqPGCV+BMzkw09
    IPV1s4QUkqYREleEOo3cPM0dXookChN0zjwJkdxlyeBZqcZwwLAt6V1Os5mRizkDRstH
    SzXA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJygjsS+Kjg=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id j06241z04GdK10c
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 4 Jan 2023 17:39:20 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, stable@vger.kernel.org
Subject: [PATCH] can: isotp: handle wait_event_interruptible() return values
Date:   Wed,  4 Jan 2023 17:39:09 +0100
Message-Id: <20230104163909.33556-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When wait_event_interruptible() has been interrupted by a signal the
tx.state value might not be ISOTP_IDLE. Force the state machines
into idle state to inhibit the timer handlers to continue working.

Cc: stable@vger.kernel.org # >= v5.15
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 0476a506d4a4..d3b39a5b7e74 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1150,10 +1150,13 @@ static int isotp_release(struct socket *sock)
 	net = sock_net(sk);
 
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
+	/* force state machines to be idle also when a signal occured */
+	so->tx.state = so->rx.state = ISOTP_IDLE;
+
 	spin_lock(&isotp_notifier_lock);
 	while (isotp_busy_notifier == so) {
 		spin_unlock(&isotp_notifier_lock);
 		schedule_timeout_uninterruptible(1);
 		spin_lock(&isotp_notifier_lock);
-- 
2.30.2

