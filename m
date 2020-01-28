Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF2214B9B1
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgA1OY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732541AbgA1OYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A804A21739;
        Tue, 28 Jan 2020 14:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221465;
        bh=7Ra6XYIggFqUGPLCI3cb/b2nfYudOYiqxKkRdQa3n+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlKuQXyBxZIKjYJ32jxaGC+UKHrDnw99dSbnD28sdIHSOFZBxC0GpzN+tCroH3t3/
         PM24KITu0qiNrtDqFgwZXdHZ09eLJyGfXtSzKQWm+gK9cC0iJiMaJ1+9BEFmjusa3I
         Mq05wBarpW0azUpVRrbtnnTy212krk5KLB2fCSQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 236/271] net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM
Date:   Tue, 28 Jan 2020 15:06:25 +0100
Message-Id: <20200128135910.120857970@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 3546d8f1bbe992488ed91592cf6bf76e7114791a =

The cxgb3 driver for "Chelsio T3-based gigabit and 10Gb Ethernet
adapters" implements a custom ioctl as SIOCCHIOCTL/SIOCDEVPRIVATE in
cxgb_extension_ioctl().

One of the subcommands of the ioctl is CHELSIO_GET_MEM, which appears
to read memory directly out of the adapter and return it to userspace.
It's not entirely clear what the contents of the adapter memory
contains, but the assumption is that it shouldn't be accessible to all
users.

So add a CAP_NET_ADMIN check to the CHELSIO_GET_MEM case. Put it after
the is_offload() check, which matches two of the other subcommands in
the same function which also check for is_offload() and CAP_NET_ADMIN.

Found by Ilja by code inspection, not tested as I don't have the
required hardware.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2440,6 +2440,8 @@ static int cxgb_extension_ioctl(struct n
 
 		if (!is_offload(adapter))
 			return -EOPNOTSUPP;
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
 		if (!(adapter->flags & FULL_INIT_DONE))
 			return -EIO;	/* need the memory controllers */
 		if (copy_from_user(&t, useraddr, sizeof(t)))


