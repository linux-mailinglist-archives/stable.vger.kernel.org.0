Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16ED328FC6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhCAT6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236046AbhCATov (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D2464F34;
        Mon,  1 Mar 2021 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620361;
        bh=6mYZ4RgTHW7sK5kJf72iEJkj6mnZPhTzIIYcC3GRuZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjxZrhfAQbYjWPeZssbZfyqG8wzPs9b+5CyfMdXf9LacZ9I80wrURss0L6aMxE5ij
         Omqh51k9ZGuLiPxHOMWFF+nKK9pEm7TAb9sTlMQzXywUxdieJNILaPU+x06Chzh0g2
         C4irQeytYvm+UeVUNYjYXFH4Z0Njn/ZQr3+Y/d24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 125/775] cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds
Date:   Mon,  1 Mar 2021 17:04:53 +0100
Message-Id: <20210301161207.851470160@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit 2355a6773a2cb0d2dce13432dde78497f1d6617b ]

The Max imm data size in cxgb4 is not similar to the max imm data size
in the chtls. This caused an mismatch in output of is_ofld_imm() of
cxgb4 and chtls. So fixed this by keeping the max wreq size of imm data
same in both chtls and cxgb4 as MAX_IMM_OFLD_TX_DATA_WR_LEN.

As cxgb4's max imm. data value for ofld packets is changed to
MAX_IMM_OFLD_TX_DATA_WR_LEN. Using the same in cxgbit also.

Fixes: 36bedb3f2e5b8 ("crypto: chtls - Inline TLS record Tx")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h        |  3 +++
 drivers/net/ethernet/chelsio/cxgb4/sge.c              | 11 ++++++++---
 .../ethernet/chelsio/inline_crypto/chtls/chtls_cm.h   |  3 ---
 drivers/target/iscsi/cxgbit/cxgbit_target.c           |  3 +--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 1b49f2fa9b185..34546f5312eee 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -46,6 +46,9 @@
 #define MAX_ULD_QSETS 16
 #define MAX_ULD_NPORTS 4
 
+/* ulp_mem_io + ulptx_idata + payload + padding */
+#define MAX_IMM_ULPTX_WR_LEN (32 + 8 + 256 + 8)
+
 /* CPL message priority levels */
 enum {
 	CPL_PRIORITY_DATA     = 0,  /* data messages */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 196652a114c5f..3334c9e2152ab 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2842,17 +2842,22 @@ int t4_mgmt_tx(struct adapter *adap, struct sk_buff *skb)
  *	@skb: the packet
  *
  *	Returns true if a packet can be sent as an offload WR with immediate
- *	data.  We currently use the same limit as for Ethernet packets.
+ *	data.
+ *	FW_OFLD_TX_DATA_WR limits the payload to 255 bytes due to 8-bit field.
+ *      However, FW_ULPTX_WR commands have a 256 byte immediate only
+ *      payload limit.
  */
 static inline int is_ofld_imm(const struct sk_buff *skb)
 {
 	struct work_request_hdr *req = (struct work_request_hdr *)skb->data;
 	unsigned long opcode = FW_WR_OP_G(ntohl(req->wr_hi));
 
-	if (opcode == FW_CRYPTO_LOOKASIDE_WR)
+	if (unlikely(opcode == FW_ULPTX_WR))
+		return skb->len <= MAX_IMM_ULPTX_WR_LEN;
+	else if (opcode == FW_CRYPTO_LOOKASIDE_WR)
 		return skb->len <= SGE_MAX_WR_LEN;
 	else
-		return skb->len <= MAX_IMM_TX_PKT_LEN;
+		return skb->len <= MAX_IMM_OFLD_TX_DATA_WR_LEN;
 }
 
 /**
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
index 47ba81e42f5d0..b1161bdeda4dc 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.h
@@ -50,9 +50,6 @@
 #define MIN_RCV_WND (24 * 1024U)
 #define LOOPBACK(x)     (((x) & htonl(0xff000000)) == htonl(0x7f000000))
 
-/* ulp_mem_io + ulptx_idata + payload + padding */
-#define MAX_IMM_ULPTX_WR_LEN (32 + 8 + 256 + 8)
-
 /* for TX: a skb must have a headroom of at least TX_HEADER_LEN bytes */
 #define TX_HEADER_LEN \
 	(sizeof(struct fw_ofld_tx_data_wr) + sizeof(struct sge_opaque_hdr))
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 9b3eb2e8c92ad..b926e1d6c7b8e 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -86,8 +86,7 @@ static int cxgbit_is_ofld_imm(const struct sk_buff *skb)
 	if (likely(cxgbit_skcb_flags(skb) & SKCBF_TX_ISO))
 		length += sizeof(struct cpl_tx_data_iso);
 
-#define MAX_IMM_TX_PKT_LEN	256
-	return length <= MAX_IMM_TX_PKT_LEN;
+	return length <= MAX_IMM_OFLD_TX_DATA_WR_LEN;
 }
 
 /*
-- 
2.27.0



