Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7764F2C15
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbiDEJK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244487AbiDEIwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F088D64CC;
        Tue,  5 Apr 2022 01:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12A5760FFC;
        Tue,  5 Apr 2022 08:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19447C385A1;
        Tue,  5 Apr 2022 08:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148055;
        bh=0ekwhSgAGaY6R4SI2MfPgv0lV5V0Tysc0FMevX6vzJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17IROk+u/JiEuSrrxMsMxglfsetWN/oakmMfi/D+u9rFFBw86G/S5DQW08/KldaR1
         ePsmuvz0yiY+kglBaSXy79B63WDvZhvEnNDFXcf63wHSbIIPvPYcVgMIfAdD+LIxef
         FhE8qXNZMCvY2Rar/S5PR0ePhuYtPMbjNYKF7u8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashanth Prahlad <pprahlad@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0217/1017] security: implement sctp_assoc_established hook in selinux
Date:   Tue,  5 Apr 2022 09:18:50 +0200
Message-Id: <20220405070400.692535968@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 3eb8eaf2ca3e98d4f6e52bed6148ee8fe3069a3d ]

Do this by extracting the peer labeling per-association logic from
selinux_sctp_assoc_request() into a new helper
selinux_sctp_process_new_assoc() and use this helper in both
selinux_sctp_assoc_request() and selinux_sctp_assoc_established(). This
ensures that the peer labeling behavior as documented in
Documentation/security/SCTP.rst is applied both on the client and server
side:
"""
An SCTP socket will only have one peer label assigned to it. This will be
assigned during the establishment of the first association. Any further
associations on this socket will have their packet peer label compared to
the sockets peer label, and only if they are different will the
``association`` permission be validated. This is validated by checking the
socket peer sid against the received packets peer sid to determine whether
the association should be allowed or denied.
"""

At the same time, it also ensures that the peer label of the association
is set to the correct value, such that if it is peeled off into a new
socket, the socket's peer label  will then be set to the association's
peer label, same as it already works on the server side.

While selinux_inet_conn_established() (which we are replacing by
selinux_sctp_assoc_established() for SCTP) only deals with assigning a
peer label to the connection (socket), in case of SCTP we need to also
copy the (local) socket label to the association, so that
selinux_sctp_sk_clone() can then pick it up for the new socket in case
of SCTP peeloff.

Careful readers will notice that the selinux_sctp_process_new_assoc()
helper also includes the "IPv4 packet received over an IPv6 socket"
check, even though it hadn't been in selinux_sctp_assoc_request()
before. While such check is not necessary in
selinux_inet_conn_request() (because struct request_sock's family field
is already set according to the skb's family), here it is needed, as we
don't have request_sock and we take the initial family from the socket.
In selinux_sctp_assoc_established() it is similarly needed as well (and
also selinux_inet_conn_established() already has it).

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Based-on-patch-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Tested-by: Richard Haines <richard_c_haines@btinternet.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 90 +++++++++++++++++++++++++++++-----------
 1 file changed, 66 insertions(+), 24 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 30f08fc1ac09..93eac9464c5f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5355,37 +5355,38 @@ static void selinux_sock_graft(struct sock *sk, struct socket *parent)
 	sksec->sclass = isec->sclass;
 }
 
-/* Called whenever SCTP receives an INIT chunk. This happens when an incoming
- * connect(2), sctp_connectx(3) or sctp_sendmsg(3) (with no association
- * already present).
+/*
+ * Determines peer_secid for the asoc and updates socket's peer label
+ * if it's the first association on the socket.
  */
