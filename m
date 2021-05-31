Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB84C396215
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhEaOvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233607AbhEaOrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5566861C82;
        Mon, 31 May 2021 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469370;
        bh=mz+zF9TuSyfs7uhpeWIAMiEjdubkV6lZPEcsY9HO6SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/HLAteZbv6f7LuZ5tEPx0B0IeeINjccNpPRhgSa9P07yvwHe3n9MryJ3QRMr8Exx
         ugfq/QgLI4AtmVLWWg2H68blF1SDXgPKGNdbdaNLfJssgawfeGYRHZdVeXZdw57CDI
         ZwRZZAXfbJGauFn+frmIZlVjJEJckvvlKkyL6Hd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 137/296] sctp: fix the proc_handler for sysctl encap_port
Date:   Mon, 31 May 2021 15:13:12 +0200
Message-Id: <20210531130708.491160004@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit b2540cdce6e22ecf3de54daf5129cc37951348cc upstream.

proc_dointvec() cannot do min and max check for setting a value
when extra1/extra2 is set, so change it to proc_dointvec_minmax()
for sysctl encap_port.

Fixes: e8a3001c2120 ("sctp: add encap_port for netns sock asoc and transport")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -307,7 +307,7 @@ static struct ctl_table sctp_net_table[]
 		.data		= &init_net.sctp.encap_port,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &udp_port_max,
 	},


