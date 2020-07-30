Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE529232E55
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgG3ITi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgG3IHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:07:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ACA42070B;
        Thu, 30 Jul 2020 08:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096471;
        bh=607reChhp6EKtOkI4IPELIlw7r9BVtK3n9rjMAH2/wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOZTBW+nm8Z1IbpXQgNWKwjLCvMR3a+yIBWbBnyVHdXF8ZlCrJ7duVsnPsVGFG33p
         AvKg7ZpFnzOQStWT34Q+0Lo97oWW6MKy/fZnf/mpl74g2Zao4T/xn9mEH/MkuCILxQ
         D7h13ea5Lp4DKB+dDZ9OTq7fqrKHvcGfhfM7skxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 02/14] AX.25: Prevent out-of-bounds read in ax25_sendmsg()
Date:   Thu, 30 Jul 2020 10:04:45 +0200
Message-Id: <20200730074419.010950200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074418.882736401@linuxfoundation.org>
References: <20200730074418.882736401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit 8885bb0621f01a6c82be60a91e5fc0f6e2f71186 ]

Checks on `addr_len` and `usax->sax25_ndigis` are insufficient.
ax25_sendmsg() can go out of bounds when `usax->sax25_ndigis` equals to 7
or 8. Fix it.

It is safe to remove `usax->sax25_ndigis > AX25_MAX_DIGIS`, since
`addr_len` is guaranteed to be less than or equal to
`sizeof(struct full_sockaddr_ax25)`

Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1513,7 +1513,8 @@ static int ax25_sendmsg(struct socket *s
 			struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)usax;
 
 			/* Valid number of digipeaters ? */
-			if (usax->sax25_ndigis < 1 || usax->sax25_ndigis > AX25_MAX_DIGIS) {
+			if (usax->sax25_ndigis < 1 || addr_len < sizeof(struct sockaddr_ax25) +
+			    sizeof(ax25_address) * usax->sax25_ndigis) {
 				err = -EINVAL;
 				goto out;
 			}


