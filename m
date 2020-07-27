Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A909022F1D9
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgG0OPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730728AbgG0OPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:15:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0C22078E;
        Mon, 27 Jul 2020 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859335;
        bh=vDf3I3nHui18X9VZnDQ3p+uCLmyiMQGiKmwqcvdIqN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFOgPPDCi0+3nzuvZt5pzxYW64hafYGaBi/xamaidgZl6bGCgXlgTYAVuD7RTVYIW
         n3ACjQx08mu7xM4o/OeCShVP7Xn/UA739kMpjqCC4wAAE8PqU+uaQfMW81iB16QMvO
         oeXvpNEn/gSL8by7+PBB0bH4vz1mTPbB/DkQxHWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com,
        Sabrina Dubroca <sd@queasysnail.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/138] geneve: fix an uninitialized value in geneve_changelink()
Date:   Mon, 27 Jul 2020 16:04:22 +0200
Message-Id: <20200727134928.746526420@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 32818c075c54bb0cae44dd6f7ab00b01c52b8372 ]

geneve_nl2info() sets 'df' conditionally, so we have to
initialize it by copying the value from existing geneve
device in geneve_changelink().

Fixes: 56c09de347e4 ("geneve: allow changing DF behavior after creation")
Reported-by: syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com
Cc: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 19d9d78a6df2c..adfdf6260b269 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1615,11 +1615,11 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct netlink_ext_ack *extack)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
+	enum ifla_geneve_df df = geneve->df;
 	struct geneve_sock *gs4, *gs6;
 	struct ip_tunnel_info info;
 	bool metadata;
 	bool use_udp6_rx_checksums;
-	enum ifla_geneve_df df;
 	bool ttl_inherit;
 	int err;
 
-- 
2.25.1



