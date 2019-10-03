Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A00CAA60
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392874AbfJCREK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405008AbfJCQlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CBF0206BB;
        Thu,  3 Oct 2019 16:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120876;
        bh=0xn1V+dQaLQrN6Mj+KrT7gR0pmwR/tohH0dFedkmAxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4JNlVIxy5GyFmvR9o9PKGZb9mtYzuRzlOeaKrU9oa0OI00WsrH+6M+lfD62a7nf0
         YZbsQRR2AjSeNzkyZLTcuQqjfqfhvEZy7CHQm2P+BOluBDZ3sQXzuLId/xUQCJTY4W
         8YoqNClnwidGLmc+vQyyzGOHdYBFYiENn5HtYhb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ori Nimron <orinimron123@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 035/344] ax25: enforce CAP_NET_RAW for raw sockets
Date:   Thu,  3 Oct 2019 17:50:00 +0200
Message-Id: <20191003154543.547209436@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ori Nimron <orinimron123@gmail.com>

[ Upstream commit 0614e2b73768b502fc32a75349823356d98aae2c ]

When creating a raw AF_AX25 socket, CAP_NET_RAW needs to be checked
first.

Signed-off-by: Ori Nimron <orinimron123@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -855,6 +855,8 @@ static int ax25_create(struct net *net,
 		break;
 
 	case SOCK_RAW:
+		if (!capable(CAP_NET_RAW))
+			return -EPERM;
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;


