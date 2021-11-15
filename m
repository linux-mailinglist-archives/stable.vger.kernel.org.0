Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58A945140C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348920AbhKOUAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344161AbhKOTXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A40AB632A6;
        Mon, 15 Nov 2021 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002380;
        bh=ZthVkNfp1aBMaQGDLnuqGuaUv33dpWzeRJ1vmLT2fes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmRYk8+Cy736aMRVa7d/bc5y5PrKfD+6qD8/uTnQfPTpbVzdj+ISvKY0nHecvXiI5
         7tU9ncbRmaWaZp6yifc6QEQGcindeIdlBnefFybBSEte3/pRw/EzEQlb73zVsjM4cM
         JIWtqQzr/mWiy5YXiwurONXwA6egA0zx4EFwRiE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 544/917] sctp: subtract sctphdr len in sctp_transport_pl_hlen
Date:   Mon, 15 Nov 2021 18:00:39 +0100
Message-Id: <20211115165447.204080560@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit cc4665ca646c96181a7c00198aa72c59e0c576e8 ]

sctp_transport_pl_hlen() is called to calculate the outer header length
for PL. However, as the Figure in rfc8899#section-4.4:

   Any additional
     headers         .--- MPS -----.
            |        |             |
            v        v             v
     +------------------------------+
     | IP | ** | PL | protocol data |
     +------------------------------+

                <----- PLPMTU ----->
     <---------- PMTU -------------->

Outer header are IP + Any additional headers, which doesn't include
Packetization Layer itself header, namely sctphdr, whereas sctphdr
is counted by __sctp_mtu_payload().

The incorrect calculation caused the link pathmtu to be set larger
than expected by t->pl.pmtu + sctp_transport_pl_hlen(). This patch
is to fix it by subtracting sctphdr len in sctp_transport_pl_hlen().

Fixes: d9e2e410ae30 ("sctp: add the constants/variables and states and some APIs for transport")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index bc00410223b03..189fdb9db1622 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -626,7 +626,8 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
 
 static inline int sctp_transport_pl_hlen(struct sctp_transport *t)
 {
-	return __sctp_mtu_payload(sctp_sk(t->asoc->base.sk), t, 0, 0);
+	return __sctp_mtu_payload(sctp_sk(t->asoc->base.sk), t, 0, 0) -
+	       sizeof(struct sctphdr);
 }
 
 static inline void sctp_transport_pl_reset(struct sctp_transport *t)
-- 
2.33.0



