Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1A18B6D8
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbgCSNXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730306AbgCSNXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1238206D7;
        Thu, 19 Mar 2020 13:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624187;
        bh=M3tpY7xARF8p9JJiyj/NDGxEIXft6hv4AOv3H5Ace84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR4ZUeQ1wJHOKYKVVdevZxFl+1heqsLb3ClPuHGh61FXmpgNMXyVkDOXC+qRQTba7
         FFkCNZDE7dQtJhBv69LvmaLa1iS9AIDgExXoTkmXLmkGFD08IOVVLLfmPOPDUEZk9W
         GYeaVbmllO1OSsMNErMRWJ2PiAzk79LjueLt1EGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/60] slip: not call free_netdev before rtnl_unlock in slip_open
Date:   Thu, 19 Mar 2020 14:04:15 +0100
Message-Id: <20200319123931.463942483@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit f596c87005f7b1baeb7d62d9a9e25d68c3dfae10 ]

As the description before netdev_run_todo, we cannot call free_netdev
before rtnl_unlock, fix it by reorder the code.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 61d7e0d1d77db..8e56a41dd7585 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -863,7 +863,10 @@ static int slip_open(struct tty_struct *tty)
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	sl_free_netdev(sl->dev);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
 	free_netdev(sl->dev);
+	return err;
 
 err_exit:
 	rtnl_unlock();
-- 
2.20.1



