Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB554BE256
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347833AbiBUJNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:13:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348523AbiBUJLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:11:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E39325C44;
        Mon, 21 Feb 2022 01:03:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2706124A;
        Mon, 21 Feb 2022 09:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B79C36AE7;
        Mon, 21 Feb 2022 09:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434214;
        bh=YiAl3IpWCjUJZCbwRpNn3idPI2eM5VTqyqRt9vcIH/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9zH5rHo9NzlMD/CJdClbJrlIqPGsjzQH1jEWhNFWPdgy2vBbFHm9+tVUzXaue/uz
         nVjhHKqFFBLf3Pf5QoZbexMiugEpoF+F81FjzrYYmH8hiNHbvziHLhUPLz02NqYX4t
         t5DSJ0U6fHqH0ju/qSeysVm9OIIAqEtTAk/l9e3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 050/121] vsock: remove vsock from connected table when connect is interrupted by a signal
Date:   Mon, 21 Feb 2022 09:49:02 +0100
Message-Id: <20220221084922.900698834@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Seth Forshee <sforshee@digitalocean.com>

commit b9208492fcaecff8f43915529ae34b3bcb03877c upstream.

vsock_connect() expects that the socket could already be in the
TCP_ESTABLISHED state when the connecting task wakes up with a signal
pending. If this happens the socket will be in the connected table, and
it is not removed when the socket state is reset. In this situation it's
common for the process to retry connect(), and if the connection is
successful the socket will be added to the connected table a second
time, corrupting the list.

Prevent this by calling vsock_remove_connected() if a signal is received
while waiting for a connection. This is harmless if the socket is not in
the connected table, and if it is in the table then removing it will
prevent list corruption from a double add.

Note for backporting: this patch requires d5afa82c977e ("vsock: correct
removal of socket from the list"), which is in all current stable trees
except 4.9.y.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20220217141312.2297547-1-sforshee@digitalocean.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1357,6 +1357,7 @@ static int vsock_stream_connect(struct s
 			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
+			vsock_remove_connected(vsk);
 			goto out_wait;
 		} else if (timeout == 0) {
 			err = -ETIMEDOUT;


