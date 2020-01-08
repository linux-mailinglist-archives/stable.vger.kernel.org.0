Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02F134BAA
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgAHTqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43384 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730169AbgAHTqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:00 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-0006no-HR; Wed, 08 Jan 2020 19:45:57 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dkz-4V; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sage Weil" <sage@redhat.com>, "Ilya Dryomov" <idryomov@gmail.com>
Date:   Wed, 08 Jan 2020 19:43:05 +0000
Message-ID: <lsq.1578512578.424317046@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/63] libceph: handle an empty authorize reply
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 0fd3fd0a9bb0b02b6435bb7070e9f7b82a23f068 upstream.

The authorize reply can be empty, for example when the ticket used to
build the authorizer is too old and TAG_BADAUTHORIZER is returned from
the service.  Calling ->verify_authorizer_reply() results in an attempt
to decrypt and validate (somewhat) random data in au->buf (most likely
the signature block from calc_signature()), which fails and ends up in
con_fault_finish() with !con->auth_retry.  The ticket isn't invalidated
and the connection is retried again and again until a new ticket is
obtained from the monitor:

  libceph: osd2 192.168.122.1:6809 bad authorize reply
  libceph: osd2 192.168.122.1:6809 bad authorize reply
  libceph: osd2 192.168.122.1:6809 bad authorize reply
  libceph: osd2 192.168.122.1:6809 bad authorize reply

Let TAG_BADAUTHORIZER handler kick in and increment con->auth_retry.

Fixes: 5c056fdc5b47 ("libceph: verify authorize reply on connect")
Link: https://tracker.ceph.com/issues/20164
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Sage Weil <sage@redhat.com>
[idryomov@gmail.com: backport to 4.4: extra arg, no CEPHX_V2]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ceph/messenger.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1984,15 +1984,19 @@ static int process_connect(struct ceph_c
 	dout("process_connect on %p tag %d\n", con, (int)con->in_tag);
 
 	if (con->auth_reply_buf) {
+		int len = le32_to_cpu(con->in_reply.authorizer_len);
+
 		/*
 		 * Any connection that defines ->get_authorizer()
 		 * should also define ->verify_authorizer_reply().
 		 * See get_connect_authorizer().
 		 */
-		ret = con->ops->verify_authorizer_reply(con, 0);
-		if (ret < 0) {
-			con->error_msg = "bad authorize reply";
-			return ret;
+		if (len) {
+			ret = con->ops->verify_authorizer_reply(con, 0);
+			if (ret < 0) {
+				con->error_msg = "bad authorize reply";
+				return ret;
+			}
 		}
 	}
 

