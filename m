Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EF419B0FB
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbgDAQa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387793AbgDAQa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:30:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E90A212CC;
        Wed,  1 Apr 2020 16:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758655;
        bh=IVevopt4tpFjF//N5RzWcfrUTFmM9C5XwhNWWFkXLCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhjuoKuzWlcecfzvi1jgGzvbfUdugdsqm4879Q/FHzwbP/XgkxZp3qD9S6nqg4Bfj
         bk2/DCxK/hgNIPwydwmVOruq22MRivI1pPjqGQsFb+Ho3lcpRzWItPGC1CuixHTBOl
         9hTLm1p9D9g6JgV6gitQGjzM8nqcAE+eGUFEPaQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 35/91] net: dsa: Fix duplicate frames flooded by learning
Date:   Wed,  1 Apr 2020 18:17:31 +0200
Message-Id: <20200401161526.553430929@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 0e62f543bed03a64495bd2651d4fe1aa4bcb7fe5 ]

When both the switch and the bridge are learning about new addresses,
switch ports attached to the bridge would see duplicate ARP frames
because both entities would attempt to send them.

Fixes: 5037d532b83d ("net: dsa: add Broadcom tag RX/TX handler")
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_brcm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -84,6 +84,8 @@ static struct sk_buff *brcm_tag_xmit(str
 		brcm_tag[2] = BRCM_IG_DSTMAP2_MASK;
 	brcm_tag[3] = (1 << p->port) & BRCM_IG_DSTMAP1_MASK;
 
+	skb->offload_fwd_mark = 1;
+
 	return skb;
 
 out_free:


