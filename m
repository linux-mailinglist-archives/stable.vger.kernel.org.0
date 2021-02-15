Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6545F31BD3D
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhBOPmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhBOPiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F21A464EF8;
        Mon, 15 Feb 2021 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403273;
        bh=8yzTv+kmNL+oFvIi5QPN6VNeXCm398HTDlgtF/bf5rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPF3qkRAwM4nMFGVKQDaxdKOl4dWgUD0JioyLZ2duafepwQLy3emQ8PdLWxKR3goi
         z6AQCCKQyJW00oApnOm9LDZDDeVympqCpqMQLI8BGiw+npgp+G5Y+/d3P6NlWrl3KM
         nq9RfLj8DwUNNB52OTxE5NIETi+Dje2zOIgSZ8MY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Slusarek <nslusarek@gmx.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 094/104] net/vmw_vsock: fix NULL pointer dereference
Date:   Mon, 15 Feb 2021 16:27:47 +0100
Message-Id: <20210215152722.496048614@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

commit 5d1cbcc990f18edaddddef26677073c4e6fad7b7 upstream.

In vsock_stream_connect(), a thread will enter schedule_timeout().
While being scheduled out, another thread can enter vsock_stream_connect()
as well and set vsk->transport to NULL. In case a signal was sent, the
first thread can leave schedule_timeout() and vsock_transport_cancel_pkt()
will be called right after. Inside vsock_transport_cancel_pkt(), a null
dereference will happen on transport->cancel_pkt.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/trinity-c2d6cede-bfb1-44e2-85af-1fbc7f541715-1612535117028@3c-app-gmx-bap12
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1216,7 +1216,7 @@ static int vsock_transport_cancel_pkt(st
 {
 	const struct vsock_transport *transport = vsk->transport;
 
-	if (!transport->cancel_pkt)
+	if (!transport || !transport->cancel_pkt)
 		return -EOPNOTSUPP;
 
 	return transport->cancel_pkt(vsk);


