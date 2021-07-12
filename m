Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761733C540F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343978AbhGLH4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351992AbhGLHwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BDD60200;
        Mon, 12 Jul 2021 07:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076170;
        bh=o14vWb3+jRL2a3UchK2rerk2/7Px3pF4nwefLNn09nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8AtF93Oib7cvtMUZQAuZQYPpXAutlB4NOW7T4GqBWTVbWLsORuNxejl5QwDCMmjh
         dQijBKxJCObR3VSmzLJH8xva4fmfrrzG/m2ucr0Z99yvG7pRHVKhOFg4n+2zbrPZ0g
         5lul1GjVU9WLUSay1iCWPZD2MrFG1huNskEpmDw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 529/800] xfrm: Fix xfrm offload fallback fail case
Date:   Mon, 12 Jul 2021 08:09:12 +0200
Message-Id: <20210712061023.586595339@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

[ Upstream commit dd72fadf2186fc8a6018f97fe72f4d5ca05df440 ]

In case of xfrm offload, if xdo_dev_state_add() of driver returns
-EOPNOTSUPP, xfrm offload fallback is failed.
In xfrm state_add() both xso->dev and xso->real_dev are initialized to
dev and when err(-EOPNOTSUPP) is returned only xso->dev is set to null.

So in this scenario the condition in func validate_xmit_xfrm(),
if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
                return skb;
returns true, due to which skb is returned without calling esp_xmit()
below which has fallback code. Hence the CRYPTO_FALLBACK is failing.

So fixing this with by keeping x->xso.real_dev as NULL when err is
returned in func xfrm_dev_state_add().

Fixes: bdfd2d1fa79a ("bonding/xfrm: use real_dev instead of slave_dev")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6d6917b68856..e843b0d9e2a6 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -268,6 +268,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		xso->num_exthdrs = 0;
 		xso->flags = 0;
 		xso->dev = NULL;
+		xso->real_dev = NULL;
 		dev_put(dev);
 
 		if (err != -EOPNOTSUPP)
-- 
2.30.2



