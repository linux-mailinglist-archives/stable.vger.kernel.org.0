Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D4111D8E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfLCWys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbfLCWyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:54:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3098920803;
        Tue,  3 Dec 2019 22:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413683;
        bh=jSpGLYFvMA/bog854o9Rps6L7KliDegHUV3SKraVXgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMPowx9QLLO9oGGeEmmSeNi93OKONd3xSUvxH/UtXXd2jL7K2y6mheJvnfPLV7ysb
         FB8kkSebeqPrRx9uBy8ub005ZVuY2ny/0Iolx84wC+n2KI16/LSKxZyWZbhqZAj64K
         Hm68qPGo9HS6GX8x/HKjZRI2Kl9aAPdILFC1XNWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 223/321] decnet: fix DN_IFREQ_SIZE
Date:   Tue,  3 Dec 2019 23:34:49 +0100
Message-Id: <20191203223438.717917718@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
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
index bfd43e8f2c06e..3235540f6adff 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -56,7 +56,7 @@
 #include <net/dn_neigh.h>
 #include <net/dn_fib.h>
 
-#define DN_IFREQ_SIZE (sizeof(struct ifreq) - sizeof(struct sockaddr) + sizeof(struct sockaddr_dn))
+#define DN_IFREQ_SIZE (offsetof(struct ifreq, ifr_ifru) + sizeof(struct sockaddr_dn))
 
 static char dn_rt_all_end_mcast[ETH_ALEN] = {0xAB,0x00,0x00,0x04,0x00,0x00};
 static char dn_rt_all_rt_mcast[ETH_ALEN]  = {0xAB,0x00,0x00,0x03,0x00,0x00};
-- 
2.20.1



