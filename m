Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF044132
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfFMQLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731228AbfFMInY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:43:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A1520851;
        Thu, 13 Jun 2019 08:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415404;
        bh=hl24VVvg0WHnOQ8duYPgK3vulFrvc8liJAJzLpX4tUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2oaWVYJXU8/lOdKa8EzjsRq6a+ZcBKecL3diZQBZwHdWvSwuyCYcXMZyqN1mssKi
         2YzOeaW2A5bivQd/0zrywnPT/w3YUhKr0gWyeI/ry87zm1ZSnqmQbgWGC63wz07ol4
         spfsHua3vZjw36rZCZjB7nVlTTwFeNA37xim4NLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Peng Fan <peng.fan@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/118] percpu: do not search past bitmap when allocating an area
Date:   Thu, 13 Jun 2019 10:34:11 +0200
Message-Id: <20190613075650.852200846@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8c43004af01635cc9fbb11031d070e5e0d327ef2 ]

pcpu_find_block_fit() guarantees that a fit is found within
PCPU_BITMAP_BLOCK_BITS. Iteration is used to determine the first fit as
it compares against the block's contig_hint. This can lead to
incorrectly scanning past the end of the bitmap. The behavior was okay
given the check after for bit_off >= end and the correctness of the
hints from pcpu_find_block_fit().

This patch fixes this by bounding the end offset by the number of bits
in a chunk.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/percpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index c66149ce1fe6..ff76fa0b7528 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -988,7 +988,8 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
 	/*
 	 * Search to find a fit.
 	 */
-	end = start + alloc_bits + PCPU_BITMAP_BLOCK_BITS;
+	end = min_t(int, start + alloc_bits + PCPU_BITMAP_BLOCK_BITS,
+		    pcpu_chunk_map_bits(chunk));
 	bit_off = bitmap_find_next_zero_area(chunk->alloc_map, end, start,
 					     alloc_bits, align_mask);
 	if (bit_off >= end)
-- 
2.20.1



