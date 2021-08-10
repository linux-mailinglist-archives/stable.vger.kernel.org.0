Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F623DD7A1
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhHBNrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234224AbhHBNqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23EBA6052B;
        Mon,  2 Aug 2021 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912004;
        bh=85MZqbZVcCQZSMgqga7d72MAbW9yTzDl9QFXCJyB+CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmi7XfRC4q4Kr/FWk3yckDzJdSoU0gxqbdQFjNrsyYJtCkGEBjaETBX2ouzPWRTmr
         2Z3VnttuolmKd6hL17q6hbe1pVfSrArVL6WRNJhgzNhyaw3Zb6FNcCeHvn4K4m54Cv
         SnW3AM7D/0nR0c0KC9/dkiGvyy6V3pxHU35qMb24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com
Subject: [PATCH 4.4 24/26] net: llc: fix skb_over_panic
Date:   Mon,  2 Aug 2021 15:44:34 +0200
Message-Id: <20210802134332.816997097@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit c7c9d2102c9c098916ab9e0ab248006107d00d6c ]

Syzbot reported skb_over_panic() in llc_pdu_init_as_xid_cmd(). The
problem was in wrong LCC header manipulations.

Syzbot's reproducer tries to send XID packet. llc_ui_sendmsg() is
doing following steps:

	1. skb allocation with size = len + header size
		len is passed from userpace and header size
		is 3 since addr->sllc_xid is set.

	2. skb_reserve() for header_len = 3
	3. filling all other space with memcpy_from_msg()

Ok, at this moment we have fully loaded skb, only headers needs to be
filled.

Then code comes to llc_sap_action_send_xid_c(). This function pushes 3
bytes for LLC PDU header and initializes it. Then comes
llc_pdu_init_as_xid_cmd(). It initalizes next 3 bytes *AFTER* LLC PDU
header and call skb_push(skb, 3). This looks wrong for 2 reasons:

	1. Bytes rigth after LLC header are user data, so this function
	   was overwriting payload.

	2. skb_push(skb, 3) call can cause skb_over_panic() since
	   all free space was filled in llc_ui_sendmsg(). (This can
	   happen is user passed 686 len: 686 + 14 (eth header) + 3 (LLC
	   header) = 703. SKB_DATA_ALIGN(703) = 704)

So, in this patch I added 2 new private constansts: LLC_PDU_TYPE_U_XID
and LLC_PDU_LEN_U_XID. LLC_PDU_LEN_U_XID is used to correctly reserve
header size to handle LLC + XID case. LLC_PDU_TYPE_U_XID is used by
llc_pdu_header_init() function to push 6 bytes instead of 3. And finally
I removed skb_push() call from llc_pdu_init_as_xid_cmd().

This changes should not affect other parts of LLC, since after
all steps we just transmit buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/llc_pdu.h | 31 +++++++++++++++++++++++--------
 net/llc/af_llc.c      | 10 +++++++++-
 net/llc/llc_s_ac.c    |  2 +-
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/net/llc_pdu.h b/include/net/llc_pdu.h
index c0f0a13ed818..49aa79c7b278 100644
--- a/include/net/llc_pdu.h
+++ b/include/net/llc_pdu.h
@@ -15,9 +15,11 @@
 #include <linux/if_ether.h>
 
 /* Lengths of frame formats */
-#define LLC_PDU_LEN_I	4       /* header and 2 control bytes */
-#define LLC_PDU_LEN_S	4
-#define LLC_PDU_LEN_U	3       /* header and 1 control byte */
+#define LLC_PDU_LEN_I		4       /* header and 2 control bytes */
+#define LLC_PDU_LEN_S		4
+#define LLC_PDU_LEN_U		3       /* header and 1 control byte */
+/* header and 1 control byte and XID info */
+#define LLC_PDU_LEN_U_XID	(LLC_PDU_LEN_U + sizeof(struct llc_xid_info))
 /* Known SAP addresses */
 #define LLC_GLOBAL_SAP	0xFF
 #define LLC_NULL_SAP	0x00	/* not network-layer visible */
