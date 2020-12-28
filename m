Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD8E2E3C84
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437204AbgL1ODo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437197AbgL1ODn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 015BB205CB;
        Mon, 28 Dec 2020 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164208;
        bh=4qUT6tC2xgZIPjC7ymiaJDr1MFzALDWyl3GbY7lufFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SsqTeJZIdm7L2wELjsD42cgjZPE845n6OK/sACGF5lqPkyOYXE7OXaOz4LmdY5B2l
         jZ7Iw2422d+EePw9DmtWRQMzGt0bw7MQKreJMdO2faU2xlQ1RLh1lo9WLg+Z7Te4xa
         jBVZLDweC7B6VEZc05PMAXPUJr2oURHWtjqlkY3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Bernat <vincent@bernat.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/717] net: evaluate net.ipv4.conf.all.proxy_arp_pvlan
Date:   Mon, 28 Dec 2020 13:41:37 +0100
Message-Id: <20201228125025.717647172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 3bbcddd22df8c..53aa0343bf694 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -105,7 +105,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 
 #define IN_DEV_LOG_MARTIANS(in_dev)	IN_DEV_ORCONF((in_dev), LOG_MARTIANS)
 #define IN_DEV_PROXY_ARP(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP)
-#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_CONF_GET(in_dev, PROXY_ARP_PVLAN)
+#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP_PVLAN)
 #define IN_DEV_SHARED_MEDIA(in_dev)	IN_DEV_ORCONF((in_dev), SHARED_MEDIA)
 #define IN_DEV_TX_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), SEND_REDIRECTS)
 #define IN_DEV_SEC_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), \
-- 
2.27.0



