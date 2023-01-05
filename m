Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BFB65EAE1
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjAEMqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjAEMpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:45:49 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E34E16481;
        Thu,  5 Jan 2023 04:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672922745;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=0zInYWjqbHo9ikTk4/NEVEbTamBBy5b5OlNqAOX7GnE=;
    b=CBRkND0yjSOfi2u4N+e9RmXm8qo5kU7qIuSWeKpMtuSb4OQgMsnQsW6UOWo1ShKcYn
    LO1iemn8LluFYzJLN/tZS041pexy8Hr/wpp+W+SAaobbjHa9urMc3WndilcRsfFyoOJ4
    g/hCwP971RMHVOhjJQITtlJdYqrU5EgOSpgBV9LxZ8L2wg/HmwYgPix6vjHYq5hG+6Pa
    yufr2aP4p+iq9cOBeLfmoNFGGp0ldSIrdFe9P7ECiC2Pc5vl6GjrvF/21g9FWGUxEYVV
    fukbtwlT0r/ICULMORkEtflVc9f5FLmjaY4QnFMBqFosm1TjGrAmi2EenS8NCjfAU97z
    S8mg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJygjsS+Kjg=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id j06241z05Cjj2n4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 5 Jan 2023 13:45:45 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, stable@vger.kernel.org
Subject: [PATCH v3] can: isotp: handle wait_event_interruptible() return values
Date:   Thu,  5 Jan 2023 13:45:35 +0100
Message-Id: <20230105124535.3822-1-socketcan@hartkopp.net>
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

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---

V2: fixed checkpatch warnings m(
V3: added 'Fixes:' tag

 net/can/isotp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 0476a506d4a4..fc81d77724a1 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1150,10 +1150,14 @@ static int isotp_release(struct socket *sock)
 	net = sock_net(sk);
 
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
+	/* force state machines to be idle also when a signal occurred */
+	so->tx.state = ISOTP_IDLE;
+	so->rx.state = ISOTP_IDLE;
+
 	spin_lock(&isotp_notifier_lock);
 	while (isotp_busy_notifier == so) {
 		spin_unlock(&isotp_notifier_lock);
 		schedule_timeout_uninterruptible(1);
 		spin_lock(&isotp_notifier_lock);
-- 
2.30.2

