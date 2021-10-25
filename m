Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C243A21C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhJYTpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235709AbhJYTmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64EF611BF;
        Mon, 25 Oct 2021 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190639;
        bh=gS7qoFrJdXGE1q4BHPxmCDb8TqlAljlvorPg4eBZB1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYuTlJdV0noNZEWWx9/G+Onv8+/GcJT5MisBYmV0emE4ui1a3Qv7125WItL7a2phS
         ZGR6dqIguNa0xJyGyo6/IKYwVVqYjLu8uSVj9FK+0RpmOolIHwsDU/e0Wddrx7b0uC
         l40Q/NVyTdNw1en7HOpmj1lobPpi14yErUDbPh6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 034/169] sctp: fix transport encap_port update in sctp_vtag_verify
Date:   Mon, 25 Oct 2021 21:13:35 +0200
Message-Id: <20211025191022.234000002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 075718fdaf0efe20223571236c1bf14ca35a7aa1 ]

transport encap_port update should be updated when sctp_vtag_verify()
succeeds, namely, returns 1, not returns 0. Correct it in this patch.

While at it, also fix the indentation.

Fixes: a1dd2cf2f1ae ("sctp: allow changing transport encap_port by peer packets")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 2eb6d7c2c931..f37c7a558d6d 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -384,11 +384,11 @@ sctp_vtag_verify(const struct sctp_chunk *chunk,
 	 * Verification Tag value does not match the receiver's own
 	 * tag value, the receiver shall silently discard the packet...
 	 */
-        if (ntohl(chunk->sctp_hdr->vtag) == asoc->c.my_vtag)
-                return 1;
+	if (ntohl(chunk->sctp_hdr->vtag) != asoc->c.my_vtag)
+		return 0;
 
 	chunk->transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
-	return 0;
+	return 1;
 }
 
 /* Check VTAG of the packet matches the sender's own tag and the T bit is
-- 
2.33.0



