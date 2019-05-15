Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58241EEBF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731929AbfEOLZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729575AbfEOLZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:25:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671B320818;
        Wed, 15 May 2019 11:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919506;
        bh=lgP2eJjeACuVhUDY1zgIkgmzILEegNIYX0SgacTjsOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX5P+6jIRD72Cuj2Huv7oBVZkbiapBfyVoNsGVgLojVc0C85FmpNvkIE0rn+8hAbd
         r3j07SXywNop6568yyTdxP0uOzJQUnW89a+gvYo/ysp/S3BaAL3MH84sc6BjCUdGRd
         A9SiHK2Ih7tx1fFXzg/ejgB3W50v86mRqp7WDlvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 102/113] tuntap: fix dividing by zero in ebpf queue selection
Date:   Wed, 15 May 2019 12:56:33 +0200
Message-Id: <20190515090701.371335121@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit a35d310f03a692bf4798eb309a1950a06a150620 ]

We need check if tun->numqueues is zero (e.g for the persist device)
before trying to use it for modular arithmetic.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 96f84061620c6("tun: add eBPF based queue selection method")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -599,13 +599,18 @@ static u16 tun_automq_select_queue(struc
 static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
 {
 	struct tun_prog *prog;
+	u32 numqueues;
 	u16 ret = 0;
 
+	numqueues = READ_ONCE(tun->numqueues);
+	if (!numqueues)
+		return 0;
+
 	prog = rcu_dereference(tun->steering_prog);
 	if (prog)
 		ret = bpf_prog_run_clear_cb(prog->prog, skb);
 
-	return ret % tun->numqueues;
+	return ret % numqueues;
 }
 
 static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,


