Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BC3396022
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhEaOXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233617AbhEaOVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89534619B9;
        Mon, 31 May 2021 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468674;
        bh=gG6HC9ah17z0IQSAObJ8OUJHcUi6DQ8G3ViJkwYZNzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ew75sL0wO3DbyMY+9ySNo9yAkho3hQd4BQMKeHLf3/bAi/l/TIRvUi24kZGqM2999
         /uqQ4qxrnkhPfj7FabC2kj9Yn6GOcbW0toc8xkNV9fLPW6N5Sx8u2dZhvHyjUE0PXT
         M407P7ROvqHpZBsgiL8b+9BnujYOtA1kQ7ksk4RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 081/177] net: dsa: sja1105: error out on unsupported PHY mode
Date:   Mon, 31 May 2021 15:13:58 +0200
Message-Id: <20210531130650.706192588@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 6729188d2646709941903052e4b78e1d82c239b9 upstream.

The driver continues probing when a port is configured for an
unsupported PHY interface type, instead it should stop.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -178,6 +178,7 @@ static int sja1105_init_mii_settings(str
 		default:
 			dev_err(dev, "Unsupported PHY mode %s!\n",
 				phy_modes(ports[i].phy_mode));
+			return -EINVAL;
 		}
 
 		mii->phy_mac[i] = ports[i].role;


