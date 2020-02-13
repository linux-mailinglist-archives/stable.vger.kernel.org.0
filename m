Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8682A15C420
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387653AbgBMP1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387646AbgBMP1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:02 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA56B218AC;
        Thu, 13 Feb 2020 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607622;
        bh=nqcGG/WO56Zu/rq/TnBzMmGzqpJVN3K4l3o8HdgZ3FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IALo4glvjFJgozMVvJz/R3rFl3rtQQ6D7FdxNBlvueB+ACHZtpzyn0KgVtbxRJ5p3
         PZhxXBMb5IfKjYf6Q8Bk4YY10f6o6qID5Js7H0BuZOfkeeVb0dZKOqODWTTnehiSwN
         FwKQ+jifZyvBG19xVbMO3SxNZ7SKJp0KM8UCira4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/96] hv_sock: Remove the accept port restriction
Date:   Thu, 13 Feb 2020 07:20:09 -0800
Message-Id: <20200213151839.736570375@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>

[ Upstream commit c742c59e1fbd022b64d91aa9a0092b3a699d653c ]

Currently, hv_sock restricts the port the guest socket can accept
connections on. hv_sock divides the socket port namespace into two parts
for server side (listening socket), 0-0x7FFFFFFF & 0x80000000-0xFFFFFFFF
(there are no restrictions on client port namespace). The first part
(0-0x7FFFFFFF) is reserved for sockets where connections can be accepted.
The second part (0x80000000-0xFFFFFFFF) is reserved for allocating ports
for the peer (host) socket, once a connection is accepted.
This reservation of the port namespace is specific to hv_sock and not
known by the generic vsock library (ex: af_vsock). This is problematic
because auto-binds/ephemeral ports are handled by the generic vsock
library and it has no knowledge of this port reservation and could
allocate a port that is not compatible with hv_sock (and legitimately so).
The issue hasn't surfaced so far because the auto-bind code of vsock
(__vsock_bind_stream) prior to the change 'VSOCK: bind to random port for
VMADDR_PORT_ANY' would start walking up from LAST_RESERVED_PORT (1023) and
start assigning ports. That will take a large number of iterations to hit
0x7FFFFFFF. But, after the above change to randomize port selection, the
issue has started coming up more frequently.
There has really been no good reason to have this port reservation logic
in hv_sock from the get go. Reserving a local port for peer ports is not
how things are handled generally. Peer ports should reflect the peer port.
This fixes the issue by lifting the port reservation, and also returns the
right peer port. Since the code converts the GUID to the peer port (by
using the first 4 bytes), there is a possibility of conflicts, but that
seems like a reasonable risk to take, given this is limited to vsock and
that only applies to all local sockets.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/hyperv_transport.c | 68 +++++---------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index c443db7af8d4a..463cefc1e5ae2 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -136,28 +136,15 @@ struct hvsock {
  ****************************************************************************
  * The only valid Service GUIDs, from the perspectives of both the host and *
  * Linux VM, that can be connected by the other end, must conform to this   *
- * format: <port>-facb-11e6-bd58-64006a7986d3, and the "port" must be in    *
- * this range [0, 0x7FFFFFFF].                                              *
+ * format: <port>-facb-11e6-bd58-64006a7986d3.                              *
  ****************************************************************************
  *
  * When we write apps on the host to connect(), the GUID ServiceID is used.
  * When we write apps in Linux VM to connect(), we only need to specify the
  * port and the driver will form the GUID and use that to request the host.
  *
- * From the perspective of Linux VM:
- * 1. the local ephemeral port (i.e. the local auto-bound port when we call
- * connect() without explicit bind()) is generated by __vsock_bind_stream(),
- * and the range is [1024, 0xFFFFFFFF).
- * 2. the remote ephemeral port (i.e. the auto-generated remote port for
- * a connect request initiated by the host's connect()) is generated by
- * hvs_remote_addr_init() and the range is [0x80000000, 0xFFFFFFFF).
  */
 
-#define MAX_LISTEN_PORT			((u32)0x7FFFFFFF)
-#define MAX_VM_LISTEN_PORT		MAX_LISTEN_PORT
-#define MAX_HOST_LISTEN_PORT		MAX_LISTEN_PORT
-#define MIN_HOST_EPHEMERAL_PORT		(MAX_HOST_LISTEN_PORT + 1)
-
 /* 00000000-facb-11e6-bd58-64006a7986d3 */
 static const guid_t srv_id_template =
 	GUID_INIT(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
@@ -180,33 +167,6 @@ static void hvs_addr_init(struct sockaddr_vm *addr, const guid_t *svr_id)
 	vsock_addr_init(addr, VMADDR_CID_ANY, port);
 }
 
-static void hvs_remote_addr_init(struct sockaddr_vm *remote,
-				 struct sockaddr_vm *local)
-{
-	static u32 host_ephemeral_port = MIN_HOST_EPHEMERAL_PORT;
-	struct sock *sk;
-
-	vsock_addr_init(remote, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-
-	while (1) {
-		/* Wrap around ? */
-		if (host_ephemeral_port < MIN_HOST_EPHEMERAL_PORT ||
-		    host_ephemeral_port == VMADDR_PORT_ANY)
-			host_ephemeral_port = MIN_HOST_EPHEMERAL_PORT;
-
-		remote->svm_port = host_ephemeral_port++;
-
-		sk = vsock_find_connected_socket(remote, local);
-		if (!sk) {
-			/* Found an available ephemeral port */
-			return;
-		}
-
-		/* Release refcnt got in vsock_find_connected_socket */
-		sock_put(sk);
-	}
-}
-
 static void hvs_set_channel_pending_send_size(struct vmbus_channel *chan)
 {
 	set_channel_pending_send_size(chan,
@@ -336,12 +296,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 	if_type = &chan->offermsg.offer.if_type;
 	if_instance = &chan->offermsg.offer.if_instance;
 	conn_from_host = chan->offermsg.offer.u.pipe.user_def[0];
-
-	/* The host or the VM should only listen on a port in
-	 * [0, MAX_LISTEN_PORT]
-	 */
-	if (!is_valid_srv_id(if_type) ||
-	    get_port_by_srv_id(if_type) > MAX_LISTEN_PORT)
+	if (!is_valid_srv_id(if_type))
 		return;
 
 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
@@ -365,6 +320,13 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 
 		new->sk_state = TCP_SYN_SENT;
 		vnew = vsock_sk(new);
+
+		hvs_addr_init(&vnew->local_addr, if_type);
+
+		/* Remote peer is always the host */
+		vsock_addr_init(&vnew->remote_addr,
+				VMADDR_CID_HOST, VMADDR_PORT_ANY);
+		vnew->remote_addr.svm_port = get_port_by_srv_id(if_instance);
 		hvs_new = vnew->trans;
 		hvs_new->chan = chan;
 	} else {
@@ -429,8 +391,6 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		sk->sk_ack_backlog++;
 
 		hvs_addr_init(&vnew->local_addr, if_type);
-		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
-
 		hvs_new->vm_srv_id = *if_type;
 		hvs_new->host_srv_id = *if_instance;
 
@@ -753,16 +713,6 @@ static bool hvs_stream_is_active(struct vsock_sock *vsk)
 
 static bool hvs_stream_allow(u32 cid, u32 port)
 {
-	/* The host's port range [MIN_HOST_EPHEMERAL_PORT, 0xFFFFFFFF) is
-	 * reserved as ephemeral ports, which are used as the host's ports
-	 * when the host initiates connections.
-	 *
-	 * Perform this check in the guest so an immediate error is produced
-	 * instead of a timeout.
-	 */
-	if (port > MAX_HOST_LISTEN_PORT)
-		return false;
-
 	if (cid == VMADDR_CID_HOST)
 		return true;
 
-- 
2.20.1



