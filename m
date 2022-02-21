Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574114BE355
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345113AbiBUIwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:52:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345117AbiBUIv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:51:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B474027D;
        Mon, 21 Feb 2022 00:51:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BAF7B80EAB;
        Mon, 21 Feb 2022 08:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A858DC340E9;
        Mon, 21 Feb 2022 08:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433491;
        bh=O+sY+LfRJbQKaEA7wqHvgzawuelz+mmhjbQAWSz1BlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4oBg0yM38dt4lbyAsWNp6WxvuDyUjSAwP5kT74aNW+7ueRsh0J4AyTsdDNZFsV4c
         nyXVppXQnBVSI9jTfCAOUZtAkuAy5FgjOmulcGDGIAxo8ipfwAUQlY5bF8CAtTCY70
         mpUIv00/Il7x1ZVQTmFnpfPhyY2r/CrpdDmLj0UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 18/33] vsock: remove vsock from connected table when connect is interrupted by a signal
Date:   Mon, 21 Feb 2022 09:49:11 +0100
Message-Id: <20220221084909.365239841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
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
@@ -1220,6 +1220,7 @@ static int vsock_stream_connect(struct s
 			sk->sk_state = SS_UNCONNECTED;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
+			vsock_remove_connected(vsk);
 			goto out_wait;
 		} else if (timeout == 0) {
 			err = -ETIMEDOUT;


