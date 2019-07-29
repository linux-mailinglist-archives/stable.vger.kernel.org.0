Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C9479867
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbfG2TjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388966AbfG2TjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:39:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E332054F;
        Mon, 29 Jul 2019 19:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429154;
        bh=91tiYwS4y9/NUYIX4urBs3s97IX04GwoDVbuXLA2XgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ppq0IdsMZnznG1CMkJ3U/gRaq2I3mfPUzFb5LAjoFa27MpQm0CdCcZxaZwebLANJh
         rOh3DkZ5LDzRXy0qaISzqnV/uJduFzF3neR8eMsONIlKrlT9yd2MwBWU2NwgFZ8r29
         HsE9syhHOn5DXq7EKAyvjnLXeVp/uZMnADf5bDGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Muthuswamy <sunilmut@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/113] hvsock: fix epollout hang from race condition
Date:   Mon, 29 Jul 2019 21:21:28 +0200
Message-Id: <20190729190655.965740325@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cb359b60416701c8bed82fec79de25a144beb893 ]

Currently, hvsock can enter into a state where epoll_wait on EPOLLOUT will
not return even when the hvsock socket is writable, under some race
condition. This can happen under the following sequence:
- fd = socket(hvsocket)
- fd_out = dup(fd)
- fd_in = dup(fd)
- start a writer thread that writes data to fd_out with a combination of
  epoll_wait(fd_out, EPOLLOUT) and
- start a reader thread that reads data from fd_in with a combination of
  epoll_wait(fd_in, EPOLLIN)
- On the host, there are two threads that are reading/writing data to the
  hvsocket

stack:
hvs_stream_has_space
hvs_notify_poll_out
vsock_poll
sock_poll
ep_poll

Race condition:
check for epollout from ep_poll():
	assume no writable space in the socket
	hvs_stream_has_space() returns 0
check for epollin from ep_poll():
	assume socket has some free space < HVS_PKT_LEN(HVS_SEND_BUF_SIZE)
	hvs_stream_has_space() will clear the channel pending send size
	host will not notify the guest because the pending send size has
		been cleared and so the hvsocket will never mark the
		socket writable

Now, the EPOLLOUT will never return even if the socket write buffer is
empty.

The fix is to set the pending size to the default size and never change it.
This way the host will always notify the guest whenever the writable space
is bigger than the pending size. The host is already optimized to *only*
notify the guest when the pending size threshold boundary is crossed and
not everytime.

This change also reduces the cpu usage somewhat since hv_stream_has_space()
is in the hotpath of send:
vsock_stream_sendmsg()->hv_stream_has_space()
Earlier hv_stream_has_space was setting/clearing the pending size on every
call.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/hyperv_transport.c | 44 ++++++++------------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index a827547aa102..b131561a9469 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -217,18 +217,6 @@ static void hvs_set_channel_pending_send_size(struct vmbus_channel *chan)
 	set_channel_pending_send_size(chan,
 				      HVS_PKT_LEN(HVS_SEND_BUF_SIZE));
 
-	/* See hvs_stream_has_space(): we must make sure the host has seen
-	 * the new pending send size, before we can re-check the writable
-	 * bytes.
-	 */
-	virt_mb();
-}
-
-static void hvs_clear_channel_pending_send_size(struct vmbus_channel *chan)
-{
-	set_channel_pending_send_size(chan, 0);
-
-	/* Ditto */
 	virt_mb();
 }
 
@@ -298,9 +286,6 @@ static void hvs_channel_cb(void *ctx)
 	if (hvs_channel_readable(chan))
 		sk->sk_data_ready(sk);
 
-	/* See hvs_stream_has_space(): when we reach here, the writable bytes
-	 * may be already less than HVS_PKT_LEN(HVS_SEND_BUF_SIZE).
-	 */
 	if (hv_get_bytes_to_write(&chan->outbound) > 0)
 		sk->sk_write_space(sk);
 }
@@ -328,8 +313,9 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 
 	struct sockaddr_vm addr;
 	struct sock *sk, *new = NULL;
-	struct vsock_sock *vnew;
-	struct hvsock *hvs, *hvs_new;
+	struct vsock_sock *vnew = NULL;
+	struct hvsock *hvs = NULL;
+	struct hvsock *hvs_new = NULL;
 	int ret;
 
 	if_type = &chan->offermsg.offer.if_type;
@@ -388,6 +374,13 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 	set_per_channel_state(chan, conn_from_host ? new : sk);
 	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
 
+	/* Set the pending send size to max packet size to always get
+	 * notifications from the host when there is enough writable space.
+	 * The host is optimized to send notifications only when the pending
+	 * size boundary is crossed, and not always.
+	 */
+	hvs_set_channel_pending_send_size(chan);
+
 	if (conn_from_host) {
 		new->sk_state = TCP_ESTABLISHED;
 		sk->sk_ack_backlog++;
@@ -651,23 +644,8 @@ static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 static s64 hvs_stream_has_space(struct vsock_sock *vsk)
 {
 	struct hvsock *hvs = vsk->trans;
-	struct vmbus_channel *chan = hvs->chan;
-	s64 ret;
-
-	ret = hvs_channel_writable_bytes(chan);
-	if (ret > 0)  {
-		hvs_clear_channel_pending_send_size(chan);
-	} else {
-		/* See hvs_channel_cb() */
-		hvs_set_channel_pending_send_size(chan);
-
-		/* Re-check the writable bytes to avoid race */
-		ret = hvs_channel_writable_bytes(chan);
-		if (ret > 0)
-			hvs_clear_channel_pending_send_size(chan);
-	}
 
-	return ret;
+	return hvs_channel_writable_bytes(hvs->chan);
 }
 
 static u64 hvs_stream_rcvhiwat(struct vsock_sock *vsk)
-- 
2.20.1



