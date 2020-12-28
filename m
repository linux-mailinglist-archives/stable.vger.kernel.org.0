Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3718C2E6855
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgL1NBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729865AbgL1NBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 346C022582;
        Mon, 28 Dec 2020 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160470;
        bh=Fmm/kgXWpnxgmi4B8ecICshe5ASoWJhbr29YPa50a4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErTX3MOlp5mtE4/LrlPxkPTbU88D9oKr5TRUPH5imDx5rbnOYmpqSpPCY2j7ic9ed
         wveqXcXZwJvTQaL9gK/5wJIWOQJ9svQHHzKgHgi2Oz3FDlnhYbceAGVfNu1En+9w0K
         TQVYOA5JpOsO15Kx+X8o7vq/RhYT88iRlrwwHGDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Bernat <vincent@bernat.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 063/175] net: evaluate net.ipv4.conf.all.proxy_arp_pvlan
Date:   Mon, 28 Dec 2020 13:48:36 +0100
Message-Id: <20201228124856.298104909@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 0e6cd645f67f3..65e88c62db7b2 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -100,7 +100,7 @@ static inline void ipv4_devconf_setall(struct in_device *in_dev)
 
 #define IN_DEV_LOG_MARTIANS(in_dev)	IN_DEV_ORCONF((in_dev), LOG_MARTIANS)
 #define IN_DEV_PROXY_ARP(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP)
-#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_CONF_GET(in_dev, PROXY_ARP_PVLAN)
+#define IN_DEV_PROXY_ARP_PVLAN(in_dev)	IN_DEV_ORCONF((in_dev), PROXY_ARP_PVLAN)
 #define IN_DEV_SHARED_MEDIA(in_dev)	IN_DEV_ORCONF((in_dev), SHARED_MEDIA)
 #define IN_DEV_TX_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), SEND_REDIRECTS)
 #define IN_DEV_SEC_REDIRECTS(in_dev)	IN_DEV_ORCONF((in_dev), \
-- 
2.27.0



