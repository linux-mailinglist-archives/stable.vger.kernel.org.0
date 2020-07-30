Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E6E232E90
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgG3IVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgG3IFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:05:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3B02070B;
        Thu, 30 Jul 2020 08:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096308;
        bh=v61CPWdgGRsnKXt5icxwxs9r8gWqINpvutOme/L9yRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6GUsERGiI7hgTRvcnX+HVmoamcwRdHXyEK+xriuH7KqJvty9MgDSuiTVkthLSW+R
         o9qr/vAH34oPlB1OQLJV6qY5OxbYFT6v9iYiMXHe7rtM8hEQJzUjTXunveiO/Gkzqs
         9iLb9XlqUciCTeX3mHH3sTLFSl9Bp+ARNm2DbuLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 02/20] AX.25: Prevent out-of-bounds read in ax25_sendmsg()
Date:   Thu, 30 Jul 2020 10:03:52 +0200
Message-Id: <20200730074420.656190044@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
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
@@ -1509,7 +1509,8 @@ static int ax25_sendmsg(struct socket *s
 			struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)usax;
 
 			/* Valid number of digipeaters ? */
-			if (usax->sax25_ndigis < 1 || usax->sax25_ndigis > AX25_MAX_DIGIS) {
+			if (usax->sax25_ndigis < 1 || addr_len < sizeof(struct sockaddr_ax25) +
+			    sizeof(ax25_address) * usax->sax25_ndigis) {
 				err = -EINVAL;
 				goto out;
 			}


