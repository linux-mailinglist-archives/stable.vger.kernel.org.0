Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EAA644032
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiLFJuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiLFJuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59080B9E;
        Tue,  6 Dec 2022 01:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F5BEB818E3;
        Tue,  6 Dec 2022 09:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79720C433D6;
        Tue,  6 Dec 2022 09:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320167;
        bh=LmXO+w8lxg4PxS27ws8bcX65p0aXeu40GsDw4SIwn1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpJYVR5OG8LWCyXfIu5ZG50vWeIC8HCaFLSxzGJK2aVgk6uQkMrRL2RAhZTr6g6CG
         56eET3exVe7k7qvKUC0/HDmV7cPMWxs+s0GpRcyZaraFesMWRGar6ucIcuexnQVSFO
         4BE86nSoagZ2Mj5BbUcE2yv2mwdTXWQhglblGgQXlrsN3klmPq4j+VAeZHHMU7T4pM
         9t7obLoyYwq6wL6XcSXegw9Cj9sbOpubMhv7qmH7rhlcBOtyY6sf5YQuxwi5hZ+OLg
         GK//VY8tm4dtCLVWvQgkg6BrJ5dMU8xfkvbib1D9VyPhUjEm4P3NLn1qWgvMaRhIB5
         dQCPzt18pw8sA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>, Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 04/13] libbpf: Use page size as max_entries when probing ring buffer map
Date:   Tue,  6 Dec 2022 04:49:07 -0500
Message-Id: <20221206094916.987259-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094916.987259-1-sashal@kernel.org>
References: <20221206094916.987259-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 689eb2f1ba46b4b02195ac2a71c55b96d619ebf8 ]

Using page size as max_entries when probing ring buffer map, else the
probe may fail on host with 64KB page size (e.g., an ARM64 host).

After the fix, the output of "bpftool feature" on above host will be
correct.

Before :
    eBPF map_type ringbuf is NOT available
    eBPF map_type user_ringbuf is NOT available

After :
    eBPF map_type ringbuf is available
    eBPF map_type user_ringbuf is available

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221116072351.1168938-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_probes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 6d495656f554..29f7cde10741 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -233,7 +233,7 @@ static int probe_map_create(enum bpf_map_type map_type)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_STRUCT_OPS:
 		/* we'll get -ENOTSUPP for invalid BTF type ID for struct_ops */
-- 
2.35.1

