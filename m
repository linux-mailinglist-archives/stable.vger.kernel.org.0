Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE17B1FD4
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbfIMNJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388393AbfIMNI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:08:59 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D6E20CC7;
        Fri, 13 Sep 2019 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380139;
        bh=xxcNvHAUzHqpe4b/uPFLBWmvx6l6ZoYVFfAIjThIUSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtoGSUkn9jr+SMUTRjFJg3tu2sBUCnjwzDdas20DtDWQyLvMEVIiKXCx0XVe+vY78
         eDrOamobVi3jvNAIgTANsHOIT/CnLiZGQnUuRl/xI9zTOW8/P/LvC3vQ15iW5Nng0z
         rWQb3cVBrrWvfq/oXLse37dSKq8npwviAcs7WqXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 8/9] af_packet: tone down the Tx-ring unsupported spew.
Date:   Fri, 13 Sep 2019 14:06:58 +0100
Message-Id: <20190913130431.515555493@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130424.160808669@linuxfoundation.org>
References: <20190913130424.160808669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6ae81ced378820c4c6434b1dedba14a7122df310 ]

Trinity and other fuzzers can hit this WARN on far too easily,
resulting in a tainted kernel that hinders automated fuzzing.

Replace it with a rate-limited printk.

Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5d8988185c591..0dd9fc3f57e87 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4176,7 +4176,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	/* Opening a Tx-ring is NOT supported in TPACKET_V3 */
 	if (!closing && tx_ring && (po->tp_version > TPACKET_V2)) {
-		WARN(1, "Tx-ring is not supported.\n");
+		net_warn_ratelimited("Tx-ring is not supported.\n");
 		goto out;
 	}
 
-- 
2.20.1



