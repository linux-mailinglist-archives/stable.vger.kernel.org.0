Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB2C59D570
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbiHWIc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbiHWIb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:31:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ECE66A44;
        Tue, 23 Aug 2022 01:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12427B81C4A;
        Tue, 23 Aug 2022 08:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59313C433D7;
        Tue, 23 Aug 2022 08:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242511;
        bh=cxO9xjSZDQUeRiS2q8YwS5yaRpm8BDG2uREKH4M2LC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOl5aDxmKnhfEgx+g6BftKBNGjq1I0dv15XdmpRTqKGtmFC3ggoJ8MKScZ+gcCGYT
         KEKRD5UhD19Nkt2XIxNwEA8DI+EDPNq7FpYLxLfawweZms7AGDLN6Mbwkfzo+I01nv
         E0kiKPgqsqjCfOnOW/qPWLyscGbmPdr2Lo7cq0U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 126/365] vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()
Date:   Tue, 23 Aug 2022 10:00:27 +0200
Message-Id: <20220823080123.460404019@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Peilin Ye <peilin.ye@bytedance.com>

commit a3e7b29e30854ed67be0d17687e744ad0c769c4b upstream.

Imagine two non-blocking vsock_connect() requests on the same socket.
The first request schedules @connect_work, and after it times out,
vsock_connect_timeout() sets *sock* state back to TCP_CLOSE, but keeps
*socket* state as SS_CONNECTING.

Later, the second request returns -EALREADY, meaning the socket "already
has a pending connection in progress", even though the first request has
already timed out.

As suggested by Stefano, fix it by setting *socket* state back to
SS_UNCONNECTED, so that the second request will return -ETIMEDOUT.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1286,6 +1286,7 @@ static void vsock_connect_timeout(struct
 	if (sk->sk_state == TCP_SYN_SENT &&
 	    (sk->sk_shutdown != SHUTDOWN_MASK)) {
 		sk->sk_state = TCP_CLOSE;
+		sk->sk_socket->state = SS_UNCONNECTED;
 		sk->sk_err = ETIMEDOUT;
 		sk_error_report(sk);
 		vsock_transport_cancel_pkt(vsk);