@@ -50,9 +52,10 @@
 #define LLC_PDU_TYPE_U_MASK    0x03	/* 8-bit control field */
 #define LLC_PDU_TYPE_MASK      0x03
 
-#define LLC_PDU_TYPE_I	0	/* first bit */
-#define LLC_PDU_TYPE_S	1	/* first two bits */
-#define LLC_PDU_TYPE_U	3	/* first two bits */
+#define LLC_PDU_TYPE_I		0	/* first bit */
+#define LLC_PDU_TYPE_S		1	/* first two bits */
+#define LLC_PDU_TYPE_U		3	/* first two bits */
+#define LLC_PDU_TYPE_U_XID	4	/* private type for detecting XID commands */
 
 #define LLC_PDU_TYPE_IS_I(pdu) \
 	((!(pdu->ctrl_1 & LLC_PDU_TYPE_I_MASK)) ? 1 : 0)
@@ -230,9 +233,18 @@ static inline struct llc_pdu_un *llc_pdu_un_hdr(struct sk_buff *skb)
 static inline void llc_pdu_header_init(struct sk_buff *skb, u8 type,
 				       u8 ssap, u8 dsap, u8 cr)
 {
-	const int hlen = type == LLC_PDU_TYPE_U ? 3 : 4;
+	int hlen = 4; /* default value for I and S types */
 	struct llc_pdu_un *pdu;
 
+	switch (type) {
+	case LLC_PDU_TYPE_U:
+		hlen = 3;
+		break;
+	case LLC_PDU_TYPE_U_XID:
+		hlen = 6;
+		break;
+	}
+
 	skb_push(skb, hlen);
 	skb_reset_network_header(skb);
 	pdu = llc_pdu_un_hdr(skb);
@@ -374,7 +386,10 @@ static inline void llc_pdu_init_as_xid_cmd(struct sk_buff *skb,
 	xid_info->fmt_id = LLC_XID_FMT_ID;	/* 0x81 */
 	xid_info->type	 = svcs_supported;
 	xid_info->rw	 = rx_window << 1;	/* size of receive window */
-	skb_put(skb, sizeof(struct llc_xid_info));
+
+	/* no need to push/put since llc_pdu_header_init() has already
+	 * pushed 3 + 3 bytes
+	 */
 }
 
 /**
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index f613a1007107..82b07bc43071 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -96,8 +96,16 @@ static inline u8 llc_ui_header_len(struct sock *sk, struct sockaddr_llc *addr)
 {
 	u8 rc = LLC_PDU_LEN_U;
 
-	if (addr->sllc_test || addr->sllc_xid)
+	if (addr->sllc_test)
 		rc = LLC_PDU_LEN_U;
+	else if (addr->sllc_xid)
+		/* We need to expand header to sizeof(struct llc_xid_info)
+		 * since llc_pdu_init_as_xid_cmd() sets 4,5,6 bytes of LLC header
+		 * as XID PDU. In llc_ui_sendmsg() we reserved header size and then
+		 * filled all other space with user data. If we won't reserve this
+		 * bytes, llc_pdu_init_as_xid_cmd() will overwrite user data
+		 */
+		rc = LLC_PDU_LEN_U_XID;
 	else if (sk->sk_type == SOCK_STREAM)
 		rc = LLC_PDU_LEN_I;
 	return rc;
diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index 7ae4cc684d3a..9fa3342c7a82 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -79,7 +79,7 @@ int llc_sap_action_send_xid_c(struct llc_sap *sap, struct sk_buff *skb)
 	struct llc_sap_state_ev *ev = llc_sap_ev(skb);
 	int rc;
 
-	llc_pdu_header_init(skb, LLC_PDU_TYPE_U, ev->saddr.lsap,
+	llc_pdu_header_init(skb, LLC_PDU_TYPE_U_XID, ev->saddr.lsap,
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_xid_cmd(skb, LLC_XID_NULL_CLASS_2, 0);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-- 
2.30.2



