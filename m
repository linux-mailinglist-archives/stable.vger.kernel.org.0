Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275032D0431
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgLFLns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbgLFLnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:47 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 06/46] net/tls: missing received data after fast remote close
Date:   Sun,  6 Dec 2020 12:17:14 +0100
Message-Id: <20201206111556.757320563@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 20ffc7adf53a5fd3d19751fbff7895bcca66686e ]

In case when tcp socket received FIN after some data and the
parser haven't started before reading data caller will receive
an empty buffer. This behavior differs from plain TCP socket and
leads to special treating in user-space.
The flow that triggers the race is simple. Server sends small
amount of data right after the connection is configured to use TLS
and closes the connection. In this case receiver sees TLS Handshake
data, configures TLS socket right after Change Cipher Spec record.
While the configuration is in process, TCP socket receives small
Application Data record, Encrypted Alert record and FIN packet. So
the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
SK_DONE bit set. The received data is not parsed upon arrival and is
never sent to user-space.

Patch unpauses parser directly if we have unparsed data in tcp
receive queue.

Fixes: fcf4793e278e ("tls: check RCV_SHUTDOWN in tls_wait_data")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Link: https://lore.kernel.org/r/1605801588-12236-1-git-send-email-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1295,6 +1295,12 @@ static struct sk_buff *tls_wait_data(str
 			return NULL;
 		}
 
+		if (!skb_queue_empty(&sk->sk_receive_queue)) {
+			__strp_unpause(&ctx->strp);
+			if (ctx->recv_pkt)
+				return ctx->recv_pkt;
+		}
+
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return NULL;
 


