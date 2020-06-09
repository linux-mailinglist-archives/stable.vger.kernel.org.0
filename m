Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778751F45EC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgFIRsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732222AbgFIRsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:48:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2443207F9;
        Tue,  9 Jun 2020 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724888;
        bh=3VhzeYCfyFo9o7fz5Vi6e9lrLzkvJTjzxHdMTZtg2QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUif5H1sGUTxvRBpHnUJnTP7z9fNCyyI8eBbkDOWwohC44LqRoxyZ01DfMYQDRgbP
         Lw0UeDRYkxfX6wvdnV39omWoW6gJF7f9/cVGe6soAAAQvnG4Sq9Y8Kus5HcZwRhdHs
         p0cr1jIe/tOlctaewY7jyWepJIiyP4sv370FEg0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 22/42] devinet: fix memleak in inetdev_init()
Date:   Tue,  9 Jun 2020 19:44:28 +0200
Message-Id: <20200609174017.889143099@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1b49cd71b52403822731dc9f283185d1da355f97 ]

When devinet_sysctl_register() failed, the memory allocated
in neigh_parms_alloc() should be freed.

Fixes: 20e61da7ffcf ("ipv4: fail early when creating netdev named all or default")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/devinet.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -262,6 +262,7 @@ static struct in_device *inetdev_init(st
 	err = devinet_sysctl_register(in_dev);
 	if (err) {
 		in_dev->dead = 1;
+		neigh_parms_release(&arp_tbl, in_dev->arp_parms);
 		in_dev_put(in_dev);
 		in_dev = NULL;
 		goto out;


