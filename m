Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE65F11B495
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732468AbfLKPZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732926AbfLKPY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:24:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE60724658;
        Wed, 11 Dec 2019 15:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077899;
        bh=v+sWtlARkp7pEjZCr67ok4GUfzy/pMIxtzAZLAoB/BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhdvbNovXKLRr0QL1IsEiDewp52TEz2MmXFaWKNykyVyM+Jg9Z8REx1oyB0zf+Xzd
         MVEom6Y7y9ZM/M40cusco0VraUaCEuhvT+rZVQkuug3dNWfNPyl6HKN4vlvdGn1FRk
         BhYT7Q6VxSdkughEyH2p1inl/aW7Ta+jQ8KmoA80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Julien Floret <julien.floret@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 213/243] xfrm interface: avoid corruption on changelink
Date:   Wed, 11 Dec 2019 16:06:15 +0100
Message-Id: <20191211150353.723385635@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit e9e7e85d75f3731079ffd77c1a66f037aef04fe7 upstream.

The new parameters must not be stored in the netdev_priv() before
validation, it may corrupt the interface. Note also that if data is NULL,
only a memset() is done.

$ ip link add xfrm1 type xfrm dev lo if_id 1
$ ip link add xfrm2 type xfrm dev lo if_id 2
$ ip link set xfrm1 type xfrm dev lo if_id 2
RTNETLINK answers: File exists
$ ip -d link list dev xfrm1
5: xfrm1@lo: <NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0 minmtu 68 maxmtu 1500
    xfrm if_id 0x2 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

=> "if_id 0x2"

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_interface.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -674,12 +674,12 @@ static int xfrmi_changelink(struct net_d
 			   struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
-	struct xfrm_if *xi = netdev_priv(dev);
 	struct net *net = dev_net(dev);
+	struct xfrm_if_parms p;
+	struct xfrm_if *xi;
 
-	xfrmi_netlink_parms(data, &xi->p);
-
-	xi = xfrmi_locate(net, &xi->p);
+	xfrmi_netlink_parms(data, &p);
+	xi = xfrmi_locate(net, &p);
 	if (!xi) {
 		xi = netdev_priv(dev);
 	} else {
@@ -687,7 +687,7 @@ static int xfrmi_changelink(struct net_d
 			return -EEXIST;
 	}
 
-	return xfrmi_update(xi, &xi->p);
+	return xfrmi_update(xi, &p);
 }
 
 static size_t xfrmi_get_size(const struct net_device *dev)


