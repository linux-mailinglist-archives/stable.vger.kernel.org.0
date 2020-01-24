Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9336B147713
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 04:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgAXDIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 22:08:23 -0500
Received: from mail-eopbgr760134.outbound.protection.outlook.com ([40.107.76.134]:18274
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730192AbgAXDIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 22:08:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6QOheHMarfHh2dINk02O+XxKNaY40Dd8ae4xEPCTWj8riHKNKjTPMPGi8vAoKvUqBeEN6Q3/eIZA2uyyTbJtfuEU1FjHvYO9j/V26cx5GzyZTdo4vI6vRXlyn7iIASOqPtugBUKU9RmAlHtAp9wo4ecx7ZP5YyvaRBkVhsIYzbU5nB6eDVA0NGIg0nKj47zjA/+mt3tjZCjg5+B61nBi9cfQapuIHh8qlYhvZsZ0zLlIX/1c3QMgyldfxwPsjYNOmwkj45t6TSj6KB3t5cH8hwz81tEr8qJbSC8ctw019ICIq9XvnnGHjFkUfX98sXaKh54mBJ4Mcmi3Hy8DkS1Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTEiR1Qz6lRATiVQSMJNcayWK+Scmi1/LhcCcZf8F1w=;
 b=h4DP2WszcXryazjRB+43ID1FJG3PXRE5uSPue2SfC8AKkb00AuhmZtQErj1gdqXT1Pg54ik5qOOf/dAfueolx4jeTgrzkaYsolYxoj5Zee1M+vwmJLq+IPmdUDxFlEyBmcA/GvPHBSCdI9JXVxTvh+3Xn7TMWRJ6035VIvwzHj5iMe7SyMXBnsRUhJBHu7mp6y13Oy3qTho9XsyQxFYuXfbYNOw4W1Jnqa+rT0Lzqpc8dklOudgbPAXlAeMgVCeLiPFnRi/EO8lqHR5tPfbOVXxk9JXLTceis6TfmQe4IQpuuTnajPu6maUfnmUklKeB1lzYi7Ol0faTZFXAeaSDMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTEiR1Qz6lRATiVQSMJNcayWK+Scmi1/LhcCcZf8F1w=;
 b=fGZIMecW07/ISrJtUoBxElNcbqQslmkPv6hreghNgDfNXgUrWz7hZq5MUswAPlIctJ7MWQpWpetdDIQK254ZuxzwwIBA93ULqbm/gcqAJc5izzseBhu2E93clipMpsh3P6HcjkZql0D7fEmxMhHBwqJgg7ws0YO5EVuz2x+PUV0=
Received: from SN4PR2101MB0880.namprd21.prod.outlook.com (10.167.151.161) by
 SN4PR2101MB0880.namprd21.prod.outlook.com (10.167.151.161) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.3; Fri, 24 Jan 2020 03:08:18 +0000
Received: from SN4PR2101MB0880.namprd21.prod.outlook.com
 ([fe80::15c9:bf73:c204:7cb7]) by SN4PR2101MB0880.namprd21.prod.outlook.com
 ([fe80::15c9:bf73:c204:7cb7%9]) with mapi id 15.20.2686.007; Fri, 24 Jan 2020
 03:08:18 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH stable v4.19.99]: net: hv_sock: Remove the accept port
 restriction
Thread-Topic: [PATCH stable v4.19.99]: net: hv_sock: Remove the accept port
 restriction
