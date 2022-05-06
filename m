Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEA051D1F1
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388394AbiEFHJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 03:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348641AbiEFHJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 03:09:24 -0400
X-Greylist: delayed 180 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 May 2022 00:05:41 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25CD5E179
        for <stable@vger.kernel.org>; Fri,  6 May 2022 00:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1651820550;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=pKK7rcMWY2eaKxbxQ6Qy6GMgfLOY89m3Jsu3lHsEKCE=;
    b=HK5ocmClfyX0JV4C0M9D4V1/05eA+hXW7EfsBN774H/O3Jh7F/ab7J5UUmwAXNal1A
    oOAw6EvO4uYJSEy5wqE2aqqRSc/OK17fNaT+64R67XvIRbqM/JmclOCFM+bRIJO6ZwHQ
    Sqi3p+MAmO0Fs1scBLwa1z2wzU2So1C5S2V7uUMB3h+jw9Wm+h0MZ94mo49RtQ5JdugR
    uMaYkSAU6dzQQ8MgrX9Uh2Awv1mn4by7TJNlgtOX6llfoZDfVNmCWOeokBMFUjNHQjvq
    volXCyZr6YSeduCGb9x5JqgNFwVJGm2t9D+5OhB28/p6D3G8RDTKt8diEcVCKpWCzcrG
    cp+A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9JCKNKiWJaRDy1ex1"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y4672UkZn
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 6 May 2022 09:02:30 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, mkl@pengutronix.de
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH stable] can: isotp: remove re-binding of bound socket
Date:   Fri,  6 May 2022 09:02:11 +0200
Message-Id: <20220506070211.2734-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 72ed3ee9fa0b461ad086403a8b5336154bd82234 ]

As a carry over from the CAN_RAW socket (which allows to change the CAN
interface while mantaining the filter setup) the re-binding of the
CAN_ISOTP socket needs to take care about CAN ID address information and
subscriptions. It turned out that this feature is so limited (e.g. the
sockopts remain fix) that it finally has never been needed/used.

In opposite to the stateless CAN_RAW socket the switching of the CAN ID
subscriptions might additionally lead to an interrupted ongoing PDU
reception. So better remove this unneeded complexity.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220422082337.1676-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index c515bbd46c67..f2f0bc7f0cb4 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1142,24 +1142,25 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (!addr->can_ifindex)
 		return -ENODEV;
 
 	lock_sock(sk);
 
+	if (so->bound) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg = 0;
 
 	/* do not validate rx address for functional addressing */
 	if (do_rx_reg && rx_id == tx_id) {
 		err = -EADDRNOTAVAIL;
 		goto out;
 	}
 
-	if (so->bound && addr->can_ifindex == so->ifindex &&
-	    rx_id == so->rxid && tx_id == so->txid)
-		goto out;
-
 	dev = dev_get_by_index(net, addr->can_ifindex);
 	if (!dev) {
 		err = -ENODEV;
 		goto out;
 	}
@@ -1182,23 +1183,10 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
 				isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
 
-	if (so->bound && do_rx_reg) {
-		/* unregister old filter */
-		if (so->ifindex) {
-			dev = dev_get_by_index(net, so->ifindex);
-			if (dev) {
-				can_rx_unregister(net, dev, so->rxid,
-						  SINGLE_MASK(so->rxid),
-						  isotp_rcv, sk);
-				dev_put(dev);
-			}
-		}
-	}
-
 	/* switch to new settings */
 	so->ifindex = ifindex;
 	so->rxid = rx_id;
 	so->txid = tx_id;
 	so->bound = 1;
-- 
2.30.2

