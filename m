Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638004996FC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376644AbiAXVIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56160 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445320AbiAXVCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C690B81057;
        Mon, 24 Jan 2022 21:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70613C340E5;
        Mon, 24 Jan 2022 21:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058165;
        bh=MMPMmtVSLrtuyr7cLejn7b26l10ZVjMuBWZcYg26WQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft1zlP+JT9w94b5TJ+snE25Sy8phg8EBFwdWdLDsRCPfaKaoO7fZIgZXRLb3jt8kO
         7p1YtwrTZK947uTrXGo7T+JET16eQ77X/lC7cJP/XF0CCcZ9XVfxhrOh7eQzl9DxgR
         s9pq5F4yfMq8VsxpYp6VCd2Ns4Xr7RISZfqfyYzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0201/1039] igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
Date:   Mon, 24 Jan 2022 19:33:10 +0100
Message-Id: <20220124184132.088197008@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 4fa8fcd3440101dbacf4fae91de69877ef751977 ]

Driver already implicitly supports XDP metadata access in AF_XDP
zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
data_meta equal data.

This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
igc_construct_skb_zc() will construct an invalid SKB packet. The
function correctly include the xdp->data_meta area in the memcpy, but
forgot to pull header to take metasize into account.

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index d28a80a009537..d83e665b3a4f2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2448,8 +2448,10 @@ static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 
 	skb_reserve(skb, xdp->data_meta - xdp->data_hard_start);
 	memcpy(__skb_put(skb, totalsize), xdp->data_meta, totalsize);
-	if (metasize)
+	if (metasize) {
 		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	return skb;
 }
-- 
2.34.1



