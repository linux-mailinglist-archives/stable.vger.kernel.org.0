Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8274026B45F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgIOXWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbgIOOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31F922475;
        Tue, 15 Sep 2020 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180086;
        bh=TTWkATQ6EXKEp+vAuj7niHV5cTlbg6tkuzwmJGjMVgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKbH1z7GGnYZNqUb8r7HEGSyGgwQktPp8K/+pPaq39RFlpGE7als0rgMVG1ve5Moc
         Qv/pghhfnSjYeU8gne729EAf3YtbbnfUanYp82EZZhhrORMTboBjUU9LzkjNvwiJwy
         Z//GdRSWL6kC4LFDQu+8pldhKoGi6pHUNqimRJ5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 104/177] drivers/net/wan/hdlc: Change the default of hard_header_len to 0
Date:   Tue, 15 Sep 2020 16:12:55 +0200
Message-Id: <20200915140658.634720606@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 2b7bcd967a0f5b7ac9bb0c37b92de36e073dd119 ]

Change the default value of hard_header_len in hdlc.c from 16 to 0.

Currently there are 6 HDLC protocol drivers, among them:

hdlc_raw_eth, hdlc_cisco, hdlc_ppp, hdlc_x25 set hard_header_len when
attaching the protocol, overriding the default. So this patch does not
affect them.

hdlc_raw and hdlc_fr don't set hard_header_len when attaching the
protocol. So this patch will change the hard_header_len of the HDLC
device for them from 16 to 0.

This is the correct change because both hdlc_raw and hdlc_fr don't have
header_ops, and the code in net/packet/af_packet.c expects the value of
hard_header_len to be consistent with header_ops.

In net/packet/af_packet.c, in the packet_snd function,
for AF_PACKET/DGRAM sockets it would reserve a headroom of
hard_header_len and call dev_hard_header to fill in that headroom,
and for AF_PACKET/RAW sockets, it does not reserve the headroom and
does not call dev_hard_header, but checks if the user has provided a
header of length hard_header_len (in function dev_validate_header).

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 386ed2aa31fd9..9b00708676cf7 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -229,7 +229,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->min_mtu		 = 68;
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
-	dev->hard_header_len	 = 16;
+	dev->hard_header_len	 = 0;
 	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
-- 
2.25.1



