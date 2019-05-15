Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D6B1F184
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfEOLSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbfEOLSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E16C1206BF;
        Wed, 15 May 2019 11:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919127;
        bh=ytNF6xKI+l+Ujvw5o99E9RlODx9tEh/MtVIcw+U3ptI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaMuoR+SXwqOqASXqedbx2Niuynyx2fmXPNnmSNjmX2FCHuntKKXtZCyMY8TlpPOj
         TqZOxBPTlWAi6dO84n4sUkw/+bx81MbehUBoOkmeYxAudT/fKjbpfd3XmnE2VdeYrE
         kKfv57hmez1nRLIRlTcymoGShNjjqPTpokI1Q0T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 077/115] gtp: change NET_UDP_TUNNEL dependency to select
Date:   Wed, 15 May 2019 12:55:57 +0200
Message-Id: <20190515090704.995704200@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c22da36688d6298f2e546dcc43fdc1ad35036467 ]

Similarly to commit a7603ac1fc8c ("geneve: change NET_UDP_TUNNEL
dependency to select"), GTP has a dependency on NET_UDP_TUNNEL which
makes impossible to compile it if no other protocol depending on
NET_UDP_TUNNEL is selected.

Fix this by changing the depends to a select, and drop NET_IP_TUNNEL from
the select list, as it already depends on NET_UDP_TUNNEL.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index aba0d652095b0..f3357091e9d18 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -212,8 +212,8 @@ config GENEVE
 
 config GTP
 	tristate "GPRS Tunneling Protocol datapath (GTP-U)"
-	depends on INET && NET_UDP_TUNNEL
-	select NET_IP_TUNNEL
+	depends on INET
+	select NET_UDP_TUNNEL
 	---help---
 	  This allows one to create gtp virtual interfaces that provide
 	  the GPRS Tunneling Protocol datapath (GTP-U). This tunneling protocol
-- 
2.20.1



