Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776BD1ECC5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfEOLBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbfEOLBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:01:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8C220881;
        Wed, 15 May 2019 11:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918071;
        bh=F8OCAH8LSQaGPAz3FzY/maYOYkQxcbr473s13hz57MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCUNHE8WMsuTREVZnonfshdPBSzPsPL8JbB8/WtQr9OajUCtBiPu/519JIXyDjA4U
         NYc32bidaOh1Gpq8Ou59u955c8omLA4lnKhgsmwpgB8bsQNKEynCyx183F6h+Hrjf5
         4XhOxZTzO+lCzyjg+bHrCWonmrTAoNqJHySIPie0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 81/86] vlan: disable SIOCSHWTSTAMP in container
Date:   Wed, 15 May 2019 12:55:58 +0200
Message-Id: <20190515090655.851644169@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 873017af778439f2f8e3d87f28ddb1fcaf244a76 ]

With NET_ADMIN enabled in container, a normal user could be mapped to
root and is able to change the real device's rx filter via ioctl on
vlan, which would affect the other ptp process on host. Fix it by
disabling SIOCSHWTSTAMP in container.

Fixes: a6111d3c93d0 ("vlan: Pass SIOC[SG]HWTSTAMP ioctls to real device")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -394,10 +394,12 @@ static int vlan_dev_ioctl(struct net_dev
 	ifrr.ifr_ifru = ifr->ifr_ifru;
 
 	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		if (!net_eq(dev_net(dev), &init_net))
+			break;
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-	case SIOCSHWTSTAMP:
 	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
 			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);


