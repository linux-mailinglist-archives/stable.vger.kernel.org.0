Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A93480045
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbhL0PoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:44:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbhL0PmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A1A61119;
        Mon, 27 Dec 2021 15:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6B6C36AE7;
        Mon, 27 Dec 2021 15:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619727;
        bh=IC61vTCdOIkZiaEohrrd4pnxisTZsBYSuaRxoGWbA2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNhN1FSaZfNFy8v/Q3UwbQ+72OTS8AeK2cD5Dp09tEDpSyyFl9zYYI06YaMKg9MgC
         tmUJ7em609w+Vtw8qqZi12S4sx5XKvOcNumV3o1lBswVkSS7whiI0NDNYxcVbtMyfy
         ZsbyC8dJ5VKZJ+jfx7mMbHHhePmZ/1+fR5g2/MFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/128] net: bridge: Use array_size() helper in copy_to_user()
Date:   Mon, 27 Dec 2021 16:30:22 +0100
Message-Id: <20211227151333.084030254@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 865bfb2affa8eff5182b29aa90803a2df4409834 ]

Use array_size() helper instead of the open-coded version in
copy_to_user(). These sorts of multiplication factors need
to be wrapped in array_size().

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_ioctl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index 793b0db9d9a36..49c268871fc11 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -71,7 +71,8 @@ static int get_fdb_entries(struct net_bridge *br, void __user *userbuf,
 
 	num = br_fdb_fillbuf(br, buf, maxnum, offset);
 	if (num > 0) {
-		if (copy_to_user(userbuf, buf, num*sizeof(struct __fdb_entry)))
+		if (copy_to_user(userbuf, buf,
+				 array_size(num, sizeof(struct __fdb_entry))))
 			num = -EFAULT;
 	}
 	kfree(buf);
@@ -188,7 +189,7 @@ int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user
 			return -ENOMEM;
 
 		get_port_ifindices(br, indices, num);
-		if (copy_to_user(argp, indices, num * sizeof(int)))
+		if (copy_to_user(argp, indices, array_size(num, sizeof(int))))
 			num =  -EFAULT;
 		kfree(indices);
 		return num;
@@ -336,7 +337,8 @@ static int old_deviceless(struct net *net, void __user *uarg)
 
 		args[2] = get_bridge_ifindices(net, indices, args[2]);
 
-		ret = copy_to_user(uarg, indices, args[2]*sizeof(int))
+		ret = copy_to_user(uarg, indices,
+				   array_size(args[2], sizeof(int)))
 			? -EFAULT : args[2];
 
 		kfree(indices);
-- 
2.34.1