Thread-Index: AdXSYghgJOzyN/r3TGGB3bEmeslGQA==
Date:   Fri, 24 Jan 2020 03:08:18 +0000
Message-ID: <SN4PR2101MB08801E39B5E814956A4F5708C00E0@SN4PR2101MB0880.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:5c76:73cf:f156:3b6c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 640838f3-11a9-40fc-7297-08d7a07aa981
x-ms-traffictypediagnostic: SN4PR2101MB0880:
x-microsoft-antispam-prvs: <SN4PR2101MB08809173F42A857193C5C2B1C00E0@SN4PR2101MB0880.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(199004)(189003)(52536014)(76116006)(64756008)(66946007)(5660300002)(66446008)(2906002)(66476007)(66556008)(33656002)(86362001)(316002)(478600001)(6506007)(7696005)(81156014)(8676002)(8990500004)(71200400001)(81166006)(55016002)(10290500003)(9686003)(8936002)(6916009)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0880;H:SN4PR2101MB0880.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gwxkyEUQhXC+MN4XkPnOPC/WoPUJeswtLysw/45qzvdq4/dbR7cE69i0fCxhrbYLAtwtuvneJqTZJkU5kFpT4r/CofYVAriG5+fvEIBme6CgAdm1j4aUzMb6an6rnr6R0xu827FBVepwE0fJGDxzZAOUjGzDDMacXLwqZsxsdfpy3GPuXa8Vwha5O8NlClJFcOirKygVekHyyJm457aBJMGHG6RrNU39ED7P3q0WqFIW6gURPBu3IXiT8yefeBypzFdon9nr98I7nFZOUsqMb/Egvsi7nXQ3vG6WdiY+JNRqBpASiyDc/vlGwkMwlFdREjfPFiBeVNTnKiayT0P6h5VoF+NSgP/ZGCfkvE8Rw3FAlmDouHZfB9AGm89bfi/jCF+i76sf1t+qQDA8E2apAnOhAuXSL76/TH5A0SfoeBCFuCH0tTygcHNKV2K8t4wY
x-ms-exchange-antispam-messagedata: /kouZ/E2W6PGUw5yRb/nmWQHFYdoudpVk8yqN4BgPSQlUnc1PSrKm4k1gzHEOUALot/bF18cNmnkneXQODY8TLLwNVWgrK/KzX4opIc7GW6RIxdAOBBPzbmh+Ep1zTybDhHMwss15YzY6NpBu0ViO0+Hbed5maptVKQ1r6TQrLkdCfFbCoB+wF1Qd75Uay0Yr0pCUr5DIbxQTrBNkS5spQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640838f3-11a9-40fc-7297-08d7a07aa981
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 03:08:18.5512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiRHD4ctg1CTfeJcFu9t42nRxqLxgpDBDrBym9/ZiEJ2iS+Clj5I0IAZn1TPBhyinAHoMucBmk4uIb6wODQ2ku1EaUNSOR/+QTv6exTXo+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0880
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c742c59e1fbd ("hv_sock: Remove the accept port restriction")

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
---
 net/vmw_vsock/hyperv_transport.c | 68 +++++---------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index 70350dc67366..db6ca51228d2 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -144,28 +144,15 @@ struct hvsock {
  *************************************************************************=
***
  * The only valid Service GUIDs, from the perspectives of both the host an=
d *
  * Linux VM, that can be connected by the other end, must conform to this =
  *
- * format: <port>-facb-11e6-bd58-64006a7986d3, and the "port" must be in  =
  *
- * this range [0, 0x7FFFFFFF].                                            =
  *
+ * format: <port>-facb-11e6-bd58-64006a7986d3.                            =
  *
  *************************************************************************=
***
  *
  * When we write apps on the host to connect(), the GUID ServiceID is used=
.
  * When we write apps in Linux VM to connect(), we only need to specify th=
e
  * port and the driver will form the GUID and use that to request the host=
.
  *
- * From the perspective of Linux VM:
- * 1. the local ephemeral port (i.e. the local auto-bound port when we cal=
l
- * connect() without explicit bind()) is generated by __vsock_bind_stream(=
),
- * and the range is [1024, 0xFFFFFFFF).
- * 2. the remote ephemeral port (i.e. the auto-generated remote port for
- * a connect request initiated by the host's connect()) is generated by
- * hvs_remote_addr_init() and the range is [0x80000000, 0xFFFFFFFF).
  */
=20
-#define MAX_LISTEN_PORT			((u32)0x7FFFFFFF)
-#define MAX_VM_LISTEN_PORT		MAX_LISTEN_PORT
-#define MAX_HOST_LISTEN_PORT		MAX_LISTEN_PORT
-#define MIN_HOST_EPHEMERAL_PORT		(MAX_HOST_LISTEN_PORT + 1)
-
 /* 00000000-facb-11e6-bd58-64006a7986d3 */
 static const uuid_le srv_id_template =3D
 	UUID_LE(0x00000000, 0xfacb, 0x11e6, 0xbd, 0x58,
@@ -188,33 +175,6 @@ static void hvs_addr_init(struct sockaddr_vm *addr, co=
nst uuid_le *svr_id)
 	vsock_addr_init(addr, VMADDR_CID_ANY, port);
 }
=20
-static void hvs_remote_addr_init(struct sockaddr_vm *remote,
-				 struct sockaddr_vm *local)
-{
-	static u32 host_ephemeral_port =3D MIN_HOST_EPHEMERAL_PORT;
-	struct sock *sk;
-
-	vsock_addr_init(remote, VMADDR_CID_ANY, VMADDR_PORT_ANY);
-
-	while (1) {
-		/* Wrap around ? */
-		if (host_ephemeral_port < MIN_HOST_EPHEMERAL_PORT ||
-		    host_ephemeral_port =3D=3D VMADDR_PORT_ANY)
-			host_ephemeral_port =3D MIN_HOST_EPHEMERAL_PORT;
-
-		remote->svm_port =3D host_ephemeral_port++;
-
-		sk =3D vsock_find_connected_socket(remote, local);
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
@@ -342,12 +302,7 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
 	if_type =3D &chan->offermsg.offer.if_type;
 	if_instance =3D &chan->offermsg.offer.if_instance;
 	conn_from_host =3D chan->offermsg.offer.u.pipe.user_def[0];
-
-	/* The host or the VM should only listen on a port in
-	 * [0, MAX_LISTEN_PORT]
-	 */
-	if (!is_valid_srv_id(if_type) ||
-	    get_port_by_srv_id(if_type) > MAX_LISTEN_PORT)
+	if (!is_valid_srv_id(if_type))
 		return;
=20
 	hvs_addr_init(&addr, conn_from_host ? if_type : if_instance);
@@ -371,6 +326,13 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
=20
 		new->sk_state =3D TCP_SYN_SENT;
 		vnew =3D vsock_sk(new);
+
+		hvs_addr_init(&vnew->local_addr, if_type);
+
+		/* Remote peer is always the host */
+		vsock_addr_init(&vnew->remote_addr,
+				VMADDR_CID_HOST, VMADDR_PORT_ANY);
+		vnew->remote_addr.svm_port =3D get_port_by_srv_id(if_instance);
 		hvs_new =3D vnew->trans;
 		hvs_new->chan =3D chan;
 	} else {
@@ -410,8 +372,6 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)
 		sk->sk_ack_backlog++;
=20
 		hvs_addr_init(&vnew->local_addr, if_type);
-		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
-
 		hvs_new->vm_srv_id =3D *if_type;
 		hvs_new->host_srv_id =3D *if_instance;
=20
@@ -716,16 +676,6 @@ static bool hvs_stream_is_active(struct vsock_sock *vs=
k)
=20
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
 	if (cid =3D=3D VMADDR_CID_HOST)
 		return true;
=20
--=20
2.17.1

