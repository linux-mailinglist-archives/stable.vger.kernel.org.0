Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A21EC1783
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfI2RgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730750AbfI2RgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:36:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A6921925;
        Sun, 29 Sep 2019 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778568;
        bh=zhxvTAlmsZKSS7jpSeHn3u1UG03P6G5MH4amv/FmMXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odGRG7QYRja8g9X+bl+V2vPcM9KHIQUStyYQSTqEhRC8+ASH1jx/cWhsPa0CQI+2W
         KSCXT3s05809Fe1MvsSbz6vOk88PShixzCEPe11jok7qDnQnoCB8hmw6HivmOorESB
         bzw42qFUo0SKg358h6zBDSp269nzkq74CS4n6LYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/23] security: smack: Fix possible null-pointer dereferences in smack_socket_sock_rcv_skb()
Date:   Sun, 29 Sep 2019 13:35:26 -0400
Message-Id: <20190929173535.9744-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173535.9744-1-sashal@kernel.org>
References: <20190929173535.9744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 3f4287e7d98a2954f20bf96c567fdffcd2b63eb9 ]

In smack_socket_sock_rcv_skb(), there is an if statement
on line 3920 to check whether skb is NULL:
    if (skb && skb->secmark != 0)

This check indicates skb can be NULL in some cases.

But on lines 3931 and 3932, skb is used:
    ad.a.u.net->netif = skb->skb_iif;
    ipv6_skb_to_auditdata(skb, &ad.a, NULL);

Thus, possible null-pointer dereferences may occur when skb is NULL.

To fix these possible bugs, an if statement is added to check skb.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0d5ce7190b17e..09119c43525ed 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4031,6 +4031,8 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 			skp = smack_ipv6host_label(&sadd);
 		if (skp == NULL)
 			skp = smack_net_ambient;
+		if (skb == NULL)
+			break;
 #ifdef CONFIG_AUDIT
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		ad.a.u.net->family = family;
-- 
2.20.1

