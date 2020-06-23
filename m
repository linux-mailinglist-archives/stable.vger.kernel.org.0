Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD286205E09
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389488AbgFWUTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388242AbgFWUTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7725B21527;
        Tue, 23 Jun 2020 20:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943556;
        bh=pSVsRXw/pYi5VXLK2j/10xtjqr7kTVC3Yyz/OhoyC/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXB58H7XqsehBGr3HNQAwN9gtEjPhHKzGF21mYoEs0IBKJp/DOj6kT/Qm5tYGVNRl
         bkV2UexQwsNizrcSY8F6As41x/SfqaZE97w4xEFdq9PUUs7W5x0AIykx5WqHCCinzv
         1Ogtff0oVQOl5WCIoY9CroYNaAy5Cw0PZ7sxqXPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin <martin.varghese@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 408/477] bareudp: Fixed configuration to avoid having garbage values
Date:   Tue, 23 Jun 2020 21:56:45 +0200
Message-Id: <20200623195426.822648708@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

[ Upstream commit b15bb8817f991497d97ae55d8c0e349a9d1e1478 ]

Code to initialize the conf structure while gathering the configuration
of the device was missing.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Martin <martin.varghese@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index efd1a1d1f35e0..5d3c691a1c668 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -552,6 +552,8 @@ static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
 static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 			struct netlink_ext_ack *extack)
 {
+	memset(conf, 0, sizeof(*conf));
+
 	if (!data[IFLA_BAREUDP_PORT]) {
 		NL_SET_ERR_MSG(extack, "port not specified");
 		return -EINVAL;
-- 
2.25.1



