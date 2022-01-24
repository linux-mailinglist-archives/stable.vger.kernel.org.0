Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A577B4999A0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455851AbiAXVgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452865AbiAXV1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45869C073227;
        Mon, 24 Jan 2022 12:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D709660B56;
        Mon, 24 Jan 2022 20:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD416C340E5;
        Mon, 24 Jan 2022 20:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055509;
        bh=TXWftH3Lvlt9MHh1xSd+HVBtOTeO7gkjpDkzqXx25Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voiHKdiH30jYYYB/lnu1CUf+MWLedmZVqJnsdI9if0Ttyz5Qses8tGGYUfTHE4f9/
         ysflh+muvc8pXKsflyEo7L0N9BrGc4SNWk8+eLz1AjTpJEtI4SkvKf4l4+w8JxaE0f
         UMCiafFYj/X80WoblbLM7lvU1F/SZqOscBapbcA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/846] igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
Date:   Mon, 24 Jan 2022 19:34:51 +0100
Message-Id: <20220124184106.979687442@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 0a96627391a8c..c7fa978cdf02e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2447,8 +2447,10 @@ static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 
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



