Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD100E6971
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfJ0VG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbfJ0VG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:06:27 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743F021726;
        Sun, 27 Oct 2019 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210387;
        bh=08EyPMWXekNJLiSe9LQnpbcaa7A9FVw94OUmQbSszqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnilNyyzoc6rMl1YiWQAdylMWqArSFffInusDRxeBbt+BwMDg//ZVPjdLly2TXtsI
         3jHQbxLFOi3fV6i6MDV4k1VXP8ZSjdpL67MBsGNnuWjppWaQhJGLGISztrr76ZzwY6
         SpCGCcJl1PYOZ/xTgRwzuHJDHa3FTWc37FzmA9Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ajay Kaher <akaher@vmware.com>
Subject: [PATCH 4.9 48/49] Revert "net: sit: fix memory leak in sit_init_net()"
Date:   Sun, 27 Oct 2019 22:01:26 +0100
Message-Id: <20191027203207.296444377@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Kaher <akaher@vmware.com>

This reverts commit 375d6d454a95ebacb9c6eb0b715da05a4458ffef which is
commit 07f12b26e21ab359261bf75cfcb424fdc7daeb6d upstream.

Unnecessarily calling free_netdev() from sit_init_net().
ipip6_dev_free() of 4.9.y called free_netdev(), so no need
to call again after ipip6_dev_free().

Cc: Mao Wenan <maowenan@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Reviewed-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1856,7 +1856,6 @@ static int __net_init sit_init_net(struc
 
 err_reg_dev:
 	ipip6_dev_free(sitn->fb_tunnel_dev);
-	free_netdev(sitn->fb_tunnel_dev);
 err_alloc_dev:
 	return err;
 }


