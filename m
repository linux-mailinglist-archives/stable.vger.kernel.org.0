Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE41BC801
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgD1S2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgD1S2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C19AB214AF;
        Tue, 28 Apr 2020 18:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098519;
        bh=VCUEQTgmfZLGjvgi/6tnlrZ8RE72jb9+fRQ4fCctbC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euqOyhEQz+VJFGga9yvpbRX4q7894IuUoI/qOmuMiE6AJc1kRIreYGYHuAAKRo6pL
         OU7yd+DvvdgdpVpZgkQpXDV6K6Ryf9kGBNm6RzowjlfDUEFf2/4dh9HhNkS1nTaWFw
         ewLShZE2rhkMBdwu0zEEUgr2dllsfTCLkH0HiWpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 065/167] net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
Date:   Tue, 28 Apr 2020 20:24:01 +0200
Message-Id: <20200428182233.201072476@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 2e97b0cd1651a270f3a3fcf42115c51f3284c049 ]

When VLAN is enabled, and an ARL search is issued, we also need to
compare the full {MAC,VID} tuple before returning a successful search
result.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1485,6 +1485,9 @@ static int b53_arl_read(struct b53_devic
 			continue;
 		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
 			continue;
+		if (dev->vlan_enabled &&
+		    ((mac_vid >> ARLTBL_VID_S) & ARLTBL_VID_MASK) != vid)
+			continue;
 		*idx = i;
 	}
 


