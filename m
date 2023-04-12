Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32B16DEFA1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjDLIwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbjDLIwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CECF9EDA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53F5B6318F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663E1C433D2;
        Wed, 12 Apr 2023 08:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289480;
        bh=7l8j5l9+jCXzV48ULYZ2+Bq5LpYx6qWNsjvGr8p90Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2pN4c2R8l2o9pgrtq2P0VXRozkdmEcgULU70g0rI+z2Z2WsCzTd4ah83pJ1bxJwR
         VvdgdKmUgK/qiTDxQHbPEMkLvbSrSFDkGkNGLfuVD8l4Sz958f72Qer1NBODVUZ6IW
         L8FcLlJaIWg4PSWiSvhjQb6Vrl2nyJdvIJIq09kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.2 115/173] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos
Date:   Wed, 12 Apr 2023 10:34:01 +0200
Message-Id: <20230412082842.738453552@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0145462fc802cd447ef5d029758043c7f15b4b1e upstream.

isotp.c was still using sock_recv_timestamp() which does not provide
control messages to detect dropped PDUs in the receive path.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230330170248.62342-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1125,7 +1125,7 @@ static int isotp_recvmsg(struct socket *
 	if (ret < 0)
 		goto out_err;
 
-	sock_recv_timestamp(msg, sk, skb);
+	sock_recv_cmsgs(msg, sk, skb);
 
 	if (msg->msg_name) {
 		__sockaddr_check_size(ISOTP_MIN_NAMELEN);


