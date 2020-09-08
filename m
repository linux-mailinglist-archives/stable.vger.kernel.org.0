Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB372618A0
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbgIHR6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731561AbgIHQMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6872824864;
        Tue,  8 Sep 2020 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580312;
        bh=EgAZVoJkcU9g96Eq+0GmQBlRdDPDI1IYhg6F0CWfoUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfQ9ih5TvlEbQ69io4lFKbLlpmedTSMgpDQG05W9Ez1s/Tc7w0rtdP44MJhymKh6+
         WW2I0UL9CVJvNRIwYIwGIYa5Tmd51Q+weZH700IVNNOEx7LTzuObcbWiyrdEveDTwp
         pF8eu5ugegZ1cvn7+1I+s5xsNQkaAZw64m7saETA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Gabriel Ganne <gabriel.ganne@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/65] gtp: add GTPA_LINK info to msg sent to userspace
Date:   Tue,  8 Sep 2020 17:26:11 +0200
Message-Id: <20200908152218.387702883@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit b274e47d9e3f4dcd4ad4028a316ec22dc4533ac7 ]

During a dump, this attribute is essential, it enables the userspace to
know on which interface the context is linked to.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 090607e725a24..d3ccd6929579a 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1187,6 +1187,7 @@ static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 		goto nlmsg_failure;
 
 	if (nla_put_u32(skb, GTPA_VERSION, pctx->gtp_version) ||
+	    nla_put_u32(skb, GTPA_LINK, pctx->dev->ifindex) ||
 	    nla_put_be32(skb, GTPA_PEER_ADDRESS, pctx->peer_addr_ip4.s_addr) ||
 	    nla_put_be32(skb, GTPA_MS_ADDRESS, pctx->ms_addr_ip4.s_addr))
 		goto nla_put_failure;
-- 
2.25.1



