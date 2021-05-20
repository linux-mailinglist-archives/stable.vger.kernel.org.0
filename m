Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8845038A4A8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhETKHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235582AbhETKFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE26061931;
        Thu, 20 May 2021 09:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503670;
        bh=NNf7o5TtM0/vo3qBXO1Tk7tAfNids3yWgN+54b5dk08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCc4EdN5kKfP2V6eOAEa+vgEDO3MDK+tqYkakMX659XIWx0SlAA37fp5TvvHy8bOf
         y3banrWzsTpH/Ox5mGrC1net1njdnSKqiKMnfwG1p5knmB7Ag6Ny/kfWsC3fyuKR26
         S96L0NTw2JJgOTqRXZMXQmRXxZfpZwd/tcLFzZyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 325/425] ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
Date:   Thu, 20 May 2021 11:21:34 +0200
Message-Id: <20210520092142.103294070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit c1d9e34e11281a8ba1a1c54e4db554232a461488 ]

Fix the following out-of-bounds warning:

net/ethtool/ioctl.c:492:2: warning: 'memcpy' offset [49, 84] from the object at 'link_usettings' is out of the bounds of referenced subobject 'base' with type 'struct ethtool_link_settings' at offset 0 [-Warray-bounds]

The problem is that the original code is trying to copy data into a
some struct members adjacent to each other in a single call to
memcpy(). This causes a legitimate compiler warning because memcpy()
overruns the length of &link_usettings.base. Fix this by directly
using &link_usettings and _from_ as destination and source addresses,
instead.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 1011625a0ca4..83028017c26d 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -618,7 +618,7 @@ store_link_ksettings_for_user(void __user *to,
 {
 	struct ethtool_link_usettings link_usettings;
 
-	memcpy(&link_usettings.base, &from->base, sizeof(link_usettings));
+	memcpy(&link_usettings, from, sizeof(link_usettings));
 	bitmap_to_arr32(link_usettings.link_modes.supported,
 			from->link_modes.supported,
 			__ETHTOOL_LINK_MODE_MASK_NBITS);
-- 
2.30.2



