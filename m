Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A01AE19B1B0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388953AbgDAQhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388947AbgDAQhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:37:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFEB20658;
        Wed,  1 Apr 2020 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759037;
        bh=nSL2VlQVTb3GPKokrRs/RPqS8c005cAw2vMQezf9gH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFYPp/DSuEY2iXjm4C6SQe8eJYEx0SA5VaDLrRhallm6mPfu5/qHjNPlFdLdXfw6+
         Hw/wtUy5l0NwaJ2S5anj2xlDzorVx1d+ZojmxP6nY6H9yCR1kPWcVNvVthp0Scaob3
         hJ0uko0GiNlqde8hRN2QWAceeFIswlQwbVGARyuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 039/102] macsec: restrict to ethernet devices
Date:   Wed,  1 Apr 2020 18:17:42 +0200
Message-Id: <20200401161540.230054565@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b06d072ccc4b1acd0147b17914b7ad1caa1818bb ]

Only attach macsec to ethernet devices.

Syzbot was able to trigger a KMSAN warning in macsec_handle_frame
by attaching to a phonet device.

Macvlan has a similar check in macvlan_port_create.

v1->v2
  - fix commit message typo

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -19,6 +19,7 @@
 #include <net/genetlink.h>
 #include <net/sock.h>
 #include <net/gro_cells.h>
+#include <linux/if_arp.h>
 
 #include <uapi/linux/if_macsec.h>
 
@@ -3219,6 +3220,8 @@ static int macsec_newlink(struct net *ne
 	real_dev = __dev_get_by_index(net, nla_get_u32(tb[IFLA_LINK]));
 	if (!real_dev)
 		return -ENODEV;
+	if (real_dev->type != ARPHRD_ETHER)
+		return -EINVAL;
 
 	dev->priv_flags |= IFF_MACSEC;
 


