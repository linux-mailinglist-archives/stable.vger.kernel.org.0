Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B92548325E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiACO1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiACO02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:26:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE371C0617A2;
        Mon,  3 Jan 2022 06:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F4956111D;
        Mon,  3 Jan 2022 14:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FED7C36AEF;
        Mon,  3 Jan 2022 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219986;
        bh=agwdnGAEpc7ULTMUZmSlQW9OOZxpD6RdfcevJ9+3FTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGaGvndrBBda4DPYTNJA7BocFLFYdCQ/h3+C5+6hKgG6B4I54+GyPeszEcU87EDfB
         dt0IoHYRcJd/lKyBD3Y49q2uHmgu88VYIortsIQKN4vNQ0sfEgXdVtnpn9yl1dGY0D
         7GvH6kotzZxWGxlUwjlLivvGD/YheILkzoxCB6wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/37] udp: using datalen to cap ipv6 udp max gso segments
Date:   Mon,  3 Jan 2022 15:23:50 +0100
Message-Id: <20220103142052.255452766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
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
index 818fc99756256..a71bfa5b02770 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1132,7 +1132,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
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



