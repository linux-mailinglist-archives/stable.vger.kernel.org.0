Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF95010BE1F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbfK0Uv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730473AbfK0Uv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDDE021847;
        Wed, 27 Nov 2019 20:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887887;
        bh=/hFGSIbqhRdSb3z0BkOSlqGrwcilsXLi6GZ64g98xaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTXZbvuiMQq5Y25GpHXDu8hfbKS1HYN/dZm/tKNA2DOM270ZtHAL5BKIjQApFpn9V
         wTiVNOPQea8fh1GBcBXXfWmzb1Jmzc4xmahvkJyr4c2lGaDvkQfDcEagTJGWHhjr8W
         YzX1r9C3hDANrEt5JqLXgMNb5gQLPTklt+iiiPIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radu Rendec <radu.rendec@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/211] macsec: let the administrator set UP state even if lowerdev is down
Date:   Wed, 27 Nov 2019 21:30:29 +0100
Message-Id: <20191127203102.774805953@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 07bddef9839378bd6f95b393cf24c420529b4ef1 ]

Currently, the kernel doesn't let the administrator set a macsec device
up unless its lower device is currently up. This is inconsistent, as a
macsec device that is up won't automatically go down when its lower
device goes down.

Now that linkstate propagation works, there's really no reason for this
limitation, so let's remove it.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: Radu Rendec <radu.rendec@gmail.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 40e8f11f20cbf..9bb65e0af7dd7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2798,9 +2798,6 @@ static int macsec_dev_open(struct net_device *dev)
 	struct net_device *real_dev = macsec->real_dev;
 	int err;
 
-	if (!(real_dev->flags & IFF_UP))
-		return -ENETDOWN;
-
 	err = dev_uc_add(real_dev, dev->dev_addr);
 	if (err < 0)
 		return err;
-- 
2.20.1



