Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5D4999C2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349916AbiAXVhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33280 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447592AbiAXVLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:11:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 882A8B8122A;
        Mon, 24 Jan 2022 21:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A394C340E5;
        Mon, 24 Jan 2022 21:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058661;
        bh=19hz3DN36gB56Klljxe2nsrN2tOxcnraYLZOEAd9hso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmPnuL5Roko1PNAA3VsHj4WTMADlWBXBMYf3cMt6Xea1uG6mnbaYtdPaMOKKWdE4x
         WdOkCiqcFQpXG5ztfHliRjM2TkRvwbh87uqPTOlME+/PuhaHhKR1zrcOmSrWLiZVC5
         H9JRdGpmCYSXaeL1vA4Z2umyT6OTJg3IlBEqmPsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TCS Robot <tcs_robot@tencent.com>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Joanne Koong <joannekoong@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0361/1039] bpf: Add missing map_get_next_key method to bloom filter map.
Date:   Mon, 24 Jan 2022 19:35:50 +0100
Message-Id: <20220124184137.412435046@linuxfoundation.org>
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

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit 3ccdcee28415c4226de05438b4d89eb5514edf73 ]

Without it, kernel crashes in map_get_next_key().

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Joanne Koong <joannekoong@fb.com>
Link: https://lore.kernel.org/bpf/1640776802-22421-1-git-send-email-tcs.kernel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bloom_filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index 277a05e9c9849..b141a1346f72d 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -82,6 +82,11 @@ static int bloom_map_delete_elem(struct bpf_map *map, void *value)
 	return -EOPNOTSUPP;
 }
 
+static int bloom_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	return -EOPNOTSUPP;
+}
+
 static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 {
 	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
@@ -192,6 +197,7 @@ const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = bloom_map_alloc,
 	.map_free = bloom_map_free,
+	.map_get_next_key = bloom_map_get_next_key,
 	.map_push_elem = bloom_map_push_elem,
 	.map_peek_elem = bloom_map_peek_elem,
 	.map_pop_elem = bloom_map_pop_elem,
-- 
2.34.1



