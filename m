Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018EA4427E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbfFMQXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731034AbfFMIh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:37:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC89C21473;
        Thu, 13 Jun 2019 08:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415078;
        bh=X+R5vzI3sP3DJBHPZdTdhePeFCbETwqSZUEN09NkQjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCDCczUYgm6G+WxEidmZKZqp97q9ZIqXtIatdAeICyHm4jb+VRqSeCU7ZxGhiOQvb
         BjzEEQijYQ6J7mJCF+A+nvr/XGWVp7eZ+rvrop53dm+xxulUOb1wg75oInEPiFiWcs
         Itgy6CC3TaSkMgAFhski253d1KxhbbZhFo6ANdzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Peng Fan <peng.fan@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 78/81] percpu: do not search past bitmap when allocating an area
Date:   Thu, 13 Jun 2019 10:34:01 +0200
Message-Id: <20190613075654.739666493@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
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
index bc58bcbe4b60..9beb84800d8d 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -984,7 +984,8 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
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



