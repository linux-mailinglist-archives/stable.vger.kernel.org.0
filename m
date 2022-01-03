Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492714832BD
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiACOai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58790 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiACO2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD5F61118;
        Mon,  3 Jan 2022 14:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F570C36AED;
        Mon,  3 Jan 2022 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220111;
        bh=RIN9MxHkGM0usSKtn+wpqY8o5A4d61GsOKzm91kSsiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/1bRPivrgPMjvf85NzOQJbfKic5q2yrFLTUpN3BgKdcQRixtDkYWsDEy8NwmxsG9
         h1eumevoTF2IL/IKP9+TGmMz35pRQGObDS94M1H7vSwrvoJdBYdswbAfngpCe+hBQI
         oMKD7pf5FXCpND8MFxUmHTmWyKy/6v+vcGfrWgGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/48] udp: using datalen to cap ipv6 udp max gso segments
Date:   Mon,  3 Jan 2022 15:23:51 +0100
Message-Id: <20220103142053.951640888@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

[ Upstream commit 736ef37fd9a44f5966e25319d08ff7ea99ac79e8 ]

The max number of UDP gso segments is intended to cap to
UDP_MAX_SEGMENTS, this is checked in udp_send_skb().

skb->len contains network and transport header len here, we should use
only data len instead.

This is the ipv6 counterpart to the below referenced commit,
which missed the ipv6 change

Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")
Signed-off-by: Coco Li <lixiaoyan@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20211223222441.2975883-1-lixiaoyan@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8a1863146f34c..069551a04369e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1189,7 +1189,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
+		if (datalen > cork->gso_size * UDP_MAX_SEGMENTS) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-- 
2.34.1



