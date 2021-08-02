Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2583DD81C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhHBNtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234878AbhHBNtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:49:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16BBA6052B;
        Mon,  2 Aug 2021 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912156;
        bh=WYmGpK9MuBMK7KA6QMd3ZT6+dbn2a91sXwbwXXXBvcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ec47LNRZpMyYdD24T1LvXNuUvc+o4qDk1PteZ+KTmn6y6prBuc4PqUm35pOF3jzVv
         2DIRUrP/a7syd59sEAtFaqCfLbasryOjoSzrM8qcDzC/LZcl5hH5tBeNHtpkDs99ZF
         gFHbyvRuRZlqIGyRCGrxH7BnxTFxA5jj7v4FbDqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 34/38] sctp: fix return value check in __sctp_rcv_asconf_lookup
Date:   Mon,  2 Aug 2021 15:44:56 +0200
Message-Id: <20210802134335.904585164@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 557fb5862c9272ad9b21407afe1da8acfd9b53eb ]

As Ben Hutchings noticed, this check should have been inverted: the call
returns true in case of success.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 0c5dc070ff3d ("sctp: validate from_addr_param return")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 1af35b69e99e..90428c59cfaf 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1125,7 +1125,7 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	if (unlikely(!af))
 		return NULL;
 
-	if (af->from_addr_param(&paddr, param, peer_port, 0))
+	if (!af->from_addr_param(&paddr, param, peer_port, 0))
 		return NULL;
 
 	return __sctp_lookup_association(net, laddr, &paddr, transportp);
-- 
2.30.2



