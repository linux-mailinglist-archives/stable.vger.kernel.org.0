Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C9864405C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbiLFJvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbiLFJuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F0F1DA63;
        Tue,  6 Dec 2022 01:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C41615FC;
        Tue,  6 Dec 2022 09:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EA3C43470;
        Tue,  6 Dec 2022 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320205;
        bh=7J2Nn6JsedXBhOJS7mvINO0RGlJ72/HyZdo850Cl6DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mpi+v2pYbGP4OnMuAxOpWkOdElAUYOvewiHAVC+VI1x6Rc1CvDqmd6MAVp4k6/HNg
         Qxdjn+UXdGwGgOC0DqZ4jXwwRIXY7pBx+bQQykJ7CzOS8QFcqLbDCKnUPp3+N/KJj1
         ZynJYFsPSdUichF6aqw0iMofVE8GRruLRdBNKbAHefYYxF0JrkYLVpMyrak5JWtpvI
         dCwZmmKUOZ4JpEgwbiLN+HAwC9b68xuOZjpMSHPnA1ZIzbGegf1HNPGLCll0DYN2k+
         SjgnGqk44w3E6fCinip8+l7/P6wAF6WcqZukD8yfe5ppYWUKbaOhoVloqwOCuJNZqI
         M2hJHp3bJNijw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>, Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/12] libbpf: Use page size as max_entries when probing ring buffer map
Date:   Tue,  6 Dec 2022 04:49:46 -0500
Message-Id: <20221206094955.987437-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094955.987437-1-sashal@kernel.org>
References: <20221206094955.987437-1-sashal@kernel.org>
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
index cd8c703dde71..8f425473ccaa 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -245,7 +245,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_UNSPEC:
 	case BPF_MAP_TYPE_HASH:
-- 
2.35.1

