Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D5FF7BBB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKKSjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfKKSjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:39:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDCC021783;
        Mon, 11 Nov 2019 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497553;
        bh=EMX2mwMsPDVTT5OCb9gPwQH/OyP+Vv3ygfv94ADuU+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIUFu9v2adjpElE8goL92/ehRPmuSi7gxBJtUHr+HQUcZrBAbd49vyGI8Pd7Jl394
         zUROA0YalKISBoDRsAA12w+QFwg9YhCi705THWvG9KHVjA2qRYitf+AGV0imyFyuZa
         L1x5UH+cTyYBSA8+mRrVVsss6EcvTCqjv8psWlBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 095/105] hv_netvsc: Fix error handling in netvsc_attach()
Date:   Mon, 11 Nov 2019 19:29:05 +0100
Message-Id: <20191111181448.566869694@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 719b85c336ed35565d0f3982269d6f684087bb00 ]

If rndis_filter_open() fails, we need to remove the rndis device created
in earlier steps, before returning an error code. Otherwise, the retry of
netvsc_attach() from its callers will fail and hang.

Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 33c1f6548fb79..5a44b97952669 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -969,7 +969,7 @@ static int netvsc_attach(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		ret = rndis_filter_open(nvdev);
 		if (ret)
-			return ret;
+			goto err;
 
 		rdev = nvdev->extension;
 		if (!rdev->link_state)
@@ -977,6 +977,13 @@ static int netvsc_attach(struct net_device *ndev,
 	}
 
 	return 0;
+
+err:
+	netif_device_detach(ndev);
+
+	rndis_filter_device_remove(hdev, nvdev);
+
+	return ret;
 }
 
 static int netvsc_set_channels(struct net_device *net,
-- 
2.20.1



