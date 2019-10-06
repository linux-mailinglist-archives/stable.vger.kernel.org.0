Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AC4CD3E0
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfJFRTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbfJFRTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:19:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D5CB20862;
        Sun,  6 Oct 2019 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382390;
        bh=6WSWZ02RsQ66w1zpCEaXKB2vQXYZViz7eKNvbYXWB24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tojbrY3GX+MuheesopMFxDMFm/nJw6k/aPby5FVhMYisN8w1gVo1hfnN53R/28Rrg
         dvXlif5mg2IptWqomvwksFaVMgyf0AeIWX+HAmNG+tcDOeLm2xYXNuZLUsVQcGZIK5
         LYbeZAgjLfdcsx4qFPMmtV3jF43NVW4g0/LF9eQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/36] security: smack: Fix possible null-pointer dereferences in smack_socket_sock_rcv_skb()
Date:   Sun,  6 Oct 2019 19:19:00 +0200
Message-Id: <20191006171052.639006834@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9db7c80a74aa5..b76075dbd6fc8 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3986,6 +3986,8 @@ access_check:
 			skp = smack_ipv6host_label(&sadd);
 		if (skp == NULL)
 			skp = smack_net_ambient;
+		if (skb == NULL)
+			break;
 #ifdef CONFIG_AUDIT
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		ad.a.u.net->family = sk->sk_family;
-- 
2.20.1



