Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEA2406B8E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhIJMcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233321AbhIJMcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB3A611C8;
        Fri, 10 Sep 2021 12:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277081;
        bh=OXeVcmaZRuTUKGVrk8moUGby6DPKz9eLaKg/d1Gshq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuDkWs520/DV7wovb28dQrhV7bXdTMGue3WMZNgNAoKMyy7YhDwuuy9ovzmao4sk8
         YH47P6xPO6LCf5Xobg0JHX92WeMIttFLtHEodB5IIzecvMgf/OZp/kFs6InJOWBaSY
         BDfEDJj7IHqxkGQz7i11Tgk1cU717x7Pp7wUR9IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.14 02/23] can: c_can: fix null-ptr-deref on ioctl()
Date:   Fri, 10 Sep 2021 14:29:52 +0200
Message-Id: <20210910122916.099047884@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

commit 644d0a5bcc3361170d84fb8d0b13943c354119db upstream.

The pdev maybe not a platform device, e.g. c_can_pci device, in this
case, calling to_platform_device() would not make sense. Also, per the
comment in drivers/net/can/c_can/c_can_ethtool.c, @bus_info should
match dev_name() string, so I am replacing this with dev_name() to fix
this issue.

[    1.458583] BUG: unable to handle page fault for address: 0000000100000000
[    1.460921] RIP: 0010:strnlen+0x1a/0x30
[    1.466336]  ? c_can_get_drvinfo+0x65/0xb0 [c_can]
[    1.466597]  ethtool_get_drvinfo+0xae/0x360
[    1.466826]  dev_ethtool+0x10f8/0x2970
[    1.467880]  sock_ioctl+0xef/0x300

Fixes: 2722ac986e93 ("can: c_can: add ethtool support")
Link: https://lore.kernel.org/r/20210906233704.1162666-1-ztong0001@gmail.com
Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/c_can/c_can_ethtool.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -15,10 +15,8 @@ static void c_can_get_drvinfo(struct net
 			      struct ethtool_drvinfo *info)
 {
 	struct c_can_priv *priv = netdev_priv(netdev);
-	struct platform_device *pdev = to_platform_device(priv->device);
-
 	strscpy(info->driver, "c_can", sizeof(info->driver));
-	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(priv->device), sizeof(info->bus_info));
 }
 
 static void c_can_get_ringparam(struct net_device *netdev,


