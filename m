Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B319B3CA
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732854AbgDAQxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733229AbgDAQbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:31:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F8B20658;
        Wed,  1 Apr 2020 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758692;
        bh=pSzYDhqbXKaw3ZhLbc508OLHR3Hbh840zdWFKzNUWz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZFVL6WvbS6t0XBgUMCOEex3i65FHg0i9Dc7ZfTvfQwb+3O5ME0DVxMjBVlCeKxKY
         vSDYo+H8CA1CaQ3NZoDDZYR2zWXTvXkjQTa/hfp4SuRMGAmHd+OAZGJQKpJJpJ8/jn
         +aWMl3hR8yFOsQcLi3VCiWHulAJW39DQRnbcWLnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Mikko Rapeli <mikko.rapeli@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 46/91] uapi glibc compat: fix outer guard of net device flags enum
Date:   Wed,  1 Apr 2020 18:17:42 +0200
Message-Id: <20200401161529.353085103@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit efc45154828ae4e49c6b46f59882bfef32697d44 ]

Fix a wrong condition preventing the higher net device flags
IFF_LOWER_UP etc to be defined if net/if.h is included before
linux/if.h.

The comment makes it clear the intention was to allow partial
definition with either parts.

This fixes compilation of userspace programs trying to use
IFF_LOWER_UP, IFF_DORMANT or IFF_ECHO.

Fixes: 4a91cb61bb99 ("uapi glibc compat: fix compile errors when glibc net/if.h included before linux/if.h")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 752f5dc040a51..0829d6d5e917a 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -31,7 +31,7 @@
 #include <linux/hdlc/ioctl.h>
 
 /* For glibc compatibility. An empty enum does not compile. */
-#if __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO != 0 && \
+#if __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO != 0 || \
     __UAPI_DEF_IF_NET_DEVICE_FLAGS != 0
 /**
  * enum net_device_flags - &struct net_device flags
@@ -99,7 +99,7 @@ enum net_device_flags {
 	IFF_ECHO			= 1<<18, /* volatile */
 #endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO */
 };
-#endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO != 0 && __UAPI_DEF_IF_NET_DEVICE_FLAGS != 0 */
+#endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO != 0 || __UAPI_DEF_IF_NET_DEVICE_FLAGS != 0 */
 
 /* for compatibility with glibc net/if.h */
 #if __UAPI_DEF_IF_NET_DEVICE_FLAGS
-- 
2.20.1



