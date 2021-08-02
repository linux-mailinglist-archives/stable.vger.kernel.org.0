Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52F3DD909
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhHBN4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236278AbhHBNzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052CB611C4;
        Mon,  2 Aug 2021 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912428;
        bh=B9WDRWUz1X9xefLY/z+avPgVzyijOV2Eoxz+KKGs7oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch2JeDTt0RFdjZPX4dkSDVKPDImDfjqiSI5Ua2TRl293hnsElzecG664D+F73uHvj
         mZrhCcjScyoBckXTg69ll0Wowd3GRJh0WALdke5OYozBhFOEI01ktT0fQgoDRmMIMu
         QAFrSyPUi0cSfSrLGqfZ6FHsEe5F8gjvtVFjR/54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/67] sctp: fix return value check in __sctp_rcv_asconf_lookup
Date:   Mon,  2 Aug 2021 15:45:17 +0200
Message-Id: <20210802134340.882877442@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
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
index f72bff93745c..ddb5b5c2550e 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1175,7 +1175,7 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	if (unlikely(!af))
 		return NULL;
 
-	if (af->from_addr_param(&paddr, param, peer_port, 0))
+	if (!af->from_addr_param(&paddr, param, peer_port, 0))
 		return NULL;
 
 	return __sctp_lookup_association(net, laddr, &paddr, transportp);
-- 
2.30.2



