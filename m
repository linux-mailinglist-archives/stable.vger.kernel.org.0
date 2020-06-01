Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E181EAB5B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbgFASQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731733AbgFASQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646C1206E2;
        Mon,  1 Jun 2020 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035401;
        bh=uq8fE0+EZghFhRDJN4QkzA7jiwNaZ0mZo+T10icP6Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKLYb8d4yrE9uyGASRIzHecGueUEpYpl2RjDrKYQn7oBaK7Dt9r1FvBYGElosySSw
         FdKGs2EO0CCvqwzRKSo4oBwkzklhP0n2viY3vvX7a4cWMV/mos0eS6m5IBs0xsrJN6
         wF37Q91i6BZxwj+Tr9jGncUZ+KUsr5D10CZbV8Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.6 144/177] xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
Date:   Mon,  1 Jun 2020 19:54:42 +0200
Message-Id: <20200601174100.476264469@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit afcaf61be9d1dbdee5ec186d1dcc67b6b692180f upstream.

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

The nexthdr from ESP could be NEXTHDR_HOP(0), so it should
continue processing the packet when nexthdr returns 0 in
xfrm_input(). Otherwise, when ipv6 nexthdr is set, the
packet will be dropped.

I don't see any error cases that nexthdr may return 0. So
fix it by removing the check for nexthdr == 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -644,7 +644,7 @@ resume:
 		dev_put(skb->dev);
 
 		spin_lock(&x->lock);
-		if (nexthdr <= 0) {
+		if (nexthdr < 0) {
 			if (nexthdr == -EBADMSG) {
 				xfrm_audit_state_icvfail(x, skb,
 							 x->type->proto);


