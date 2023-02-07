Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB5768D837
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjBGNHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbjBGNHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F103B0E4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE4F613DC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3434C433D2;
        Tue,  7 Feb 2023 13:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775140;
        bh=xTgWYW4047ZdZNMuBPKL5pL3N9LIJxIDOgYlbf98YXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDvd00oolXv4htM3HYQZE4PDsBPpsZva8StEMDhlS/a0jwj9Xvo9XG3/1QAkt6oyu
         53HJmjQe/yjbES/lYPC6VOpN4WdeNJeoIsCK5T0Uq7Qsf6Jug9s5341vcejyYBYyrj
         YYuSteZXAowrldjhUzQRnoWhxmTNquou0XKP55Iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 121/208] can: isotp: handle wait_event_interruptible() return values
Date:   Tue,  7 Feb 2023 13:56:15 +0100
Message-Id: <20230207125639.889060164@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 823b2e42720f96f277940c37ea438b7c5ead51a4 upstream.

When wait_event_interruptible() has been interrupted by a signal the
tx.state value might not be ISOTP_IDLE. Force the state machines
into idle state to inhibit the timer handlers to continue working.

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx processing")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230112192347.1944-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1152,6 +1152,10 @@ static int isotp_release(struct socket *
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
+	/* force state machines to be idle also when a signal occurred */
+	so->tx.state = ISOTP_IDLE;
+	so->rx.state = ISOTP_IDLE;
+
 	spin_lock(&isotp_notifier_lock);
 	while (isotp_busy_notifier == so) {
 		spin_unlock(&isotp_notifier_lock);


