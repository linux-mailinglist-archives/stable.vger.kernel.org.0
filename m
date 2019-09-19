Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A06B8617
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394216AbfISW0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394064AbfISWVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:21:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842DD21929;
        Thu, 19 Sep 2019 22:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931703;
        bh=xTImHa+Fw+hcY0JKhsE+/yBCH+214SuUveX5vVfK+MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h63iTYV13MD7jJJCrNWzH2wnE/VEQxjiKiKDzafch1EwGTrg3XQKDtmyVuQD2Fbh1
         QPYvJFX6xY2Qk0g4KmK7DGYYiiUWbHFF4bjkbGvYCcSqNZ9v802ufdsfWFPB73f1I9
         cWunprg+BE1YdaMJX8c7WHPbxhqp9vx8NSxdfGE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 01/56] bridge/mdb: remove wrong use of NLM_F_MULTI
Date:   Fri, 20 Sep 2019 00:03:42 +0200
Message-Id: <20190919214743.107531741@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 94a72b3f024fc7e9ab640897a1e38583a470659d ]

NLM_F_MULTI must be used only when a NLMSG_DONE message is sent at the end.
In fact, NLMSG_DONE is sent only at the end of a dump.

Libraries like libnl will wait forever for NLMSG_DONE.

Fixes: 949f1e39a617 ("bridge: mdb: notify on router port add and del")
CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_mdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -256,7 +256,7 @@ static int nlmsg_populate_rtr_fill(struc
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 
-	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*bpm), NLM_F_MULTI);
+	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*bpm), 0);
 	if (!nlh)
 		return -EMSGSIZE;
 


