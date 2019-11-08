Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B0F545B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbfKHS4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732563AbfKHS4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E745121924;
        Fri,  8 Nov 2019 18:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239400;
        bh=eMKc4goX+o0cF2TdTsJgEL11/tO3In23PaNzHZC6sI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHMqQ9yXVFEyKrdCUGRjzXq/bBBzMxQd4xJYXZZpr7BfZKkj7lkvZiZT2VBT3pKud
         /5vMsTbSeVyzVo97vlPR2xX5446QxntWBzgiZUWtcyLAVSWn0/OelHP+WjRltakcZ/
         ipTrEM6LsyT+e9H+RIZFT4/saevB11SxHJAEoR3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 26/34] vxlan: check tun_info options_len properly
Date:   Fri,  8 Nov 2019 19:50:33 +0100
Message-Id: <20191108174647.848379113@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174618.266472504@linuxfoundation.org>
References: <20191108174618.266472504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit eadf52cf1852196a1363044dcda22fa5d7f296f7 ]

This patch is to improve the tun_info options_len by dropping
the skb when TUNNEL_VXLAN_OPT is set but options_len is less
than vxlan_metadata. This can void a potential out-of-bounds
access on ip_tun_info.

Fixes: ee122c79d422 ("vxlan: Flow based tunneling")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2049,8 +2049,11 @@ static void vxlan_xmit_one(struct sk_buf
 		label = info->key.label;
 		udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 
-		if (info->options_len)
+		if (info->options_len) {
+			if (info->options_len < sizeof(*md))
+				goto drop;
 			md = ip_tunnel_info_opts(info);
+		}
 	} else {
 		md->gbp = skb->mark;
 	}


