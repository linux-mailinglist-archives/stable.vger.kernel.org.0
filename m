Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7111334B
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbfLDSQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbfLDSNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:13:18 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5503820862;
        Wed,  4 Dec 2019 18:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483197;
        bh=3pT4tzAQDoCWy1rARRfevvK6RgLlOffebbAAx/Ips6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y26ukgRNIeclXz6jVGpjWFVc9jZnDUpJOGlJ++Eh+wvk8zEK9EfC6/jM59s1e/d9/
         KYP2dEQkhtYdcKm5y9s7cbcxAOPpoZlyFS1pJhO/qC2UI3te5ZGtn+8SH0i3nembuG
         pik7rcURSFNE2qME/+++gQemtMObVtK8u+Klck9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/125] decnet: fix DN_IFREQ_SIZE
Date:   Wed,  4 Dec 2019 18:56:38 +0100
Message-Id: <20191204175324.726824069@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 50c2936634bcb1db78a8ca63249236810c11a80f ]

Digging through the ioctls with Al because of the previous
patches, we found that on 64-bit decnet's dn_dev_ioctl()
is wrong, because struct ifreq::ifr_ifru is actually 24
bytes (not 16 as expected from struct sockaddr) due to the
ifru_map and ifru_settings members.

Clearly, decnet expects the ioctl to be called with a struct
like
  struct ifreq_dn {
    char ifr_name[IFNAMSIZ];
    struct sockaddr_dn ifr_addr;
  };

since it does
  struct ifreq *ifr = ...;
  struct sockaddr_dn *sdn = (struct sockaddr_dn *)&ifr->ifr_addr;

This means that DN_IFREQ_SIZE is too big for what it wants on
64-bit, as it is
  sizeof(struct ifreq) - sizeof(struct sockaddr) +
  sizeof(struct sockaddr_dn)

This assumes that sizeof(struct sockaddr) is the size of ifr_ifru
but that isn't true.

Fix this to use offsetof(struct ifreq, ifr_ifru).

This indeed doesn't really matter much - the result is that we
copy in/out 8 bytes more than we should on 64-bit platforms. In
case the "struct ifreq_dn" lands just on the end of a page though
it might lead to faults.

As far as I can tell, it has been like this forever, so it seems
very likely that nobody cares.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/decnet/dn_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index b2c26b081134a..80554e7e9a0f6 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -55,7 +55,7 @@
 #include <net/dn_neigh.h>
 #include <net/dn_fib.h>
 
-#define DN_IFREQ_SIZE (sizeof(struct ifreq) - sizeof(struct sockaddr) + sizeof(struct sockaddr_dn))
+#define DN_IFREQ_SIZE (offsetof(struct ifreq, ifr_ifru) + sizeof(struct sockaddr_dn))
 
 static char dn_rt_all_end_mcast[ETH_ALEN] = {0xAB,0x00,0x00,0x04,0x00,0x00};
 static char dn_rt_all_rt_mcast[ETH_ALEN]  = {0xAB,0x00,0x00,0x03,0x00,0x00};
-- 
2.20.1



