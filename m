Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B9628B698
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgJLNfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730687AbgJLNek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1761D2087E;
        Mon, 12 Oct 2020 13:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509679;
        bh=Je0JIiKHXIl9tbT6967+zOl/koGfFKKM7XpiPpCFVi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztcH9RwBxENIFzePxgk5oz77ayd+rcrtaKn+Q0kz2t2Osw1Gqk031NSzpazfpac8C
         pM2VHwKjrGaeDhtyJYUCqnYmN5t6ZwzTlzd0rc3qiBGvYSywQsmR57505NHD+xqyfN
         Jvdt84O/YHz47Wtjlune7oE7Ze69PSrQuEZelXZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 38/54] team: set dev->needed_headroom in team_setup_by_port()
Date:   Mon, 12 Oct 2020 15:27:00 +0200
Message-Id: <20201012132631.344152387@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 89d01748b2354e210b5d4ea47bc25a42a1b42c82 upstream.

Some devices set needed_headroom. If we ignore it, we might
end up crashing in various skb_push() for example in ipgre_header()
since some layers assume enough headroom has been reserved.

Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/team/team.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2085,6 +2085,7 @@ static void team_setup_by_port(struct ne
 	dev->header_ops	= port_dev->header_ops;
 	dev->type = port_dev->type;
 	dev->hard_header_len = port_dev->hard_header_len;
+	dev->needed_headroom = port_dev->needed_headroom;
 	dev->addr_len = port_dev->addr_len;
 	dev->mtu = port_dev->mtu;
 	memcpy(dev->broadcast, port_dev->broadcast, port_dev->addr_len);


