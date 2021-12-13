Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7464726DA
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhLMJzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:55:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbhLMJxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:53:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30A46B80E3B;
        Mon, 13 Dec 2021 09:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737FCC341D9;
        Mon, 13 Dec 2021 09:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389196;
        bh=c+Nanvmv232Kvt9ZvvkvFbwT6wldkeoQVZTnja5qiTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmclPldXFZ2ObR99Uk27Yd3yDW8Q4dX5El8ZLqo5QXIucT8CinUjpEGASj9quttP6
         bQtpvr1I3KmlJPHxxFgf2TwlGWPiIwyUIz/sOpCjU+XR44ZucRY4thCWogfR9JdrQB
         v+tGlFG5qtLXfsAuxmpyce1NskSvVB/KkBG963IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 017/171] nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups
Date:   Mon, 13 Dec 2021 10:28:52 +0100
Message-Id: <20211213092945.662335220@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

commit b7e945e228d7df1b1473ef6fd2cdec67433065fb upstream.

The sixth byte of packet data has to be looked up in the sixth group,
not in the seventh one, even if we load the bucket data into ymm6
(and not ymm5, for convenience of tracking stalls).

Without this fix, matching on a MAC address as first field of a set,
if 8-bit groups are selected (due to a small set size) would fail,
that is, the given MAC address would never match.

Reported-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Tested-By: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo_avx2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -886,7 +886,7 @@ static int nft_pipapo_avx2_lookup_8b_6(u
 			NFT_PIPAPO_AVX2_BUCKET_LOAD8(4,  lt, 4, pkt[4], bsize);
 
 			NFT_PIPAPO_AVX2_AND(5, 0, 1);
-			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 6, pkt[5], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 5, pkt[5], bsize);
 			NFT_PIPAPO_AVX2_AND(7, 2, 3);
 
 			/* Stall */


