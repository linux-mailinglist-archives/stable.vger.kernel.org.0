Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D4206135
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391757AbgFWUgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391754AbgFWUf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:35:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD7920836;
        Tue, 23 Jun 2020 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944559;
        bh=+YPoB9eHkOMFYGLz+Lv8xbqdACT5IpHWZ4XdKQJ1088=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDmySFafKbt6iMN7cg/jATAB6h8r1nUP3qn4Liwjj2xQgt6Iz+z/CaEy6h+hY+Lv5
         KbwvTe8vcyS8fuIV78EmUqLzQEAdDPTM2ZhicJ3CDa9fogP53KD2Atw0Wz4hwLWUHX
         xmTcMen0T8o+SIUfsuTV+RX2YBPwdwlzLCBiS2tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/206] yam: fix possible memory leak in yam_init_driver
Date:   Tue, 23 Jun 2020 21:56:05 +0200
Message-Id: <20200623195318.806435031@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 98749b7188affbf2900c2aab704a8853901d1139 ]

If register_netdev(dev) fails, free_netdev(dev) needs
to be called, otherwise a memory leak will occur.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/yam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index ba9df430fca6e..fdab498725878 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1148,6 +1148,7 @@ static int __init yam_init_driver(void)
 		err = register_netdev(dev);
 		if (err) {
 			printk(KERN_WARNING "yam: cannot register net device %s\n", dev->name);
+			free_netdev(dev);
 			goto error;
 		}
 		yam_devs[i] = dev;
-- 
2.25.1



