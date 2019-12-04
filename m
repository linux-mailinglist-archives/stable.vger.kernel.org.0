Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E44113406
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfLDSGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729976AbfLDSGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:36 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D989421772;
        Wed,  4 Dec 2019 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482795;
        bh=fIDkp3nQknwUGs/jEnpCYRRi9+4jX4CW2Ox9ygyMYls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cibv5LKQ94tqGT2y4C9E6vgHXrjyfjsBGahICzSIMs0BI/yxhuv/XiRmbZqszTruK
         Dg08Y7mOF3835YNdOtrw/yWjTIJyaXr/eTwUkK+1cKPX4hgiIHy+BhH3sJ3LCh6ONt
         YCBBrmx53c8dkEoynN+XUqIWecBvBuhD/MkxnqZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/209] decnet: fix DN_IFREQ_SIZE
Date:   Wed,  4 Dec 2019 18:55:47 +0100
Message-Id: <20191204175332.530697021@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
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
index df042b6d80b83..22876a197ebec 100644
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



