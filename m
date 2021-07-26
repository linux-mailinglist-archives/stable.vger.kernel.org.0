Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821863D6009
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhGZPUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237023AbhGZPUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 679A860F38;
        Mon, 26 Jul 2021 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315250;
        bh=9QPATj0j3nNfBZVXcRtDXi7i2TMPNMMeWT7KfEhVR6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjYwL/SUL+JgnlWTa9aOmm2feUFEGTBBRizci5/k5x4vOLHmaU5ifBafiugmKYM+8
         WaCzWxIOaw3dolARnsjT02wJq65OoLuUq4ij2jG6JOvgXEzGJjd+Y+eXyhhES0G0CC
         GLGjjGZj9dL7eTWhGvgox+OsOVsbUMi3v6/PmUzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/167] bonding: fix incorrect return value of bond_ipsec_offload_ok()
Date:   Mon, 26 Jul 2021 17:37:35 +0200
Message-Id: <20210726153840.111435054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 168e696a36792a4a3b2525a06249e7472ef90186 ]

bond_ipsec_offload_ok() is called to check whether the interface supports
ipsec offload or not.
bonding interface support ipsec offload only in active-backup mode.
So, if a bond interface is not in active-backup mode, it should return
false but it returns true.

Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9aa2d79aa942..1a795a858630 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -565,7 +565,7 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		err = true;
+		err = false;
 		goto out;
 	}
 
-- 
2.30.2



