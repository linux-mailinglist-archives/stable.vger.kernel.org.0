Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2600B232E07
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgG3IQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729830AbgG3IKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:10:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 654552074B;
        Thu, 30 Jul 2020 08:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096630;
        bh=OZYPXWVfMwBquWoDmCQumURZ7Eyv7oOh4xRRvY28ykk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4hPCr0JaPG1PinkJ3w5Ay2p+ejubV5WKkJhgeZ20QlDf+/qXQyWOeq3xz9dSmdvQ
         Cf4ScowlLzlBimfLx3esNAwd4PP2ofrY9XS+Wzd5Qq5os1onFSZfM4+2HNGIoxMhlq
         u4jjTt5QGSUlyQb5VsVrYPOt1ZOGYnzWN0NIH0SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 49/61] net-sysfs: add a newline when printing tx_timeout by sysfs
Date:   Thu, 30 Jul 2020 10:05:07 +0200
Message-Id: <20200730074423.208969293@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 9bb5fbea59f36a589ef886292549ca4052fe676c ]

When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
add a newline for easy reading.

root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
0root@syzkaller:~#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1018,7 +1018,7 @@ static ssize_t show_trans_timeout(struct
 	trans_timeout = queue->trans_timeout;
 	spin_unlock_irq(&queue->_xmit_lock);
 
-	return sprintf(buf, "%lu", trans_timeout);
+	return sprintf(buf, fmt_ulong, trans_timeout);
 }
 
 #ifdef CONFIG_XPS


