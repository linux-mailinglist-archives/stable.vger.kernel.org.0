Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D11480084
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239354AbhL0Pqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43036 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhL0PoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D732610A4;
        Mon, 27 Dec 2021 15:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423EDC36AE7;
        Mon, 27 Dec 2021 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619847;
        bh=bHAlT2Auv42sr73HkXfEGju/Avu+C4jDXipqgYbTj6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npeRPWUFljCR7j36wcCSf3sIMS3Js3ibtmaibEXe9Sw3e4fG7anL4xWoKfd7Bb7ZP
         vc4kWOH1sIY9tfrnPSaAq94xLlyvC2AfhBeGIzB4O+D9PPyNVz+MFTyWNmKZVvt3/V
         GUK3ordMnO/FDsLL3dmtJaIFdWLgw8oowkQlc1JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Arnd Bergmann <arnd@arndb.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/128] net: bridge: fix ioctl old_deviceless bridge argument
Date:   Mon, 27 Dec 2021 16:30:23 +0100
Message-Id: <20211227151333.120464482@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit d95a56207c078e2019cf6659d890ec1e987e8420 ]

Commit 561d8352818f ("bridge: use ndo_siocdevprivate") changed the
source and destination arguments of copy_{to,from}_user in bridge's
old_deviceless() from args[1] to uarg breaking SIOC{G,S}IFBR ioctls.

Commit cbd7ad29a507 ("net: bridge: fix ioctl old_deviceless bridge
argument") fixed only BRCTL_{ADD,DEL}_BRIDGES commands leaving
BRCTL_GET_BRIDGES one untouched.

The fixes BRCTL_GET_BRIDGES as well and has been tested with busybox's
brctl.

Example of broken brctl:
$ brctl show
bridge name     bridge id               STP enabled     interfaces
brctl: can't get bridge name for index 0: No such device or address

Example of fixed brctl:
$ brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.000000000000       no

Fixes: 561d8352818f ("bridge: use ndo_siocdevprivate")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/all/20211223153139.7661-2-repk@triplefau.lt/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index 49c268871fc11..9922497e59f8c 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -337,7 +337,7 @@ static int old_deviceless(struct net *net, void __user *uarg)
 
 		args[2] = get_bridge_ifindices(net, indices, args[2]);
 
-		ret = copy_to_user(uarg, indices,
+		ret = copy_to_user((void __user *)args[1], indices,
 				   array_size(args[2], sizeof(int)))
 			? -EFAULT : args[2];
 
-- 
2.34.1