-static int selinux_sctp_assoc_request(struct sctp_association *asoc,
-				      struct sk_buff *skb)
+static int selinux_sctp_process_new_assoc(struct sctp_association *asoc,
+					  struct sk_buff *skb)
 {
-	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
+	struct sock *sk = asoc->base.sk;
+	u16 family = sk->sk_family;
+	struct sk_security_struct *sksec = sk->sk_security;
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
-	u8 peerlbl_active;
-	u32 peer_sid = SECINITSID_UNLABELED;
-	u32 conn_sid;
-	int err = 0;
+	int err;
 
-	if (!selinux_policycap_extsockclass())
-		return 0;
+	/* handle mapped IPv4 packets arriving via IPv6 sockets */
+	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
+		family = PF_INET;
 
-	peerlbl_active = selinux_peerlbl_enabled();
+	if (selinux_peerlbl_enabled()) {
+		asoc->peer_secid = SECSID_NULL;
 
-	if (peerlbl_active) {
 		/* This will return peer_sid = SECSID_NULL if there are
 		 * no peer labels, see security_net_peersid_resolve().
 		 */
-		err = selinux_skb_peerlbl_sid(skb, asoc->base.sk->sk_family,
-					      &peer_sid);
+		err = selinux_skb_peerlbl_sid(skb, family, &asoc->peer_secid);
 		if (err)
 			return err;
 
-		if (peer_sid == SECSID_NULL)
-			peer_sid = SECINITSID_UNLABELED;
+		if (asoc->peer_secid == SECSID_NULL)
+			asoc->peer_secid = SECINITSID_UNLABELED;
+	} else {
+		asoc->peer_secid = SECINITSID_UNLABELED;
 	}
 
 	if (sksec->sctp_assoc_state == SCTP_ASSOC_UNSET) {
@@ -5396,8 +5397,8 @@ static int selinux_sctp_assoc_request(struct sctp_association *asoc,
 		 * then it is approved by policy and used as the primary
 		 * peer SID for getpeercon(3).
 		 */
-		sksec->peer_sid = peer_sid;
-	} else if  (sksec->peer_sid != peer_sid) {
+		sksec->peer_sid = asoc->peer_secid;
+	} else if (sksec->peer_sid != asoc->peer_secid) {
 		/* Other association peer SIDs are checked to enforce
 		 * consistency among the peer SIDs.
 		 */
@@ -5405,11 +5406,32 @@ static int selinux_sctp_assoc_request(struct sctp_association *asoc,
 		ad.u.net = &net;
 		ad.u.net->sk = asoc->base.sk;
 		err = avc_has_perm(&selinux_state,
-				   sksec->peer_sid, peer_sid, sksec->sclass,
-				   SCTP_SOCKET__ASSOCIATION, &ad);
+				   sksec->peer_sid, asoc->peer_secid,
+				   sksec->sclass, SCTP_SOCKET__ASSOCIATION,
+				   &ad);
 		if (err)
 			return err;
 	}
+	return 0;
+}
+
+/* Called whenever SCTP receives an INIT or COOKIE ECHO chunk. This
+ * happens on an incoming connect(2), sctp_connectx(3) or
+ * sctp_sendmsg(3) (with no association already present).
+ */
+static int selinux_sctp_assoc_request(struct sctp_association *asoc,
+				      struct sk_buff *skb)
+{
+	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
+	u32 conn_sid;
+	int err;
+
+	if (!selinux_policycap_extsockclass())
+		return 0;
+
+	err = selinux_sctp_process_new_assoc(asoc, skb);
+	if (err)
+		return err;
 
 	/* Compute the MLS component for the connection and store
 	 * the information in asoc. This will be used by SCTP TCP type
@@ -5417,17 +5439,36 @@ static int selinux_sctp_assoc_request(struct sctp_association *asoc,
 	 * socket to be generated. selinux_sctp_sk_clone() will then
 	 * plug this into the new socket.
 	 */
-	err = selinux_conn_sid(sksec->sid, peer_sid, &conn_sid);
+	err = selinux_conn_sid(sksec->sid, asoc->peer_secid, &conn_sid);
 	if (err)
 		return err;
 
 	asoc->secid = conn_sid;
-	asoc->peer_secid = peer_sid;
 
 	/* Set any NetLabel labels including CIPSO/CALIPSO options. */
 	return selinux_netlbl_sctp_assoc_request(asoc, skb);
 }
 
+/* Called when SCTP receives a COOKIE ACK chunk as the final
+ * response to an association request (initited by us).
+ */
+static int selinux_sctp_assoc_established(struct sctp_association *asoc,
+					  struct sk_buff *skb)
+{
+	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
+
+	if (!selinux_policycap_extsockclass())
+		return 0;
+
+	/* Inherit secid from the parent socket - this will be picked up
+	 * by selinux_sctp_sk_clone() if the association gets peeled off
+	 * into a new socket.
+	 */
+	asoc->secid = sksec->sid;
+
+	return selinux_sctp_process_new_assoc(asoc, skb);
+}
+
 /* Check if sctp IPv4/IPv6 addresses are valid for binding or connecting
  * based on their @optname.
  */
@@ -7248,6 +7289,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
 	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
 	LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
+	LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
 	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
 	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
 	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
-- 
2.34.1



