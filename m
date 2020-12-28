Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B828D2E675D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgL1NLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgL1NLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22C8C20776;
        Mon, 28 Dec 2020 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161061;
        bh=KEl7a0v7/VsWcOnw1uYWHi/NQyARYMBIfAdhmwLWU78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOtF0a/974/1t8hN3YxCRv0WJDtUeYTUts4ftM47UFBNPRuN/yC4+OCQkmrSNSA71
         ZHZ3+Mm4QS7RNAu7T4eaI0QaHKZUetJZbLffmfW5guouhYFpUzqpo3ysq5GyA7nBI9
         Mp/tJgbDnXMOk/2cG/F4vAmYyMODFo1bOGBV9904=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Bernat <vincent@bernat.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/242] net: evaluate net.ipv4.conf.all.proxy_arp_pvlan
Date:   Mon, 28 Dec 2020 13:48:13 +0100
Message-Id: <20201228124909.029415053@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Bernat <vincent@bernat.ch>

[ Upstream commit 1af5318c00a8acc33a90537af49b3f23f72a2c4b ]

Introduced in 65324144b50b, the "proxy_arp_vlan" sysctl is a
per-interface sysctl to tune proxy ARP support for private VLANs.
While the "all" variant is exposed, it was a noop and never evaluated.
We use the usual "or" logic for this kind of sysctls.

Fixes: 65324144b50b ("net: RFC3069, private VLAN proxy arp support")
Signed-off-by: Vincent Bernat <vincent@bernat.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index ff876bf66cf25..52e1230cfe1b4 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -102,7 +102,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 
 #define IN_DEV_LOG_MARTIANS(in_dev)	IN_DEV_ORCONF((in_dev), LOG_MARTIANS)
 #define IN_DEV_PROXY_ARP(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP)
-#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_CONF_GET(in_dev, PROXY_ARP_PVLAN)
+#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP_PVLAN)
 #define IN_DEV_SHARED_MEDIA(in_dev)	IN_DEV_ORCONF((in_dev), SHARED_MEDIA)
 #define IN_DEV_TX_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), SEND_REDIRECTS)
 #define IN_DEV_SEC_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), \
-- 
2.27.0



