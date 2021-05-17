Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6431C383238
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbhEQOqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241033AbhEQOnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5FB161959;
        Mon, 17 May 2021 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261234;
        bh=0FxnTS8m/zJjYrJelCWVmlfLDSTAJ13HGgXco6gqTZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbF1y3YFYfsKYhGBxwSVKj/5gwP8Qa89q1sCbKL3GP3kQe/ld3ps9QXSBHhfR/jPX
         9dQtfE+TT1vpFTb+qqAxyzLm6yhqGQ+R/zwFJ5E4wWtADQKvKNpnxKdJown6VQJW+t
         7CtInmGrTpJgn5b0poLmURBQY3WCxr1w7h6KI0SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 088/329] ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
Date:   Mon, 17 May 2021 15:59:59 +0200
Message-Id: <20210517140305.091775922@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 771688e1b0da..2603966da904 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -489,7 +489,7 @@ store_link_ksettings_for_user(void __user *to,
 {
 	struct ethtool_link_usettings link_usettings;
 
-	memcpy(&link_usettings.base, &from->base, sizeof(link_usettings));
+	memcpy(&link_usettings, from, sizeof(link_usettings));
 	bitmap_to_arr32(link_usettings.link_modes.supported,
 			from->link_modes.supported,
 			__ETHTOOL_LINK_MODE_MASK_NBITS);
-- 
2.30.2



