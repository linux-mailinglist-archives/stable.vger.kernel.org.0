Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9A4232E04
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgG3IKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgG3IKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:10:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F3A32074B;
        Thu, 30 Jul 2020 08:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096639;
        bh=8YRW/f78TgXrKU6CirmFlfF1OeBr1ipbQ53HPQPsv8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HT+reNW//Eak5P54EQr4tentGNxfmMrgQo2obA/3Tx71gJl9XkBxRaOoYLqYKCaJN
         H86ufkItEomsPnjOVyVV7X0OtvJQ1k9xbDfso8SlbEB/I8Xd2KCEiRJ17g4+Mg6QvQ
         NREMA2gREOSk2IXr4ptiqejCJUxuwqVqyxJOYaEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 52/61] AX.25: Prevent integer overflows in connect and sendmsg
Date:   Thu, 30 Jul 2020 10:05:10 +0200
Message-Id: <20200730074423.354748671@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 17ad73e941b71f3bec7523ea4e9cbc3752461c2d ]

We recently added some bounds checking in ax25_connect() and
ax25_sendmsg() and we so we removed the AX25_MAX_DIGIS checks because
they were no longer required.

Unfortunately, I believe they are required to prevent integer overflows
so I have added them back.

Fixes: 8885bb0621f0 ("AX.25: Prevent out-of-bounds read in ax25_sendmsg()")
Fixes: 2f2a7ffad5c6 ("AX.25: Fix out-of-bounds read in ax25_connect()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1192,6 +1192,7 @@ static int __must_check ax25_connect(str
 	    fsa->fsa_ax25.sax25_ndigis != 0) {
 		/* Valid number of digipeaters ? */
 		if (fsa->fsa_ax25.sax25_ndigis < 1 ||
+		    fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS ||
 		    addr_len < sizeof(struct sockaddr_ax25) +
 		    sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis) {
 			err = -EINVAL;
@@ -1512,7 +1513,9 @@ static int ax25_sendmsg(struct socket *s
 			struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)usax;
 
 			/* Valid number of digipeaters ? */
-			if (usax->sax25_ndigis < 1 || addr_len < sizeof(struct sockaddr_ax25) +
+			if (usax->sax25_ndigis < 1 ||
+			    usax->sax25_ndigis > AX25_MAX_DIGIS ||
+			    addr_len < sizeof(struct sockaddr_ax25) +
 			    sizeof(ax25_address) * usax->sax25_ndigis) {
 				err = -EINVAL;
 				goto out;


