Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31003126CE4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfLSSnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbfLSSnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABAF24672;
        Thu, 19 Dec 2019 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781019;
        bh=bi/8A1ieS2KJBVjW6wsQtCjcWkcfnIBmZ4CPqoDWohg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIt/PmXj1t8xZlj6vrFsjEu8ovb/4nG24HD6H6vRAHN/YqFQV16vqJ8TIoj+Mzdat
         DbHQ43rsYqeA/6GQ+yWHcdsHksgkpO3oVYNB125ipm4oHOoCxILrRzvssMDRVsqct+
         /a3uqxaFsu1UbJIn1a7k17LVanW1LIEYCxCY3WgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/199] net/x25: fix called/calling length calculation in x25_parse_address_block
Date:   Thu, 19 Dec 2019 19:32:12 +0100
Message-Id: <20191219183217.725140750@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit d449ba3d581ed29f751a59792fdc775572c66904 ]

The length of the called and calling address was not calculated
correctly (BCD encoding).

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 770ababb8f928..ebd9c5f50a571 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -100,7 +100,7 @@ int x25_parse_address_block(struct sk_buff *skb,
 	}
 
 	len = *skb->data;
-	needed = 1 + (len >> 4) + (len & 0x0f);
+	needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
 
 	if (!pskb_may_pull(skb, needed)) {
 		/* packet is too short to hold the addresses it claims
-- 
2.20.1



